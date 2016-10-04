require 'rails_helper'
require 'rails_helper'

RSpec.describe Github::LanguagesRepository do
  subject { described_class.new.all(username) }
  let(:url) { Rails.configuration.x.github_url }
  let(:username) { 'git-user' }
  let(:code_repos) { 200 }
  let(:code1) { 200 }
  let(:code2) { 200 }
  let(:github_repos_path) { "/users/#{username}/repos" }
  let(:github_repo1_langs_path) { "/repos/#{username}/#{repo1}/languages" }
  let(:github_repo2_langs_path) { "/repos/#{username}/#{repo2}/languages" }

  let(:faraday) {
    Faraday.new { |builder|
      builder.adapter :test, Faraday::Adapter::Test::Stubs.new { |stub|
        stub.get(github_repos_path) { |env| [code_repos, {}, repos] }
        stub.get(github_repo1_langs_path) { |env| [code1, {}, body1] }
        stub.get(github_repo2_langs_path) { |env| [code2, {}, body2] }
      }
    }
  }

  let(:repo1) { 'repo1' }
  let(:repo2) { 'repo2' }

  let(:repos) {
    [
      {
        'id' => 123,
        'name' => repo1,
      },
      {
        'id' => 432,
        'name' => repo2,
      }
    ].to_json
  }

  let(:body1) {
    {'C' => 600, 'Ruby' => 200, 'JavaScript' => 100}.to_json
  }

  let(:body2) {
    {'Ruby' => 500}.to_json
  }


  let(:body) {
    user.to_json
  }

  before {
    allow(Faraday).to receive(:new).with(url: url).and_return(faraday)
  }

  it 'returns a hash with languages and total count of lines' do
    expect(subject).to be_a Hash
    expect(subject.fetch('C')).to eq 600
    expect(subject.fetch('Ruby')).to eq 700
    expect(subject.fetch('JavaScript')).to eq 100
  end

  context 'when language cannot be fetched' do
    let(:code1) { 500 }

    it 'returns nil' do
      expect(subject.first).to be_falsey
      expect(subject.last).to eq 'languages cannot be fetched'
    end
  end

  context 'when repos cannot be fetched' do
    let(:code_repos) { 500 }

    it 'returns nil' do
      expect(subject.first).to be_falsey
      expect(subject.last).to eq 'languages cannot be fetched'
    end
  end

  context 'when repos response is not json' do
    let(:repos) { 'wrong json xxx' }

    it 'when languages cannot be fetched' do
      expect(subject.first).to be_falsey
      expect(subject.last).to eq 'languages cannot be fetched'
    end
  end

  context 'when languages response is not json' do
    let(:body1) { 'wrong json xxx' }

    it 'when languages cannot be fetched' do
      expect(subject.first).to be_falsey
      expect(subject.last).to eq 'languages cannot be fetched'
    end
  end
end
