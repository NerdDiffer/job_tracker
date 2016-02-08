require 'rails_helper'

RSpec.describe Contact, type: :model do
  let(:contact) { build(:contact) }
  let(:company) { build(:company) }

  describe '#name' do
    it 'returns first & last name' do
      expect(contact.name).to eq 'Joe Schmoe'
    end
  end

  describe '#permalink' do
    it 'calls parameterize on the name' do
      allow(contact).to receive(:name).and_return('FOO BAR')
      # `parameterize` is called upon a singleton object, not the String class
      expect(contact.name).to receive(:parameterize)
      contact.permalink
    end
  end

  describe '#company_name' do
    after(:each) { contact.company = nil }

    it 'returns name of company' do
      contact.company = company
      expect(company).to receive(:name)
      contact.company_name
    end
    it 'returns nil when contact does not belong to a company' do
      expect(contact.company_name).to be_nil
    end
  end
end
