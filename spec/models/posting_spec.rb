require 'rails_helper'

RSpec.describe Posting, type: :model do
  let(:posting) { build(:posting) }
  let(:job_application) { build(:job_application) }

  describe '#job_application_title' do
    after(:each) { posting.job_application = nil }

    it 'returns title of job application' do
      posting.job_application = job_application
      expect(job_application).to receive(:title)
      posting.job_application_title
    end
    it 'returns nil when posting does not belong to a job_application' do
      expect(posting.job_application_title).to be_nil
    end
  end
end
