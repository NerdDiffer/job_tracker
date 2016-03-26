require 'rails_helper'

describe JobApplicationDecorator do
  let(:job_application_decorator) { build(:job_application).decorate }
  let(:helper) { double('helper') }

  it 'the subject is decorated' do
    expect(job_application_decorator).to be_decorated
  end

  describe '#add_or_view_attached_posting' do
    context 'when there is a posting present' do
      before(:each) do
        allow(job_application_decorator).to receive(:posting?).and_return(true)
        allow(job_application_decorator).to receive(:h).and_return(helper)
        allow(helper).to receive(:render)
        allow(job_application_decorator).to receive(:locals).and_return({})
      end
      after(:each) do
        job_application_decorator.add_or_view_attached_posting
      end

      it 'calls #render on the helper object' do
        expect(helper).to receive(:render).with('posting', locals: {})
      end
    end

    context 'when there is no posting present' do
      before(:each) do
        allow(job_application_decorator).to receive(:posting?).and_return(false)
        allow(job_application_decorator).to receive(:h).and_return(helper)
        allow(helper).to receive(:link_to)
        allow(job_application_decorator)
          .to receive(:path_to_new_posting)
          .and_return('foo')
      end
      after(:each) do
        job_application_decorator.add_or_view_attached_posting
      end

      it 'calls #link_to on the helper object' do
        expect(helper).to receive(:link_to).with('Add Posting', 'foo')
      end
    end
  end

  describe '#add_or_view_attached_cover_letter' do
    context 'when there is a cover_letter present' do
      before(:each) do
        allow(job_application_decorator)
          .to receive(:cover_letter?)
          .and_return(true)
        allow(job_application_decorator).to receive(:h).and_return(helper)
        allow(helper).to receive(:render)
        allow(job_application_decorator).to receive(:locals).and_return({})
      end
      after(:each) do
        job_application_decorator.add_or_view_attached_cover_letter
      end

      it 'calls #render on the helper object' do
        expect(helper).to receive(:render).with('cover_letter', locals: {})
      end
    end

    context 'when there is no cover_letter present' do
      before(:each) do
        allow(job_application_decorator)
          .to receive(:cover_letter?)
          .and_return(false)
        allow(job_application_decorator).to receive(:h).and_return(helper)
        allow(helper).to receive(:link_to)
        allow(job_application_decorator)
          .to receive(:path_to_new_cover_letter)
          .and_return('bar')
      end
      after(:each) do
        job_application_decorator.add_or_view_attached_cover_letter
      end

      it 'calls #link_to on the helper object' do
        expect(helper).to receive(:link_to).with('Add Cover Letter', 'bar')
      end
    end
  end

  describe '#link_to_company' do
    context 'when the job application belongs to a company' do
      let(:company) { double('company') }

      before(:each) do
        allow(job_application_decorator)
          .to receive(:company_id?)
          .and_return(true)
        allow(helper).to receive(:link_to)
        allow(job_application_decorator).to receive(:h).and_return(helper)
        allow(job_application_decorator).to receive(:company).and_return(company)
        allow(job_application_decorator)
          .to receive(:company_name)
          .and_return('company_name')
      end

      it 'the helper calls #link_to' do
        expect(helper).to receive(:link_to).with('company_name', company)
        job_application_decorator.link_to_company
      end
    end

    context 'when the job application does NOT belong to a company' do
      before(:each) do
        allow(job_application_decorator)
          .to receive(:company_id?)
          .and_return(false)
        allow(helper).to receive(:content_tag)
        allow(job_application_decorator)
          .to receive(:no_company_message)
          .and_return('foo')
        allow(job_application_decorator).to receive(:h).and_return(helper)
      end

      it 'the helper calls #content_tag' do
        expect(helper).to receive(:content_tag).with(:span, 'foo')
        job_application_decorator.link_to_company
      end
    end
  end

  describe '#posting?' do
    let(:posting) { double('posting') }

    context 'when there is an associated posting' do
      before(:each) do
        allow(job_application_decorator).to receive(:posting).and_return(posting)
      end

      it 'returns true' do
        actual = job_application_decorator.send(:posting?)
        expect(actual).to be_truthy
      end
    end
    context 'when there is NOT an associated posting' do
      before(:each) do
        allow(job_application_decorator).to receive(:posting).and_return(nil)
      end

      it 'returns false' do
        actual = job_application_decorator.send(:posting?)
        expect(actual).to be_falsey
      end
    end
  end

  describe '#cover_letter?' do
    let(:cover_letter) { double('cover_letter') }

    context 'when there is an associated cover_letter' do
      before(:each) do
        allow(job_application_decorator)
          .to receive(:cover_letter)
          .and_return(cover_letter)
      end

      it 'returns true' do
        actual = job_application_decorator.send(:cover_letter?)
        expect(actual).to be_truthy
      end
    end
    context 'when there is NOT an associated cover_letter' do
      before(:each) do
        allow(job_application_decorator).to receive(:cover_letter).and_return(nil)
      end

      it 'returns false' do
        actual = job_application_decorator.send(:cover_letter?)
        expect(actual).to be_falsey
      end
    end
  end

  describe '#locals' do
    it 'returns this hash' do
      actual = job_application_decorator.send(:locals)
      expected = { object: job_application_decorator }
      expect(actual).to eq expected
    end
  end

  describe '#path_to_new_posting' do
    before(:each) do
      allow(job_application_decorator).to receive(:h).and_return(helper)
      allow(helper).to receive(:new_job_application_posting_path)
      allow(job_application_decorator).to receive(:id).and_return(1)
    end
    after(:each) do
      job_application_decorator.send(:path_to_new_posting)
    end

    it 'calls #new_job_application_posting_path on the helper object' do
      expect(helper)
        .to receive(:new_job_application_posting_path)
        .with(job_application_id: 1)
    end
  end

  describe '#path_to_new_cover_letter' do
    before(:each) do
      allow(job_application_decorator).to receive(:h).and_return(helper)
      allow(helper).to receive(:new_job_application_cover_letter_path)
      allow(job_application_decorator).to receive(:id).and_return(1)
    end
    after(:each) do
      job_application_decorator.send(:path_to_new_cover_letter)
    end

    it 'calls #new_job_application_cover_letter_path on the helper object' do
      expect(helper)
        .to receive(:new_job_application_cover_letter_path)
        .with(job_application_id: 1)
    end
  end

  describe '#no_company_message' do
    it 'returns a message as a string' do
      actual = job_application_decorator.send(:no_company_message)
      expect(actual).to be_an_instance_of(String)
    end
  end
end
