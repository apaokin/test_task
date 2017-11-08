require 'spec_helper'

RSpec.describe MessagesController, type: :request do
  describe "POST create" do
    it "creates message" do
      from_id = User.create!(nickname: 'from').id
      to_id = User.create!(nickname: 'to').id
      prev_online = User.find_by(nickname: 'from').last_online_at.to_s
      sleep 1
      post '/messages', from: from_id, to: to_id, message: 'message'
      expect(JSON.parse(response.body)["success"]).to eq true
      expect(response.status).to eq 200
      expect(User.find_by(nickname: 'from').last_online_at.to_s).not_to eq prev_online
    end
    it "fails to create message" do
      from_id = User.create!(nickname: 'from').id
      to_id = User.create!(nickname: 'to').id
      post '/messages', from: from_id, to: to_id + 1, message: 'message'
      expect(JSON.parse(response.body)["success"]).to eq false
      expect(JSON.parse(response.body)['errors']).to eq ['USER_NOT_FOUND']
      expect(response.status).to eq 400
    end
  end
  describe "GET messages" do
    it "gets messages" do
      from_id = User.create!(nickname: 'from').id
      to_id = User.create!(nickname: 'to').id
      Message.create!(sender_id: from_id, receiver_id: to_id, message: 'message')
      prev_online = User.find_by(nickname: 'to').last_online_at.to_s
      sleep 1
      get "/messages/#{to_id}/#{from_id}"
      expect(JSON.parse(response.body)["success"]).to eq true
      puts JSON.parse(response.body)['messages'].inspect
      expect(response.status).to eq 200
      expect(User.find_by(nickname: 'to').last_online_at.to_s).not_to eq prev_online
      expect(Message.first.read).to eq true
    end
    it "gets messages" do
      from_id = User.create!(nickname: 'from').id
      to_id = User.create!(nickname: 'to').id
      Message.create!(sender_id: from_id, receiver_id: to_id, message: 'message')
      prev_online = User.find_by(nickname: 'to').last_online_at.to_s
      sleep 1
      get "/messages/#{to_id+10}/#{from_id}"
      expect(JSON.parse(response.body)["success"]).to eq false
      expect(response.status).to eq 400
      expect(User.find_by(nickname: 'to').last_online_at.to_s).to eq prev_online
      expect(Message.first.read).to eq false
    end
  end
end
