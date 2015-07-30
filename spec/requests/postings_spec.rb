require 'rails_helper'

RSpec.describe "Postings", type: :request do
  describe "GET /postings" do
    it "works! (now write some real specs)" do
      get postings_path
      expect(response).to have_http_status(200)
    end
  end
end
