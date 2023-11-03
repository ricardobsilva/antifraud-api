require 'rails_helper'

RSpec.describe Device, type: :model do
  it { is_expected.to have_many(:transactions) }
end
