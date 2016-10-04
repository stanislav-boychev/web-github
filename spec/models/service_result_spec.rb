require 'rails_helper'

RSpec.describe ServiceResult do
  subject { described_class.new('value is 666^42') }

  it { is_expected.to be_success }
  it { is_expected.not_to be_fail }
  it { expect(subject.value).to eq 'value is 666^42'}
end
