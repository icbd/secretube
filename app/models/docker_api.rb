require 'net/https'
require 'uri'

# open class to justify response.body raise error
# https://www.ruby-forum.com/topic/4407036
class Net::HTTPResponse
  def stream_check
    raise IOError, 'attempt to read body out of block' if @socket and @socket.closed?
  end
end

class DockerApiError < StandardError
end

class DockerApiTimeOutError < DockerApiError
end

# https://docs.docker.com/engine/api/v1.37
class DockerApi

  def initialize(uri=nil, cert_file=nil, key_file=nil)
    uri = Rails.configuration.docker_daemon_uri unless uri
    @uri = URI.parse(uri)

    cert_file = Rails.configuration.docker_daemon_cert_file unless cert_file
    key_file = Rails.configuration.docker_daemon_key_file unless key_file

    @http = Net::HTTP.new(@uri.host, @uri.port)
    @http.use_ssl = true
    @http.cert =OpenSSL::X509::Certificate.new(File.read(cert_file))
    @http.key =OpenSSL::PKey::RSA.new((File.read(key_file)))
    @http.verify_mode = OpenSSL::SSL::VERIFY_NONE # todo VERIFY_PEER

    @docker_remote_api_version = '/v1.37'
  end

  # get host
  def host
    @uri.host
  end

  def ping
    get "/_ping"
  end

  def docker_ps
    get "/containers/json"
  end

  # just create, need manual operation to start container
  def create_new_container
    post "/containers/create",
         {
             "Image" => "shadowsocks/shadowsocks-libev:latest",
             "ExposedPorts" => {
                 "8388/tcp" => {},
                 "8388/udp" => {},
             },
             "HostConfig" => {
                 "Memory" => 10240000000,
                 "PortBindings" => {
                     "8388/tcp" => [{}],
                     "8388/udp" => [{}],
                 }
             }
         }
  end

  def inspect_container(container_id)
    get "/containers/#{container_id}/json"
  end

  def start_container(container_id)
    post "/containers/#{container_id}/start"
  end

  # t: Number of seconds to wait before killing the container
  def stop_container(container_id, t=1)
    post "/containers/#{container_id}/stop?t=#{t.to_i}"
  end

  def kill_container(container_id)
    post "/containers/#{container_id}/kill"
  end

  # force remove even through it's running
  def rm_container(container_id)
    delete "/containers/#{container_id}?force=true"
  end


  private

  # timeout with second
  def get(path, timeout=3)
    request = Net::HTTP::Get.new(@docker_remote_api_version + path)

    http_request request, timeout
  end

  # timeout with second
  def post(path, params={}, timeout = 3)
    request = Net::HTTP::Post.new(@docker_remote_api_version + path)
    request.body = params.to_json
    request.content_type = "application/json"

    http_request request, timeout
  end

  def delete(path, params={}, timeout=3)
    request = Net::HTTP::Delete.new(@docker_remote_api_version + path)
    request.body = params.to_json
    request.content_type = "application/json"

    http_request request, timeout
  end

  def http_request(request, timeout=3)
    @http.read_timeout = timeout
    begin
      response = @http.request(request)
    rescue
      response = Net::HTTPResponse.new("1.1", "408", "TimeOut")
    end
    response
  end
end