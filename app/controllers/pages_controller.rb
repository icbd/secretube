class PagesController < ApplicationController
  def welcome
    render layout: false
  end

  def helper

    client = DockerApi.new
    # ans = client.stop_container('f2ab6269a85f', 300)
    ans = client.create_new_container
    # ans = client.inspect_container("97cfa376f1cf597199493310df379166de70357c2360147e664633b3afe47645")
    # ans = client.docker_ps
    # ans = client.ping

    @json = JSON.parse ans.body rescue {}

    render json: @json
  end
end
