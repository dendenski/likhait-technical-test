require 'rails_helper'

RSpec.describe "Api::Categories", type: :request do
  describe "GET /api/categories" do
    let!(:food) { Category.create!(name: "Food") }
    let!(:transport) { Category.create!(name: "Transport") }
    let!(:supplies) { Category.create!(name: "Supplies") }

    it "returns all categories" do
      get "/api/categories"

      expect(response).to have_http_status(:success)
      json = JSON.parse(response.body)
      expect(json.length).to eq(3)
      expect(json.map { |c| c["name"] }).to include("Food", "Transport", "Supplies")
    end

    it "returns categories in alphabetical order" do
      get "/api/categories"

      json = JSON.parse(response.body)
      expect(json.map { |c| c["name"] }).to eq([ "Food", "Supplies", "Transport" ])
    end
  end

  describe "POST /api/categories" do
    let(:valid_params) do
      {
        category: {
          name: "Utilities"
        }
      }
    end

    context "when request is valid" do
      it "creates a new category" do
        expect {
          post "/api/categories", params: valid_params
        }.to change(Category, :count).by(1)

        expect(response).to have_http_status(:created)

        json = JSON.parse(response.body)
        expect(json["name"]).to eq("Utilities")
      end
    end

    context "when request is invalid" do
      it "does not create a category without a name" do
        expect {
          post "/api/categories", params: { category: { name: "" } }
        }.not_to change(Category, :count)

        expect(response).to have_http_status(:unprocessable_entity)

        json = JSON.parse(response.body)
        expect(json).to have_key("errors")
      end
    end

    context "when category already exists" do
      before do
        Category.create!(name: "Food")
      end

      it "does not create duplicate category" do
        expect {
          post "/api/categories", params: {
            category: { name: "Food" }
          }
        }.not_to change(Category, :count)

        expect(response).to have_http_status(:unprocessable_entity)

        json = JSON.parse(response.body)
        expect(json["errors"]).to include("Name has already been taken")
      end
    end
  end
end
