require 'rails_helper'

RSpec.describe FavouriteLanguageController, :type => :controller do
  describe 'GET favourite-language/:username' do
    let(:service_factory) { Github::FavouriteLanguageService }
    let(:service) { instance_double(service_factory) }
    let(:service_result) { double('Result') }

    before {
      allow(service_factory).to receive(:new).and_return(service)
      allow(service).to receive(:call).and_return(service_result)
      get :show, username: 'github-username'
    }

    it 'calls the service with the username' do
      expect(service).to have_received(:call).with('github-username')
    end

    it 'response with OK' do
      expect(response).to have_http_status(:ok)
    end

    it 'assigns @page_map' do
      expect(assigns(:language)).to eq service_result
      expect(assigns(:username)).to eq 'github-username'
    end

    it 'renders domains/assets/index template' do
      expect(response).to render_template('favourite_language/show')
    end
  end
end
