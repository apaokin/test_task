require 'spec_helper'

RSpec.describe UsersController, type: :request do
  describe "POST create" do
    it "creates user" do
      post '/users', nickname: 'first_user'
      expect(JSON.parse(response.body)["success"]).to eq true
      expect(response.status).to eq  200
    end
    it "fails to create user(empty nickname)" do
      post '/users', nickname: ''
      expect(JSON.parse(response.body)['success']).to eq false
      expect(JSON.parse(response.body)['errors']).to eq ['NICKNAME_EMPTY']
      expect(response.status).to eq 400
   	end
     it "fails to create user(uniqueness)" do
       User.create! nickname: 'taken'
       post '/users', nickname: 'taken'
       expect(JSON.parse(response.body)['success']).to eq false
       expect(JSON.parse(response.body)['errors']).to eq ['NICKNAME_TAKEN']
       expect(response.status).to eq 400
     end
   end
  describe "GET /users" do
     it "1" do
       User.create! nickname: 'nick'
       get '/users'
       expect(JSON.parse(response.body)['users']).to eq User.smart_sort
       puts User.smart_sort
       expect(response.status).to eq 200
     end
  end
end
