class ContainersController < ApplicationController
  before_action :must_logged_in

  # POST
  # json
  def create
    if current_user.coin_balance < 300
      render json: {s: Status::WARNING, c: t("you_need_more_coins")}
    else
      remote_api = DockerApi.new

      container = Container.new(user_id: current_user.id)
      container.host = remote_api.host
      container.encryption = "aes-256-cfb"

      begin
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


        render json: {s: Status::SUCCESS, c: container.to_json}
      rescue
        render json: {s: Status::FAILED, c: t("system_is_too_busy")}
      end
    end
  end
end