module Github
  class LanguagesRepository
    include FaradayClient

    def all(username)
      repos = get_user_repos(username)
      return nil, 'languages cannot be fetched' if repos.nil?

      languages = repos.map { |r| get_languages(username, r['name']) }

      return nil, 'languages cannot be fetched' unless languages.all?

      initial_hash = Hash.new {|h,k| h[k] = 0}

      languages.reduce(initial_hash) do |aggregated_hash, languages_list|
        languages_list.each do |language, count|
          aggregated_hash[language] += count
        end
        aggregated_hash
      end
    end

    private

    def get_languages(username, repo)
      response = client.get("/repos/#{username}/#{repo}/languages")
      return unless response.success?

      JSON.parse(response.body)
    rescue JSON::ParserError => e
      Rails.logger.info "Error while parsing response from GitHub: #{e.message}"
      nil
    end

    def get_user_repos(username)
      response = client.get("/users/#{username}/repos")
      return unless response.success?

      JSON.parse(response.body)
    rescue JSON::ParserError => e
      Rails.logger.info "Error while parsing response from GitHub: #{e.message}"
      nil
    end
  end
end
