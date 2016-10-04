module FaradayClient
  URL = "https://api.github.com"
  TOKEN = "f89ce9dd2a33e05ca073a7b321989e663ae7ff68"

  private

  def client
    @client ||= Faraday.new(url: URL) do |f|
      f.headers['Authorization'] = "token #{TOKEN}"
      f.adapter Faraday.default_adapter
    end
  end
end
