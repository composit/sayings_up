FactoryGirl.define do
  sequence :username do |n|
    "person#{n}"
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
    username
    email
    password 'testpass'
    password_confirmation 'testpass'
  end
end
