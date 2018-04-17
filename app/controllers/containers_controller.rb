class ContainersController < ApplicationController
  before_action :must_logged_in

  # POST
  def create
    begin
      raise Exceptions::DockerApiError, t("you_need_more_coins") if current_user.coin_balance < 300

      remote_api = DockerApi.new

      container = Container.new(user_id: current_user.id)
      container.host = remote_api.host
      container.encryption = "aes-256-cfb"

      # full long hash, 64 characters
      container_id = container.container_id =
          JSON.parse(remote_api.create_new_container.body).fetch("Id")

      remote_api.start_container(container_id)

      # short hash, default password, 12 characters
      container.password = container_id[0, 12]

      container_info = JSON.parse(remote_api.inspect_container(container_id).body)
      container.port = container_info["NetworkSettings"]["Ports"]["8388/tcp"][0].fetch("HostPort").to_i

      if container.save
        container.running!
      end


      respond_to do |format|
        format.json { render json: {s: Status::SUCCESS, c: container.to_json} }
        format.js {
          @operate_success = true
          @containers = current_user.containers.where("status = #{Container.statuses[:running]}")
        }
      end


    rescue StandardError => e
      respond_to do |format|
        format.json { render json: {s: Status::FAILED, c: e.message} }
        format.js {
          @operate_success = false
          @hint = e.message
        }
      end

    end
  end


  # POST
  def switch
    begin
      @turn = params[:turn]
      @container = Container.find(params[:id])
      if @container.container_id != params[:container_id]
        raise StandardError, t("wrong_params")
      end

      # todo calc fee

      remote_api = DockerApi.new
      if @turn == "off"

        resp = remote_api.stop_container(params[:container_id])
        @container.stopped!

      elsif @turn == "on"

        resp = remote_api.start_container(params[:container_id])

        # update port
        container_info = JSON.parse(remote_api.inspect_container(params[:container_id]).body)
        @container.port = container_info["NetworkSettings"]["Ports"]["8388/tcp"][0].fetch("HostPort").to_i
        if @container.save
          @container.running!
        end

      else
        raise StandardError, t("wrong_params")
      end

      respond_to do |format|
        format.js {
          @operate_success = true
        }
      end

    rescue StandardError => e
      flash[:danger] = e.message

      respond_to do |format|
        format.js {
          @operate_success = false
        }
      end
    end
  end


  # render a qr image
  def qr
    require 'rqrcode'
    str = params[:str] || ""

    qr = RQRCode::QRCode.new(str)

    qr_img_stream = qr.as_png(
        border_modules: 2,
        color: "24292e"
    ).to_s

    send_data(qr_img_stream, type: 'image/png', disposition: 'inline')
  end

end