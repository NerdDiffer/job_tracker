require 'rails_helper'

describe ContactDecorator do
  let(:contact_decorator) { build(:contact).decorate }
  let(:company) { build(:company) }

  it 'the subject is decorated' do
    expect(contact_decorator).to be_decorated
  end

  describe '#link_to_company' do
    let(:helpers) { double('helpers') }

    it 'calls #company?' do
      allow(contact_decorator).to receive(:company_id?).and_return(false)
      expect(contact_decorator).to receive(:company_id?)
      contact_decorator.link_to_company
    end

    context 'when a contact_decorator belongs to a company' do
      before(:each) do
        allow(contact_decorator).to receive(:company_id?).and_return(true)
        allow(contact_decorator).to receive(:h).and_return(helpers)
        allow(helpers).to receive(:link_to)
        allow(contact_decorator).to receive(:company_name).and_return('Foo')
        allow(contact_decorator).to receive(:company).and_return(company)
      end
      after(:each) do
        contact_decorator.link_to_company
      end

      it 'calls #company_id' do
        expect(contact_decorator).to receive(:company_id?)
      end
      it 'references the helpers object' do
        expect(contact_decorator).to receive(:h)
      end
      it 'calls #link_to on the helpers object' do
        expect(helpers).to receive(:link_to).with('Foo', company)
      end
    end

    context 'when a contact_decorator does NOT belong to a company' do
      before(:each) do
        allow(contact_decorator).to receive(:company_id?).and_return(false)
        allow(contact_decorator).to receive(:h).and_return(helpers)
      end

      it 'returns nil' do
        expect(contact_decorator.link_to_company).to be_nil
      end
      it 'does NOT call #link_to' do
        expect(helpers).not_to receive(:link_to)
        contact_decorator.link_to_company
      end
    end
  end

  describe '#company_name' do
    after(:each) do
      contact_decorator.company_name
    end

    it 'calls #company?' do
      allow(contact_decorator).to receive(:company_id?).and_return(false)
      expect(contact_decorator).to receive(:company_id?)
    end

    context 'when a contact_decorator belongs to a company' do
      before(:each) do
        allow(contact_decorator).to receive(:company_id?).and_return(true)
        allow(contact_decorator).to receive(:company).and_return(company)
      end

      it 'calls for #name on the company' do
        expect(company).to receive(:name)
      end
    end
    context 'when a contact_decorator does NOT belong to a company' do
      before(:each) do
        allow(contact_decorator).to receive(:company_id?).and_return(false)
      end

      it 'returns nil' do
        expect(contact_decorator.company_name).to be_nil
      end
    end
  end

  describe '#phone_and_email' do
    before(:each) do
      allow(contact_decorator).to receive(:h).and_return(helper)
      allow(helper).to receive(:render)
      allow(contact_decorator).to receive(:locals).and_return({})
    end
    after(:each) do
      contact_decorator.phone_and_email
    end

    it 'calls #render on the helper object' do
      expect(helper)
        .to receive(:render)
        .with(partial: 'phone_and_email', locals: {})
    end
  end

  describe '#locals' do
    it 'returns this hash' do
      expected = { contact: contact_decorator }
      actual = contact_decorator.send(:locals)
      expect(actual).to eq expected
    end
  end
end
