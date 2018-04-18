class ContainersController < ApplicationController
  before_action :must_logged_in

  # POST
  def create
    begin
      raise Exceptions::LackCoinError, t("you_need_more_coins") if current_user.coin_balance < 300

      remote_api = DockerApi.new

      container = Container.new(user_id: current_user.id)
      container.host = remote_api.host
      container.encryption = "aes-256-cfb"

      # full long hash, 64 characters
      container_hash = container.container_hash =
          JSON.parse(remote_api.create_new_container.body).fetch("Id")
      container.status = :created

      remote_api.start_container(container_hash)

      # short hash, default password, 12 characters
      container.password = container_hash[0, 12]

      container_info = JSON.parse(remote_api.inspect_container(container_hash).body)
      container.port = container_info["NetworkSettings"]["Ports"]["8388/tcp"][0].fetch("HostPort").to_i

      if container.save
        History.new(container).save
        container.running!
        History.new(container).save
      end


      respond_to do |format|
        format.json { render json: {s: Status::SUCCESS, c: container.to_json} }
        format.js {
          @operate_success = true
          @containers =
              current_user.containers.where(
                  "status in (?)",
                  [Container.statuses[:running], Container.statuses[:stopped]]
              )
        }
      end


    rescue Exceptions::LackCoinError => e

      respond_to do |format|
        format.json { render json: {s: Status::FAILED, c: e.message} }
        format.js {
          @operate_success = false
          @hint = e.message
          @containers =
              current_user.containers.where(
                  "status in (?)",
                  [Container.statuses[:running], Container.statuses[:stopped]]
              )
        }
      end


    rescue StandardError => e

      logger.error(e.backtrace.to_s)

      respond_to do |format|
        format.json { render json: {s: Status::FAILED, c: e.message} }
        format.js {
          @operate_success = false
          @hint = e.message
          @containers =
              current_user.containers.where(
                  "status in (?)",
                  [Container.statuses[:running], Container.statuses[:stopped]]
              )
        }
      end

    end
  end


  # POST
  def switch
    begin
      @turn = params[:turn]
      @container = Container.find(params[:id])
      if @container.container_hash != params[:container_hash]
        raise StandardError, t("wrong_params")
      end

      # todo calc fee

      remote_api = DockerApi.new
      if @turn == "off"

        resp = remote_api.stop_container(params[:container_hash])
        @container.stopped!
        History.new(@container).save


      elsif @turn == "on"
        raise Exceptions::LackCoinError, t("you_need_more_coins") if current_user.coin_balance < 300

        resp = remote_api.start_container(params[:container_hash])

        # update port
        container_info = JSON.parse(remote_api.inspect_container(params[:container_hash]).body)
        @container.port = container_info["NetworkSettings"]["Ports"]["8388/tcp"][0].fetch("HostPort").to_i
        if @container.save
          @container.running!
          History.new(@container).save
        end

      else
        raise StandardError, t("wrong_params")
      end

      respond_to do |format|
        format.js {
          @operate_success = true
          @containers =
              current_user.containers.where(
                  "status in (?)",
                  [Container.statuses[:running], Container.statuses[:stopped]]
              )
        }
      end

    rescue Exceptions::LackCoinError => e

      respond_to do |format|
        format.js {
          @hint = e.message
          @operate_success = false
          @containers =
              current_user.containers.where(
                  "status in (?)",
                  [Container.statuses[:running], Container.statuses[:stopped]]
              )
        }
      end

    rescue StandardError => e
      logger.error(e.backtrace.to_s)

      flash[:danger] = e.message

      respond_to do |format|
        format.js {
          @hint = e.message
          @operate_success = false
          @containers =
              current_user.containers.where(
                  "status in (?)",
                  [Container.statuses[:running], Container.statuses[:stopped]]
              )
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