require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  describe '#interpolate_link' do
    it 'returns a link prepended with "http://"' do
      actual = helper.interpolate_link('foo')
      expect(actual).to eq 'http://foo'
    end
  end

  describe '#status_tag' do
    context 'if passing a truthy value' do
      it 'calls #content_tag with these options' do
        expect(helper)
          .to receive(:content_tag)
          .with(:span, 'Yes', class: 'status true')
        helper.status_tag(true)
      end
    end
    context 'if passing a falsey value' do
      it 'calls #content_tag with these options' do
        expect(helper)
          .to receive(:content_tag)
          .with(:span, 'No', class: 'status false')
        helper.status_tag(false)
      end
    end
  end

  describe '#error_messages_for' do
    before(:each) do
      allow(helper)
        .to receive(:error_messages_partial)
        .and_return('shared/error_messages')
    end
    it 'calls render with these arguments' do
      expected_args = {
        partial: 'shared/error_messages',
        locals: { curr_object: 'foo' }
      }
      expect(helper).to receive(:render).with(expected_args)
      helper.error_messages_for('foo')
    end
  end

  describe '#markdown' do
    let(:renderer_obj) { Redcarpet::Render::HTML.new({}) }
    let(:markdown_obj) { Redcarpet::Markdown.new(renderer_obj, {}) }

    before(:each) do
      allow(helper).to receive(:renderer_options).and_return({})
      allow(helper).to receive(:md_extensions).and_return({})
      allow(Redcarpet::Render::HTML).to receive(:new).and_return(renderer_obj)
      allow(Redcarpet::Markdown).to receive(:new).and_return(markdown_obj)
      allow(markdown_obj).to receive(:render).with('foo').and_return('foo')
    end
    after(:each) do
      helper.markdown('foo')
    end

    it 'calls for default renderer_options' do
      expect(helper).to receive(:renderer_options)
    end
    it 'calls for default md_extensions' do
      expect(helper).to receive(:md_extensions)
    end
    it 'instantiates a Redcarpet::Render::HTML object' do
      expect(Redcarpet::Render::HTML).to receive(:new)
    end
    it 'instantiates a Redcarpet::Markdown object' do
      expect(Redcarpet::Markdown).to receive(:new)
    end
    it 'the markdown object receives #render with the input text' do
      expect(markdown_obj).to receive(:render).with('foo')
    end
    it 'calls #html_safe' do
      expect(helper).to receive(:html_safe)
    end
  end

  describe '#delete_link_opts' do
    it 'returned hash has these keys' do
      delete_link_opts = helper.delete_link_opts
      actual = delete_link_opts.keys
      expect(actual).to eq %I(method data)
    end
    it 'the :data key is a hash with a :confirm key' do
      delete_link_opts = helper.delete_link_opts
      actual = delete_link_opts[:data][:confirm]
      expect(actual).not_to be_nil
    end
  end

  describe '#error_messages_partial' do
    it 'returns path to error messages partial' do
      actual = helper.send(:error_messages_partial)
      expect(actual).to eq 'shared/error_messages'
    end
  end

  describe '#renderer_options' do
    it 'returns a hash with this key' do
      actual = helper.send(:renderer_options)
      expect(actual).to include(:with_toc_data)
    end
  end

  describe '#md_extensions' do
    it 'returns a hash with these keys' do
      actual = helper.send(:md_extensions)
      expect(actual).to include(:no_intra_emphasis,
                                :fenced_code_blocks,
                                :disable_indented_code_blocks)
    end
  end

  describe '#html_safe' do
    it 'calls #html_safe on the input' do
      input = 'foo'
      expect(input).to receive(:html_safe)
      helper.send(:html_safe, input)
    end
  end
end
