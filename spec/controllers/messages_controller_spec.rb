require 'spec_helper'

RSpec.describe MessagesController do
  describe "GET messages",type: :controller do
    it "gets messages" do
      from_id = User.create!(nickname: 'from').id
      to_id = User.create!(nickname: 'to').id
      Message.create!(sender_id: from_id, receiver_id: to_id, message: 'message')
      prev_online = User.find_by(nickname: 'to').last_online_at.to_s
      sleep 1
      get :index, current_user_id: to_id, target_user_id: from_id
      expect(JSON.parse(response.body)["success"]).to eq true
      expect(response.status).to eq 200
      expect(User.find_by(nickname: 'to').last_online_at.to_s).not_to eq prev_online
    end
  end
end
