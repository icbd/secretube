module Exceptions
  class DockerApiError < StandardError
    def initialize(msg = nil)
      @docker_api_error_msg = msg
    end

    def message
      @docker_api_error_msg || I18n.t("system_is_too_busy")
    end
  end

  class ParamsError < StandardError
  end
  class LackCoinError < StandardError
  end
end