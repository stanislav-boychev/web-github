require 'rails_helper'

RSpec.describe Github::UsersRepository do
  subject { described_class.new.find(username) }
  let(:url) { Rails.configuration.x.github_url }
  let(:username) { 'git-user' }
  let(:code) { 200 }
  let(:github_users_path) { "/users/#{username}" }

  let(:faraday) {
    Faraday.new { |builder|
      builder.adapter :test, Faraday::Adapter::Test::Stubs.new { |stub|
        stub.get(github_users_path) { |env| [code, {}, body] }
      }
    }
  }

  let(:user) {
    {
      'login' => username,
      'id' => 666,
      'created_at' => Time.new(2016, 1, 1).to_s,
      'updated_at' => Time.new(2016, 2, 28).to_s,
    }
  }

  let(:body) {
    user.to_json
  }

  before {
    allow(Faraday).to receive(:new).with(url: url).and_return(faraday)
  }

  it 'returns a hash with user' do
    expect(subject).to be_a Hash
    expect(subject.fetch('login')).to eq user['login']
    expect(subject.fetch('id')).to eq user['id']
    expect(subject.fetch('created_at')).to eq user['created_at']
    expect(subject.fetch('updated_at')).to eq user['updated_at']
  end

  context "when user is not found" do
    let(:code) { 404 }

    it 'returns nil' do
      expect(subject.first).to be_falsey
      expect(subject.last).to eq "user is not found or cannot be fetched"
    end
  end

  context "when response is not json" do
    let(:body) { 'wrong json xxx' }

    it 'returns nil' do
      expect(subject.first).to be_falsey
      expect(subject.last).to eq "user is not found or cannot be fetched"
    end
  end
end
