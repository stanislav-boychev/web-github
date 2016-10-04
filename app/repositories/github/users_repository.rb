module Github
  class UsersRepository
    include FaradayClient

    def find(username)
      response = client.get("/users/#{username}")
      return nil, 'user is not found or cannot be fetched' unless response.success?

      JSON.parse(client.get("/users/#{username}").body)
    rescue JSON::ParserError => e
      Rails.logger.info "Error while parsing response from GitHub: #{e.message}"
      return nil, 'user is not found or cannot be fetched'
    end
  end
end
