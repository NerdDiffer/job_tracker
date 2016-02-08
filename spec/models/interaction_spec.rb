require 'rails_helper'

describe Interaction, type: :model do
  let(:contact) { build(:contact, id: 2) }

  describe '.get_record_val_by' do
    subject { build(:interaction, contact: contact) }

    context 'the subject' do
      it 'has these attributes & values' do
        expect(subject).to have_attributes(
          notes: 'Lorem ipsum',
          medium: 'phone'
        )
      end

      it 'has these attributes & values from its Contact association' do
        expect(subject.contact).to have_attributes(name: 'Joe Schmoe')
      end
    end

    context 'searching by real attributes' do
      before(:each) do
        allow(Contact)
          .to receive(:find_by_first_name)
          .with(subject.contact.first_name)
          .and_return contact
      end

      it 'returns id of contact' do
        attribute = :first_name
        value = subject.contact.first_name
        options = { model: Contact }

        actual = Interaction.get_record_val_by(attribute, value, options)
        expect(actual).to eq 2
      end
    end

    context 'searching by virtual attribute' do
      before(:each) do
        allow(Contact)
          .to receive(:find_by_name)
          .with(subject.contact.name)
          .and_return(contact)
      end

      it 'returns id of contact' do
        attribute = :name
        value = subject.contact.name
        options = { model: Contact }

        actual = Interaction.get_record_val_by(attribute, value, options)
        expect(actual).to eq 2
      end
    end
  end
end
