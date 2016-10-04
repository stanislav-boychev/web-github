module Github
  class FavouriteLanguageService
    def call(username)
      user = Github::UsersRepository.new.find(username)
      return ErrorResult.new('user cannot be found') if user.nil?
      languages = Github::LanguagesRepository.new.all(username)
      return ErrorResult.new('languages cannot be downloaded from github') unless languages

      most_used_lang = languages.max_by { |_, v| v.to_i }.first
      ServiceResult.new(most_used_lang)
    end
  end
end
