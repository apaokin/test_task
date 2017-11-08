require 'spec_helper'

RSpec.describe User, type: :model do
  describe "User::select_gt_0_unread_messages" do
    it 'select_gt_0_unread_messages' do
      create(:user)
      user = create(:message).receiver
      create(:message, read: true, receiver: user )
      create(:message, read: false, receiver: user )
      results = User.select_gt_0_unread_messages
      expect(results).to eq [user]
      expect(results.first.unread_messages).to eq 2
    end
  end
  describe "User::select_last_online_at" do
    it 'select_last_online_at' do
      old_user = create(:user)
      old_user.last_online_at = 24.days.ago
      old_user.save!
      message = create(:message, read: true)
      results = User.select_last_online_at
      expect(results).to match_array [message.receiver, message.sender]
    end
  end
  describe "User::select_other" do
    it 'select_other' do
      old_user = create(:user)
      old_user.last_online_at = 24.days.ago
      old_user.save!
      message = create(:message, read: true)
      results = User.select_other
      expect(results).to match_array [old_user]
    end
  end

  describe "User::smart_sort" do
    it "doesn't raise exception" do
      create :user
      create :message
      puts User.smart_sort
      expect(User.smart_sort.count).to eq 3
    end
  end
end
