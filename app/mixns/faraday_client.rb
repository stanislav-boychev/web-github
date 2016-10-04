module FaradayClient
  TOKEN = Rails.configuration.x.github_token
  URL = Rails.configuration.x.github_url

  private

  def client
    @client ||= Faraday.new(url: URL) do |f|
      f.headers['Authorization'] = "token #{TOKEN}"
      f.adapter Faraday.default_adapter
    end
  end
end
