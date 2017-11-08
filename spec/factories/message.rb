FactoryGirl.define do
  factory :message do
    sequence(:message) { |n| "message_#{n}" }
    association :sender, factory: :user
    association :receiver, factory: :user
  end
end
