FactoryGirl.define do
  factory :user do
    sequence(:nickname) { |n| "USER_#{n}" }
  end
end
