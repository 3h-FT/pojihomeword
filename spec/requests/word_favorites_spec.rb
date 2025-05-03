require 'rails_helper'

RSpec.describe "WordFavorites", type: :request do
  describe "GET /create" do
    it "returns http success" do
      get "/word_favorites/create"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /destroy" do
    it "returns http success" do
      get "/word_favorites/destroy"
      expect(response).to have_http_status(:success)
    end
  end
end
