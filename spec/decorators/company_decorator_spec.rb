require 'rails_helper'

describe CompanyDecorator do
  let(:company_decorator) { build(:company).decorate }
  let(:helper) { double('helper') }

  describe '#show_recruitment_companies' do
    before(:each) do
      allow(helper).to receive(:render)
      allow(company_decorator).to receive(:h).and_return(helper)
    end

    context 'when company is an agency' do
      let(:name_of_clients_partial) { 'clients' }

      before(:each) do
        allow(company_decorator).to receive(:agency?).and_return(true)
      end
      after(:each) do
        company_decorator.show_recruitment_companies
      end

      it 'calls #render with "clients" partial' do
        expect(helper).to receive(:render).with(name_of_clients_partial)
      end
    end

    context 'when company is NOT an agency' do
      let(:name_of_agencies_partial) { 'agencies' }

      before(:each) do
        allow(company_decorator).to receive(:agency?).and_return(false)
      end
      after(:each) do
        company_decorator.show_recruitment_companies
      end

      it 'calls #render with "agencies" partial' do
        expect(helper).to receive(:render).with(name_of_agencies_partial)
      end
    end
  end

  describe '#companies_via_recruitments' do
    context 'when company is an agency' do
      before(:each) do
        allow(company_decorator).to receive(:agency?).and_return(true)
        allow(company_decorator).to receive(:clients)
      end
      after(:each) do
        company_decorator.companies_via_recruitments
      end

      it 'calls #clients' do
        expect(company_decorator).to receive(:clients)
      end
    end

    context 'when company is NOT an agency' do
      before(:each) do
        allow(company_decorator).to receive(:agency?).and_return(false)
        allow(company_decorator).to receive(:agencies)
      end
      after(:each) do
        company_decorator.companies_via_recruitments
      end

      it 'calls #agencies' do
        expect(company_decorator).to receive(:agencies)
      end
    end
  end

  describe '#link_to_remove' do
    let(:recruitment) { build(:recruitment) }
    let(:associated_company_id) { 2 }

    before(:each) do
      allow(company_decorator)
        .to receive(:build_recruitment)
        .and_return(recruitment)
      allow(company_decorator).to receive(:id).and_return(1)
      allow(recruitment).to receive(:id).and_return(1)
      allow(company_decorator).to receive(:h).and_return(helper)
      allow(helper)
        .to receive(:company_recruitment_path)
        .and_return('delete_path')
      allow(helper).to receive(:delete_link_opts).and_return('delete_link_opts')
      allow(helper).to receive(:link_to)
    end

    context 'state' do
      before(:each) do
        company_decorator.link_to_remove(associated_company_id)
      end

      it 'sets value for @associated_company_id' do
        actual = company_decorator.associated_company_id
        expect(actual).to eq associated_company_id
      end
    end
    context 'expected method calls' do
      after(:each) do
        company_decorator.link_to_remove(associated_company_id)
      end

      it 'calls #build_recruitment' do
        expect(company_decorator).to receive(:build_recruitment)
      end
      it 'calls #company_recruitment_path on the helper' do
        expect(helper)
          .to receive(:company_recruitment_path)
          .with(company_decorator.id, recruitment.id)
      end
      it 'calls #link_to on the helper' do
        expect(helper)
          .to receive(:link_to)
          .with('Remove', 'delete_path', 'delete_link_opts')
      end
    end
  end

  describe '#clients' do
    let(:opps)          { double('opportunities_via_recruiting') }
    let(:recruitment_1) { build(:recruitment) }
    let(:recruitment_2) { build(:recruitment) }
    let(:client_1)      { build(:company) }
    let(:client_2)      { build(:company) }
    let(:relation)      { [recruitment_1, recruitment_2] }

    before(:each) do
      allow(company_decorator)
        .to receive(:opportunities_via_recruiting)
        .and_return(opps)
      allow(opps).to receive(:where).and_return(relation)
      allow(recruitment_1).to receive(:client).and_return(client_1)
      allow(recruitment_2).to receive(:client).and_return(client_2)
    end

    it 'returns a list of clients' do
      actual = company_decorator.send(:clients)
      expected = [client_1, client_2]
      expect(actual).to eq expected
    end
  end

  describe '#agencies' do
    let(:opps)          { double('opportunities_via_recruiting') }
    let(:recruitment_1) { build(:recruitment) }
    let(:recruitment_2) { build(:recruitment) }
    let(:agency_1)      { build(:company) }
    let(:agency_2)      { build(:company) }
    let(:relation)      { [recruitment_1, recruitment_2] }

    before(:each) do
      allow(company_decorator)
        .to receive(:opportunities_via_recruiting)
        .and_return(opps)
      allow(opps).to receive(:where).and_return(relation)
      allow(recruitment_1).to receive(:agency).and_return(agency_1)
      allow(recruitment_2).to receive(:agency).and_return(agency_2)
    end

    it 'returns a list of agencies' do
      actual = company_decorator.send(:agencies)
      expected = [agency_1, agency_2]
      expect(actual).to eq expected
    end
  end

  describe '#opportunities_via_recruiting' do
    let(:current_user) { build(:user) }

    before(:each) do
      allow(company_decorator).to receive(:h).and_return(helper)
      allow(helper).to receive(:current_user).and_return(current_user)
      allow(current_user).to receive(:opportunities_via_recruiting)
    end

    it 'calls #opportunities_via_recruiting on the current_user' do
      expect(current_user).to receive(:opportunities_via_recruiting)
      company_decorator.send(:opportunities_via_recruiting)
    end
  end

  describe '#build_recruitment' do
    let(:opps) { double('opportunities_via_recruiting') }
    let(:company_ids_match) { 'company_ids_match' }
    let(:relation) { double('relation') }
    let(:recruitment) { build(:recruitment) }

    before(:each) do
      allow(company_decorator)
        .to receive(:opportunities_via_recruiting)
        .and_return(opps)
      allow(company_decorator)
        .to receive(:company_ids_match)
        .and_return(company_ids_match)
      allow(opps).to receive(:where).and_return(relation)
      allow(relation).to receive(:first).and_return(recruitment)
    end
    after(:each) do
      company_decorator.send(:build_recruitment)
    end

    it 'calls #opportunities_via_recruiting' do
      expect(company_decorator).to receive(:opportunities_via_recruiting)
    end
    it 'calls #company_ids_match' do
      expect(company_decorator).to receive(:company_ids_match)
    end
    it 'calls #where' do
      expect(opps).to receive(:where)
    end
    it 'calls #first' do
      expect(relation).to receive(:first)
    end
  end

  describe '#company_ids_match' do
    before(:each) do
      allow(company_decorator).to receive(:id).and_return(1)
      allow(company_decorator).to receive(:associated_company_id).and_return(2)
    end

    context 'when company is an agency' do
      before(:each) do
        allow(company_decorator).to receive(:agency?).and_return(true)
      end

      it 'returns this hash' do
        actual = company_decorator.send(:company_ids_match)
        expected = { agency_id: 1, client_id: 2 }
        expect(actual).to eq expected
      end
    end
    context 'when company is NOT an agency' do
      before(:each) do
        allow(company_decorator).to receive(:agency?).and_return(false)
      end

      it 'returns this hash' do
        actual = company_decorator.send(:company_ids_match)
        expected = { client_id: 1, agency_id: 2 }
        expect(actual).to eq expected
      end
    end
  end
end
