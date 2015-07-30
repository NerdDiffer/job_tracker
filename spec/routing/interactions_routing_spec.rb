require "rails_helper"

RSpec.describe InteractionsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/interactions").to route_to("interactions#index")
    end

    it "routes to #new" do
      expect(:get => "/interactions/new").to route_to("interactions#new")
    end

    it "routes to #show" do
      expect(:get => "/interactions/1").to route_to("interactions#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/interactions/1/edit").to route_to("interactions#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/interactions").to route_to("interactions#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/interactions/1").to route_to("interactions#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/interactions/1").to route_to("interactions#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/interactions/1").to route_to("interactions#destroy", :id => "1")
    end

  end
end
