require 'rails_helper'

RSpec.describe JobApplications::Posting, type: :model do
  let(:posting) { build(:posting) }
  let(:job_application) { build(:job_application) }

  before(:each) do
    allow(posting).to receive(:job_application).and_return(job_application)
  end

  describe '#job_application_title' do
    it 'calls #title on job_application' do
      expect(job_application).to receive(:title)
      posting.job_application_title
    end
  end

  describe '#user' do
    it 'calls #user on job_application' do
      expect(job_application).to receive(:user)
      posting.user
    end
  end
end
