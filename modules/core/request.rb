module Core
  class Request

    def self.get(url, data)
      default_request.get(url, data)
    end

    def self.post(url, data)
      default_request.post(url, data)
    end

    def self.put(url, data)
      default_request.put(url, data)
    end

    def self.default_request
      content = {
        url: ENV['BASE_URL_CORE'],
        headers: {'AppAuthorization' => Core.authenticated_header}
      }
      return Faraday.new(content)
    end

  end
end