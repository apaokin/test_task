require 'spec_helper'

RSpec.describe UsersController, type: :controller do
  describe "GET /users" do
     it "" do
       User.create! nickname: 'nick'
       get :index
       expect(JSON.parse(response.body)['users']).to eq User.smart_sort
       expect(response.status).to eq 200
     end
  end
end
