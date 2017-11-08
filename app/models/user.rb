class User < ActiveRecord::Base
  has_many :my_unread_messages,->{where(read: false)}, class_name: 'Message', foreign_key: 'receiver_id'
  validates :nickname, presence: true, uniqueness: true
  before_create do
    current = DateTime.now
    self.created_at = current
    self.last_online_at = current
  end

  def self.select_with_unread
    left_outer_joins(:my_unread_messages)
      .group('users.id')
      .select('users.*,COUNT(messages.id) as unread_messages')

  end

  def self.select_gt_0_unread_messages
    select_with_unread.having("unread_messages > 0")
                      .order(last_online_at: :desc)
  end

  def self.select_last_online_at
    select_with_unread.where(["last_online_at >= ?", 24.hours.ago])
                      .having("unread_messages = 0").order(last_online_at: :desc)
  end

  def self.select_other
    select_with_unread.where(["last_online_at < ?", 24.hours.ago])
                      .having("unread_messages = 0").order(created_at: :desc)
  end

  def self.wrap_relation relation
    "SELECT * FROM (#{relation.to_sql})"
  end

  def self.smart_sort
    arr = []
    arr[0] = wrap_relation select_gt_0_unread_messages
    arr[1] = wrap_relation select_last_online_at
    arr[2] = wrap_relation select_other
    results = connection.execute arr.join ' UNION '
    results.map{ |r| r.slice('id', 'nickname', 'unread_messages',
      'last_online_at','created_at')}
  end
end
