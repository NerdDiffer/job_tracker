require 'rails_helper'

describe JobApplication, type: :model do
  let(:company) { build(:company) }
  let(:posting) { build(:posting) }
  let(:job_application) do
    build(:job_application, id: 1, company: company, posting: posting)
  end

  describe '#title' do
    let(:time_now) { Time.now }

    context 'it is a virtual attribute' do
      it 'it is not found in the database table' do
        expect(JobApplication.column_names).not_to include 'title'
      end
      it 'an instance responds to a call to #title' do
        expect(JobApplication.new).to respond_to :title
      end
    end

    context 'the most common case' do
      subject { job_application }

      before(:each) do
        allow(subject).to receive(:company_id?).and_return(true)
      end

      it 'confirms the subject has an associated company with a name' do
        expect(subject.company.name).not_to be_nil
      end
      it 'confirms the subject has an associated posting with a job_title' do
        expect(subject.posting.job_title).not_to be_nil
      end
      it 'combines company.name with posting.job_title' do
        expected = "#{subject.company.name} - #{subject.posting.job_title}"
        expect(subject.title).to eq expected
      end
    end

    context 'job application not associated with any particular company' do
      subject do
        posting = build(:posting)
        build(:job_application, posting: posting)
      end

      before(:each) do
        allow(subject).to receive(:company_id?).and_return(false)
        allow(subject).to receive(:created_at).and_return(time_now)
      end

      it 'confirms the subject has an associated posting with a job_title' do
        expect(subject.posting.job_title).not_to be_nil
      end
      it "combines a timestamp with the posting's job_title" do
        time = time_now.utc.strftime('%Y%m%d%H%M%S')
        title = subject.posting.job_title
        expected = "#{time} - #{title}"
        expect(subject.title).to eq expected
      end
    end

    context 'job application not associated with any particular job posting' do
      subject do
        company = build(:company)
        build(:job_application, company: company)
      end

      before(:each) do
        allow(subject).to receive(:company_id?).and_return(true)
      end

      it 'confirms the subject has an associated company with a name' do
        expect(subject.company.name).not_to be_nil
      end
      it 'confirms the subject has no associated job posting' do
        expect(subject.posting).to be_nil
      end
      it 'returns company.name' do
        expect(subject.title).to eq subject.company.name
      end
    end

    context 'job application not associated with both a company and posting' do
      subject { build(:job_application) }

      before(:each) do
        allow(subject).to receive(:company_id?).and_return(false)
        allow(subject).to receive(:created_at).and_return(time_now)
      end

      it 'confirms the subject has no associated company' do
        expect(subject.company).to be_nil
      end
      it 'confirms the subject has no associated job posting' do
        expect(subject.posting).to be_nil
      end
      it 'just returns a timestamp' do
        expected = Time.now.utc.strftime('%Y%m%d%H%M%S').to_s
        expect(subject.title).to eq expected
      end
    end
  end

  describe '#company_name' do
    context 'when the job application belongs to a company' do
      before(:each) do
        allow(job_application).to receive(:company_id?).and_return(true)
        allow(company).to receive(:name)
      end

      it 'calls #name on the company' do
        expect(company).to receive(:name)
        job_application.send(:company_name)
      end
    end

    context 'when the job application does NOT belong to a company' do
      it 'returns nil' do
        expect(job_application.send(:company_name)).to be_nil
      end
    end
  end
end
