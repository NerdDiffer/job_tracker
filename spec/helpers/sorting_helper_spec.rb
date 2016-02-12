require 'rails_helper'

RSpec.describe SortingHelper, type: :helper do
  describe '#generate_sortable_link' do
    before(:each) do
      allow(helper).to receive(:toggle_direction).and_return('foo')
      allow(helper).to receive(:css_class).and_return('bar')
      allow(helper).to receive(:link_to)
    end

    it 'calls #toggle_direction' do
      expect(helper).to receive(:toggle_direction)
      helper.generate_sortable_link('attribute')
    end
    it 'calls #css_class' do
      expect(helper).to receive(:css_class)
      helper.generate_sortable_link('attribute')
    end
    it 'calls #titleize on the input' do
      input = 'attribute'
      expect(input).to receive(:titleize)
      helper.generate_sortable_link(input)
    end
    it 'calls #link_to' do
      options = { sort: 'attribute', direction: 'foo' }
      html_options = { class: 'bar' }
      expect(helper)
        .to receive(:link_to)
        .with('Attribute', options, html_options)
      helper.generate_sortable_link('attribute')
    end
  end

  describe '#sort_column' do
    context 'when column is allowed' do
      it 'returns value of params[:sort]' do
        params = { sort: '_sort' }
        allow(helper).to receive(:params).and_return(params)
        allow(helper).to receive(:col_allowed?).and_return(true)
        actual = helper.sort_column
        expect(actual).to eq params[:sort]
      end
    end

    context 'when column is NOT allowed' do
      it 'calls #default_sorting_column' do
        allow(helper).to receive(:col_allowed?).and_return(false)
        expect(helper).to receive(:default_sorting_column)
        helper.sort_column
      end
    end
  end

  describe '#attr_eql_to_sort_col?' do
    before(:each) do
      allow(helper).to receive(:sort_column).and_return('foo')
    end

    it 'is true when attribute is equal to sort column' do
      actual = helper.send(:attr_eql_to_sort_col?, 'foo')
      expect(actual).to be_truthy
    end
    it 'is is otherwise false' do
      actual = helper.send(:attr_eql_to_sort_col?, 'bar')
      expect(actual).to be_falsey
    end
  end

  describe '#toggle_direction' do
    before(:each) do
      allow(helper).to receive(:attr_eql_to_sort_col?).and_return(true)
    end

    it 'returns desc if current direction is asc' do
      allow(helper).to receive(:params).and_return(direction: 'asc')
      actual = helper.send(:toggle_direction, '')
      expect(actual).to eq 'desc'
    end
    it 'otherwise returns asc' do
      actual = helper.send(:toggle_direction, '')
      expect(actual).to eq 'asc'
    end
  end

  describe '#css_class' do
    context 'when column is allowed' do
      before(:each) do
        allow(helper).to receive(:attr_eql_to_sort_col?).and_return true
      end

      it 'calls #sort_direction' do
        expect(helper).to receive(:sort_direction)
        helper.send(:css_class, '')
      end
      it 'returns input in the form of "current #{sort_direction}"' do
        allow(helper).to receive(:sort_direction).and_return('direction')
        actual = helper.send(:css_class, '')
        expect(actual).to eq 'current direction'
      end
    end
    it 'otherwise returns nil' do
      allow(helper).to receive(:attr_eql_to_sort_col?).and_return false
      expect(helper.send(:css_class, '')).to be_nil
    end
  end

  describe '#col_allowed?' do
    it 'calls #map with a block converting each value to a string' do
      whitelisted_attr = [:foo, :bar]
      allow(helper).to receive(:map_to_s).and_return(whitelisted_attr)
      expect(helper).to receive(:map_to_s)
      helper.send(:col_allowed?, 'foo')
    end
    it 'calls #include? on whitelisted_attr' do
      whitelisted_attr = %w(foo bar)
      allow(helper).to receive(:map_to_s).and_return(whitelisted_attr)
      expect(whitelisted_attr).to receive(:include?)
      helper.send(:col_allowed?, 'bar')
    end
  end

  describe '#direction_allowed?' do
    it 'calls include? on #directions' do
      allow(helper).to receive(:directions).and_return(%w(foo bar))
      directions = helper.send(:directions)
      expect(directions).to receive(:include?)
      helper.send(:direction_allowed?, 'foo')
    end
  end

  describe '#sort_direction' do
    context 'when direction is allowed' do
      it 'returns value of params[:direction]' do
        params = { direction: '_direction' }
        allow(helper).to receive(:params).and_return(params)
        allow(helper).to receive(:direction_allowed?).and_return(true)
        expect(helper.send(:sort_direction)).to eq params[:direction]
      end
    end

    context 'when direction is NOT allowed' do
      it 'returns asc' do
        allow(helper).to receive(:direction_allowed?).and_return(false)
        expect(helper.send(:sort_direction)).to eq 'asc'
      end
    end
  end

  describe '#whitelisted?' do
    before(:each) do
      allow(helper).to receive(:whitelisted_attr).and_return([:foo, :bar])
    end

    it 'will convert the input to a symbol' do
      input = 'foo'
      expect(input).to receive(:to_sym)
      helper.send(:whitelisted?, input)
    end
    it 'calls #include? on whitelisted_attr' do
      whitelisted_attr = helper.send(:whitelisted_attr)
      expect(whitelisted_attr).to receive(:include?)
      helper.send(:whitelisted?)
    end
  end

  describe '#map_to_s' do
    # TODO: It would be nice to also verify that :to_s is called on each entry
    it 'calls map on the input' do
      input = [:foo, :bar]
      expect(input).to receive(:map)
      helper.send(:map_to_s, input)
    end
  end

  describe '#custom_index_sort' do
    params = { sort: 'column_name', direction: 'asc' }

    before(:each) do
      allow(helper).to receive(:model).and_return(Contact)
      allow(helper).to receive(:collection).and_return([:foo, :bar])
      allow(helper).to receive(:params).and_return(params)
    end

    it 'calls .sort_by_attribute on the model' do
      model = helper.send(:model)
      collection = helper.send(:collection)
      sort = helper.params[:sort]
      direction = helper.params[:direction]

      expect(model)
        .to receive(:sort_by_attribute)
        .with(collection, sort, direction)
      helper.send(:custom_index_sort)
    end
  end

  describe '#directions' do
    it 'returns this array' do
      actual = helper.send(:directions)
      expect(actual).to eq %w(asc desc)
    end
  end
end
