require 'rails_helper'

describe JobApplication, type: :model do
  let(:ja) { JobApplication.all }
  let(:company) { build(:company) }
  let(:posting) { build(:posting) }

  describe 'test subjects list' do
    it 'has 30 items' do
      expect(ja.count).to eq 30
    end
    it 'is a JobApplication::ActiveRecord_Relation' do
      expect(ja).to be_an ActiveRecord::Relation
    end
    it 'is composed entirely of JobApplication objects' do
      expect(ja).to all be_a JobApplication
    end
  end

  describe '.sort_by_attribute' do
    context 'sorting by a virtual attribute' do
      let(:sorted_titles) { ja.map(&:title).sort }

      shared_examples_for 'sorting by a virtual attribute' do
        it 'can sort by a virtual attribute' do
          actual = JobApplication
                   .sort_by_attribute(subject, :title)
                   .map(&:title)
          expect(actual).to eq sorted_titles
        end
      end

      context 'when passing in ActiveRecord::Relation' do
        subject { ja }
        it_behaves_like 'sorting by a virtual attribute'
      end
      context 'when passing in Array' do
        subject { ja.to_a }
        it_behaves_like 'sorting by a virtual attribute'
      end
    end
  end

  describe '.get_record_val_by' do
    subject do
      build(:job_application, company: company, posting: posting, id: 2)
    end

    context 'the subject' do
      it 'has these attributes & values' do
        expect(subject).to have_attributes(
          active: true,
          title: 'Example Company - Chief Hot Pocket',
          id: 2
        )
      end

      it 'has these attributes & values from its Company association' do
        expect(subject.company).to have_attributes(name: 'Example Company')
      end
    end

    context 'retrieving real attributes from associated models' do
      before(:each) do
        allow(Company)
          .to receive(:find_by_name)
          .with(subject.company.name)
          .and_return(company)
      end

      it 'without using this method, confirms you can find the company' do
        expect(Company.find_by_name(subject.company.name)).to eq company
      end
      it 'returns company name' do
        attribute = :name
        value = subject.company.name
        name = { return_attr: 'name' }
        actual = Company.get_record_val_by(attribute, value, name)
        expect(actual).to eq 'Example Company'
      end
    end

    context 'retrieving real attributes while searching by virtual attribute' do
      before(:each) do
        allow(JobApplication)
          .to receive(:find_by_title)
          .with(subject.title)
          .and_return subject
      end
      it 'returns the id of the JobApplication' do
        expect(JobApplication.get_record_val_by(:title, subject.title)).to eq 2
      end
    end
  end

  describe '#title' do
    context 'it is a virtual attribute' do
      it 'it is not found in the database table' do
        expect(JobApplication.column_names).not_to include 'title'
      end
      it 'an instance responds to a call to #title' do
        expect(JobApplication.new).to respond_to :title
      end
    end

    context 'the most common case' do
      subject do
        company = build(:company)
        posting = build(:posting)
        build(:job_application, company: company, posting: posting)
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

      it 'confirms the subject has no associated company' do
        expect(subject.company).to be_nil
      end
      it 'confirms the subject has an associated posting with a job_title' do
        expect(subject.posting.job_title).not_to be_nil
      end
      it "combines a timestamp with the posting's job_title" do
        time = Time.now.strftime('%Y%m%d%H%M%S')
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

      it 'confirms the subject has no associated company' do
        expect(subject.company).to be_nil
      end
      it 'confirms the subject has no associated job posting' do
        expect(subject.posting).to be_nil
      end
      it 'just returns a timestamp' do
        expect(subject.title).to eq Time.now.strftime('%Y%m%d%H%M%S').to_s
      end
    end
  end
end
