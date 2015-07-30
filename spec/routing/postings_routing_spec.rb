require "rails_helper"

RSpec.describe PostingsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/postings").to route_to("postings#index")
    end

    it "routes to #new" do
      expect(:get => "/postings/new").to route_to("postings#new")
    end

    it "routes to #show" do
      expect(:get => "/postings/1").to route_to("postings#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/postings/1/edit").to route_to("postings#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/postings").to route_to("postings#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/postings/1").to route_to("postings#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/postings/1").to route_to("postings#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/postings/1").to route_to("postings#destroy", :id => "1")
    end

  end
end
