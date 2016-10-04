require 'rails_helper'

RSpec.describe Github::FavouriteLanguageService do
  subject { described_class.new.call(username) }
  let(:username) { 'github-username' }

  let(:users_repository_class) { Github::UsersRepository }
  let(:users_repository) { instance_double(users_repository_class) }
  let(:languages_repository_class) { Github::LanguagesRepository }
  let(:languages_repository) { instance_double(languages_repository_class) }

  let(:user) { double('user') }
  let(:languages) { { "Ruby" => 200, "Python" => 500 } }

  before {
    allow(users_repository_class).to receive(:new).and_return(users_repository)
    allow(users_repository).to receive(:find).and_return(user)
    allow(languages_repository_class).to receive(:new).and_return(languages_repository)
    allow(languages_repository).to receive(:all).and_return(languages)
  }

  it 'returns a valid result' do
    expect(subject).to be_success
  end

  it 'returns the language with most lines' do
    expect(users_repository).to receive(:find).with(username)
    expect(languages_repository).to receive(:all).with(username)

    expect(subject.value).to eq 'Python'
  end

  context 'when user cannot be found' do
    let(:user) { nil }

    it 'returns invalid result with error' do
      expect(subject).to be_fail
      expect(subject.errors).to eq 'user cannot be found'
    end
  end

  context 'when languges cannot be fetched' do
    let(:languages) { nil }

    it 'returns invalid result with error' do
      expect(subject).to be_fail
      expect(subject.errors).to eq 'languages cannot be downloaded from github'
    end
  end
 end
