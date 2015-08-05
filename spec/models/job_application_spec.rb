require 'rails_helper'

describe JobApplication, type: :model do

  let(:ja) { JobApplication.all }

  describe "test subjects list" do
    it "has 30 items" do
      expect(ja.count).to eq 30
    end
    it "is a JobApplication::ActiveRecord_Relation" do
      expect(ja).to be_an ActiveRecord::Relation
    end
    it "is composed entirely of JobApplication objects" do
      expect(ja).to all be_a JobApplication
    end
  end

  describe '.sort_by_attribute' do

    context 'sorting by a virtual attribute' do

      let(:sorted_titles) { ja.map{|r| r.title}.sort }

      shared_examples_for 'sorting by a virtual attribute' do
        it "can sort by a virtual attribute" do
          actual = JobApplication.
            sort_by_attribute(subject, :title).
            map{ |r| r.title }
          expect(actual).to eq sorted_titles
        end
      end

      context 'when passing in ActiveRecord::Relation' do
        subject { ja }
        it_behaves_like 'sorting by a virtual attribute'
      end
      context 'when passing in Array' do
        subject { ja.to_a }
        it_behaves_like 'sorting by a virtual attribute'
      end

    end

  end
end
