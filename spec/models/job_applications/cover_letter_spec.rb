require 'rails_helper'

RSpec.describe JobApplications::CoverLetter, type: :model do
  let(:cover_letter) { build(:cover_letter) }
  let(:job_application) { build(:job_application) }

  before(:each) do
    allow(cover_letter).to receive(:job_application).and_return(job_application)
  end

  describe '#job_application_title' do
    it 'calls #title on job_application' do
      expect(job_application).to receive(:title)
      cover_letter.job_application_title
    end
  end

  describe '#user' do
    it 'calls #user on job_application' do
      expect(job_application).to receive(:user)
      cover_letter.user
    end
  end
end
