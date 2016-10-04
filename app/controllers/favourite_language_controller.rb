class FavouriteLanguageController < ApplicationController
  def show
    @username = params[:username]
    @language = Github::FavouriteLanguageService.new.call(@username)
  end
end
