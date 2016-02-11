require 'rails_helper'

RSpec.describe InteractionsHelper, type: :helper do
  describe '#generate_select_opts_for_media' do
    media = { 'in_person' => 0, 'phone' => 1, 'email' => 2, 'other' => 3 }

    before(:each) do
      allow(Interaction).to receive(:media).and_return(media)
    end

    it 'calls humanize on each key' do
      media_keys = media.keys
      media_keys.each do |key|
        expect(helper).to receive(:humanize).with(key)
      end
      helper.generate_select_opts_for_media
    end
  end

  describe '#humanize' do
    it 'calls #humanize on the input' do
      input = 'foo'
      expect(input).to receive(:humanize)
      helper.send(:humanize, input)
    end
  end
end
