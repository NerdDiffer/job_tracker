require 'rails_helper'

describe SearchSuggestion::Search do
  let(:search) { described_class.new('foo', 'bar') }

  describe '#initialize' do
    before(:each) do
      allow_any_instance_of(described_class).to receive(:search).and_return([])
    end

    it 'sets these attributes' do
      attr_list = [:set_key, :query, :results, :range_len,
                   :max_results_count, :early_return_trigger]

      attr_list.each do |attr|
        actual = search.public_send(attr)
        expect(actual).not_to be_nil
      end
    end
    it 'calls #search' do
      expect_any_instance_of(described_class).to receive(:search).and_return([])
      described_class.new('foo', 'bar')
    end
  end

  describe '#search' do
    before(:each) do
      allow(search).to receive(:max_results_count).and_return(2)
    end

    context '@start is nil' do
      before(:each) do
        allow(search).to receive(:starting_point).and_return(nil)
      end

      it 'calls #starting_point' do
        expect(search).to receive(:starting_point).and_return(nil)
        search.send(:search)
      end
      it 'sets value of @start to #starting_point' do
        expect(search.start).to be_nil
        search.send(:search)
      end
      it 'returns [] when @start is nil' do
        expect(search.send(:search)).to eq []
      end
    end

    context 'when @start is NOT nil' do
      before(:each) do
        allow(search).to receive(:starting_point).and_return(0)
        allow(search).to receive(:iterate)
      end

      context 'when result of #iterate is an early return trigger' do
        it 'breaks the loop' do
          allow(search).to receive(:early_trigger?).and_return(true)
          expect(search).to receive(:iterate).exactly(1).times
          search.send(:search)
        end
      end
      context 'when result of #iterate is NOT an early return trigger' do
        it 'does NOT call for a break' do
          allow(search).to receive(:continue_search?).and_return(true, true, false)
          allow(search).to receive(:early_trigger?).and_return(false)
          expect(search).to receive(:iterate).exactly(2).times
          search.send(:search)
        end
      end
    end
  end

  describe '#starting_point' do
    before(:each) do
      allow(search).to receive(:set_key).and_return('bar')
      allow(search).to receive(:query).and_return('foo')
    end

    it 'calls #zrank on redis client with these args' do
      expect(REDIS_CLIENT).to receive(:zrank).with('bar', 'foo')
      search.send(:starting_point)
    end
  end

  describe '#continue_search?' do
    let(:results) { [:foo] }

    before(:each) do
      allow(search).to receive(:results).and_return(results)
      allow(results).to receive(:length).and_return(1)
    end

    it 'is true' do
      allow(search).to receive(:max_results_count).and_return(2)
      expect(search.send(:continue_search?)).to be_truthy
    end

    it 'is false' do
      allow(search).to receive(:max_results_count).and_return(0)
      expect(search.send(:continue_search?)).to be_falsey
    end
  end

  describe '#early_trigger?' do
    before(:each) do
      allow(search).to receive(:early_return_trigger).and_return(:foo)
    end

    it 'returns true if result is equal to early_return_trigger' do
      actual = search.send(:early_trigger?, :foo)
      expect(actual).to be_truthy
    end
    it 'returns false if result is NOT equal to early_return_trigger' do
      actual = search.send(:early_trigger?, :bar)
      expect(actual).to be_falsey
    end
  end

  describe '#iterate' do
    it 'calls #next_batch' do
      allow(search).to receive(:empty?).and_return(true)
      expect(search).to receive(:next_batch)
      search.send(:iterate)
    end

    context 'when the batch is empty' do
      it 'returns value of #early_return_trigger' do
        allow(search).to receive(:next_batch)
        allow(search).to receive(:empty?).and_return(true)
        allow(search).to receive(:early_return_trigger).and_return(:foobar)
        actual = search.send(:iterate)
        expect(actual).to eq :foobar
      end
    end

    context 'when batch is NOT empty' do
      before(:each) do
        allow(search).to receive(:next_batch)
        allow(search).to receive(:empty?).and_return(false)
      end

      it 'iterates through the batch' do
        allow(search).to receive(:batch).and_return([])
        expect(search.batch).to receive(:each)
        search.send(:iterate)
      end

      context 'inside the loop' do
        before(:each) do
          allow(search).to receive(:batch).and_return([:foo, :bar])
          allow(search).to receive(:process)
        end

        context 'when result of #process is an early return trigger' do
          it 'breaks the loop' do
            allow(search).to receive(:early_trigger?).and_return(true)
            expect(search).to receive(:process).exactly(1).times
            search.send(:iterate)
          end
        end
        context 'when result of #process is NOT an early return trigger' do
          it 'does NOT call for a break' do
            allow(search).to receive(:early_trigger?).and_return(false)
            expect(search).to receive(:process).exactly(2).times
            search.send(:iterate)
          end
        end
      end
    end
  end

  describe '#next_batch' do
    before(:each) do
      allow(search).to receive(:set_key).and_return('foo')
      allow(search).to receive(:range_len).and_return(10)
      allow(search).to receive(:start).and_return(0)
      allow(REDIS_CLIENT)
        .to receive(:zrange)
        .and_return(%w(foo bar))
    end
    after(:each) do
      search.instance_eval { @batch = nil }
      search.instance_eval { @start = nil }
    end

    context '@batch & REDIS_CLIENT' do
      before(:each) do
        search.instance_eval { @batch = %w(foo) }
        search.instance_eval { @start = 0 }
      end

      it 'calls zrange on the redis client' do
        expect(REDIS_CLIENT).to receive(:zrange).with('foo', 0, 9)
        search.send(:next_batch)
      end
      it 'sets a value for the @batch variable' do
        search.send(:next_batch)
        expect(search.batch).to eq %w(foo bar)
      end
    end

    context '@start' do
      before(:each) do
        search.instance_eval { @batch = %w(foo) }
        search.instance_eval { @start = 10 }
        allow(search).to receive(:start).and_return(0, 0, search.range_len)
      end

      it 'changes value of @start by 10' do
        expect { search.send(:next_batch) }
          .to change { search.start }
          .by(search.range_len)
      end
    end
  end

  describe '#empty?' do
    it 'calls #empty? on the input' do
      input = 'foo'
      expect(input).to receive(:empty?)
      search.send(:empty?, input)
    end
  end

  describe '#process' do
    let(:input) { 'foo' }

    before(:each) do
      allow(search).to receive(:prepare_range)
    end

    it 'calls #prepare_range' do
      allow(search).to receive(:not_matching?).and_return(false)
      allow(search).to receive(:ok_to_append?).and_return(false)
      expect(search).to receive(:prepare_range)
      search.send(:process, input)
    end

    context 'if #not_matching? is true' do
      before(:each) do
        allow(search).to receive(:early_return_trigger).and_return(:foobar)
        allow(search).to receive(:not_matching?).and_return(true)
        allow(search).to receive(:results).and_return([:foo])
      end

      it 'sets max_results_count to the length of results' do
        search.send(:process, input)
        expect(search.max_results_count).to eq(1)
      end
      it 'returns early by calling #early_return_trigger' do
        actual = search.send(:process, input)
        expect(actual).to eq(:foobar)
      end
    end
    context 'if #not_matching? is false' do
      before(:each) do
        allow(search).to receive(:prepare_range)
        allow(search).to receive(:not_matching?).and_return(false)
      end
      after(:each) do
        search.send(:process, input)
      end

      it 'calls #ok_to_append?' do
        allow(search).to receive(:ok_to_append?).and_return(false)
        expect(search).to receive(:ok_to_append?).with(input)
      end
      context 'if #ok_to_append? is true' do
        it 'calls #append_to_results!' do
          allow(search).to receive(:ok_to_append?).and_return(true)
          expect(search).to receive(:append_to_results!).with(input)
        end
      end
    end
  end

  describe '#prepare_range' do
    let(:input) { 'foo' }

    before(:each) do
      allow(input).to receive(:length).and_return(3)
      allow(search).to receive(:query).and_return('foobar')
      allow(search.query).to receive(:length).and_return(6)
    end

    it 'the input receives .length' do
      expect(input).to receive(:length)
      search.send(:prepare_range, input)
    end
    it 'the query receives .length' do
      expect(search.query).to receive(:length)
      search.send(:prepare_range, input)
    end
    it 'returns a range with the smaller of the two lengths' do
      actual = search.send(:prepare_range, input)
      expect(actual).to eq((0...3))
    end
  end

  describe '#not_matching?' do
    let(:range) { (0...6) }
    before(:each) do
      allow(search).to receive(:query).and_return('foobar')
    end

    it 'calls the [] method with the range on the input' do
      input = 'foo'
      expect(input).to receive(:[]).with(range)
      search.send(:not_matching?, input, range)
    end
    it 'calls the [] method with the range on the query' do
      expect(search.query).to receive(:[]).with(range)
      search.send(:not_matching?, 'foo', range)
    end
    it 'returns true when entry will NOT match the query' do
      entry = 'football'
      actual = search.send(:not_matching?, entry, range)
      expect(actual).to be_truthy
    end
    it 'returns false when entry will match the query' do
      entry = 'foobar'
      actual = search.send(:not_matching?, entry, range)
      expect(actual).to be_falsey
    end
  end

  describe '#ok_to_append?' do
    context 'true' do
      before(:each) do
        allow(search).to receive(:last_value_is_glob?).and_return(true)
        allow(search).to receive(:num_results_not_eq_to_max?).and_return(true)
      end
      it 'is true when both methods return true' do
        expect(search.send(:ok_to_append?, 'foo')).to be_truthy
      end
    end
    context 'false' do
      after(:each) do
        expect(search.send(:ok_to_append?, 'foo')).to be_falsey
      end

      it 'is otherwise false' do
        allow(search).to receive(:last_value_is_glob?).and_return(false)
        allow(search).to receive(:num_results_not_eq_to_max?).and_return(true)
      end
      it 'is otherwise false' do
        allow(search).to receive(:last_value_is_glob?).and_return(true)
        allow(search).to receive(:num_results_not_eq_to_max?).and_return(false)
      end
      it 'is otherwise false' do
        allow(search).to receive(:last_value_is_glob?).and_return(false)
        allow(search).to receive(:num_results_not_eq_to_max?).and_return(false)
      end
    end
  end

  describe '#last_value_is_glob?' do
    it 'the input receives [] with a range' do
      input = 'foobar'
      expect(input).to receive(:[]).with((-1..-1))
      search.send(:last_value_is_glob?, input)
    end
    it 'returns true when last value in input is "*"' do
      actual = search.send(:last_value_is_glob?, 'foo*')
      expect(actual).to be_truthy
    end
    it 'otherwise returns false' do
      actual = search.send(:last_value_is_glob?, 'foo')
      expect(actual).to be_falsey
    end
  end

  describe '#num_results_not_eq_to_max?' do
    before(:each) do
      allow(search).to receive(:max_results_count).and_return(1)
    end

    it 'returns true when results.length != max_results_count' do
      allow(search).to receive(:results).and_return([:foo, :bar])
      actual = search.send(:num_results_not_eq_to_max?)
      expect(actual).to be_truthy
    end
    it 'otherwise returns false' do
      allow(search).to receive(:results).and_return([:foo])
      actual = search.send(:num_results_not_eq_to_max?)
      expect(actual).to be_falsey
    end
  end

  describe '#append_to_results!' do
    let(:input) { 'foo*' }

    context 'the input' do
      it 'receives [] with a range' do
        expect(input).to receive(:[]).with(an_instance_of(Range))
        search.send(:append_to_results!, input)
      end
    end
    it 'adds a value to results' do
      allow(input).to receive(:[]).with(an_instance_of(Range)).and_return('foo')
      expect(search.results).to receive(:<<).with('foo')
      search.send(:append_to_results!, input)
    end
  end
end
