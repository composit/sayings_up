FactoryGirl.define do
  sequence :name do |n|
    "Person#{n}"
  end

  sequence :email do |n|
    "test#{n}@example.com"
  end

  factory :comment do
    entry
    user
  end

  factory :entry do
    exchange
  end

  factory :exchange do
  end
  
  factory :user do
    name
    email
    password 'testpass'
    password_confirmation 'testpass'
  end
end
