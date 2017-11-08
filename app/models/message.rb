class Message < ActiveRecord::Base
  belongs_to :receiver, class_name: 'User'
  belongs_to :sender, class_name: 'User'
  validates :sender,:receiver, presence: true

  before_save do
    sender = User.find(sender_id)
    sender.last_online_at = DateTime.now
    sender.save!
  end

  def self.get_correspondence_and_update(current_user_id, second_id)
    where("sender_id = #{second_id} AND receiver_id = #{current_user_id}")
      .update_all(read: true)
    where_correspondence(current_user_id, second_id).order(:id)
  end
  def self.where_correspondence(first_id, second_id)
    where("sender_id = #{first_id} AND receiver_id = #{second_id} OR "\
      "sender_id = #{second_id} AND receiver_id = #{first_id}")
  end
end
