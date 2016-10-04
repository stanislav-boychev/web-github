require 'rails_helper'

describe 'favourite_language/show' do
  let(:language) { double(value: 'Python') }

  before {
    assign(:language, language)
    render
  }

  subject { Nokogiri::HTML.parse(rendered) }

  it 'has div with language name' do
    text = subject.css('div').text
    expect(text).to match 'Python'
  end
end
