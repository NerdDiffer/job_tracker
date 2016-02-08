require 'rails_helper'

RSpec.describe Company, type: :model do
  let(:company) { build(:company) }

  describe '#permalink' do
    it 'calls parameterize on the name' do
      allow(company).to receive(:name).and_return('FOO BAR')
      expect(company.name).to receive(:parameterize)
      company.permalink
    end
  end
end
