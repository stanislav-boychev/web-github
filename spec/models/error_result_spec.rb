require 'rails_helper'

RSpec.describe ErrorResult do
  subject { described_class.new('something went wrong') }

  it { is_expected.to be_fail }
  it { is_expected.not_to be_success }
  it { expect(subject.errors).to eq 'something went wrong'}
end
