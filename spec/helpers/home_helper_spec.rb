require 'rails_helper'

RSpec.describe HomeHelper, type: :helper do
  describe '#main_links' do
    it 'each key in the hash object is :name or :path' do
      links = helper.main_links
      links.each do |link_hash|
        keys = link_hash.keys
        expect(keys).to eq %I(name path)
      end
    end
    it 'each value in the hash object is a String' do
      links = helper.main_links
      links.each do |link_hash|
        vals = link_hash.values
        expect(vals).to all be_a String
      end
    end
  end
end
