require 'rails_helper'

class DummyController < ApplicationController
  include OwnResources

  private

  def member
    # noop
  end

  def model
    # noop
  end
end

describe OwnResources, type: :controller do
  let(:user)   { build(:user) }
  let(:member) { double('member', user: true) }
  let(:model)  { double('Model', belonging_to_user: true) }
  let(:controller) { DummyController.new }

  describe '#check_user' do
    after(:each) do
      controller.send(:check_user)
    end

    it 'calls #correct_user?' do
      allow(controller).to receive(:correct_user?).and_return(true)
      expect(controller).to receive(:correct_user?)
    end
    context 'when #correct_user? is true' do
      it 'does not redirect' do
        allow(controller).to receive(:correct_user?).and_return(true)
        expect(controller).not_to receive(:redirect_to)
      end
    end
    context 'when #correct_user? is false' do
      it 'redirects to root_url' do
        allow(controller).to receive(:correct_user?).and_return(false)
        allow(controller).to receive(:redirect_to).and_return(true)
        allow(controller).to receive(:root_url).and_return(true)
        expect(controller).to receive(:redirect_to).with(root_url)
      end
    end
  end

  describe '#correct_user?' do
    before(:each) do
      allow(controller).to receive(:member).and_return(member)
      allow(member).to receive(:user).and_return(user)
      allow(controller).to receive(:current_user?)
    end
    after(:each) do
      controller.send(:correct_user?)
    end
    it 'calls #current_user?' do
      expect(controller).to receive(:current_user?).with(user)
    end
    it 'calls #member' do
      expect(controller).to receive(:member)
    end
    it 'calls #user on the results of member' do
      saved_member = controller.send :member
      expect(saved_member).to receive(:user)
    end
  end

  describe '#collection_belonging_to_user' do
    before(:each) do
      allow(user).to receive(:id).and_return(1)
      allow(controller).to receive(:current_user).and_return(user)
      allow(controller).to receive(:model).and_return(model)
    end
    after(:each) do
      controller.send(:collection_belonging_to_user)
    end

    it 'calls #model' do
      expect(controller).to receive(:model)
    end
    it 'calls #calls belonging_to_user on the model' do
      expect(model).to receive(:belonging_to_user).with(1)
    end
    it 'calls #current_user' do
      expect(controller).to receive(:current_user)
    end
    it 'calls #id on current_user' do
      expect(controller.current_user).to receive(:id)
    end
  end
end
