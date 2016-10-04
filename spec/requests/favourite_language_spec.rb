require 'rails_helper'

describe 'FavouriteLanguageController', type: :request do
  describe 'show' do
    let(:url) { Rails.configuration.x.github_url }
    let(:url) { Rails.configuration.x.github_url }
    let(:username) { 'git-user' }
    let(:repo) { 'cool-project' }
    let(:github_user_path) { "/users/#{username}" }
    let(:github_repo_path) { "/users/#{username}/repos" }
    let(:github_lang_path) { "/repos/#{username}/#{repo}/languages" }

    let(:user_body) { { 'login' => username, 'id' => 666 }.to_json }
    let(:repo_body) { [{ 'id' => 123, 'name' => repo }].to_json }
    let(:lang_body) { { 'Python' => 600, 'Ruby' => 200, 'JavaScript' => 100}.to_json }

    let(:faraday) {
      Faraday.new { |builder|
        builder.adapter :test, Faraday::Adapter::Test::Stubs.new { |stub|
          stub.get(github_user_path) { |env| [200, {}, user_body] }
          stub.get(github_repo_path) { |env| [200, {}, repo_body] }
          stub.get(github_lang_path) { |env| [200, {}, lang_body] }
        }
      }
    }

    before {
      allow(Faraday).to receive(:new).with(url: url).and_return(faraday)
    }

    let(:html) { Nokogiri::HTML.parse(response.body) }

    before {
      get favourite_language_path(username)
    }

    it 'returns 200 status code' do
      expect(response).to have_http_status(:ok)
    end

    it 'returns html Python' do
      expect(html.text).to match 'Python'
    end
  end
end
