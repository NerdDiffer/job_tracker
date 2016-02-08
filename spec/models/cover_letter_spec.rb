require 'rails_helper'

RSpec.describe CoverLetter, type: :model do
  let(:cover_letter) { build(:cover_letter) }
  let(:job_application) { build(:job_application) }

  describe '#job_application_title' do
    after(:each) { cover_letter.job_application = nil }

    it 'returns title of job application' do
      cover_letter.job_application = job_application
      expect(job_application).to receive(:title)
      cover_letter.job_application_title
    end
    it 'returns nil when cover_letter does not belong to a job_application' do
      expect(cover_letter.job_application_title).to be_nil
    end
  end
end
