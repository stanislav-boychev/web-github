require 'rails_helper'

describe FavouriteLanguageController, :type => :routing do
  describe 'routing' do
    it 'routes to #show' do
      expect(:get => '/favourite-language/github-username').to route_to('favourite_language#show', username: 'github-username')
    end
  end
end
