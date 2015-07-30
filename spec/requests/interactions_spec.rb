require 'rails_helper'

RSpec.describe "Interactions", type: :request do
  describe "GET /interactions" do
    it "works! (now write some real specs)" do
      get interactions_path
      expect(response).to have_http_status(200)
    end
  end
end
