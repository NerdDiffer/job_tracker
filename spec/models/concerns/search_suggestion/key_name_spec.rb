require 'rails_helper'

describe SearchSuggestion::KeyName do
  describe '.base' do
    it 'returns a string in the format "job_tracker:.*"' do
      actual = described_class.base('foo')
      expect(actual).to match(/job_tracker:.*/)
    end
  end
  describe '.union' do
    it 'returns a string in the format "job_tracker:ALL:.*"' do
      actual = described_class.union('foo')
      expect(actual).to match(/job_tracker:ALL:.*/)
    end
  end
  describe '.generic' do
    it 'returns a string in the format "job_tracker:.*:.*"' do
      actual = described_class.generic('foo', 'bar')
      expect(actual).to match(/job_tracker:.*:.*/)
    end
  end
end
