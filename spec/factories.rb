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
    user

    factory :entry_with_comment do
      after( :build ) do |entry|
        build :comment, entry: entry
      end
    end
  end

  factory :exchange do
    factory :exchange_with_entry_and_comment do
      after( :build ) do |exchange|
        build :entry_with_comment, exchange: exchange
      end
    end
  end
  
  factory :tagging do
    tag_name 'testtag'
    exchange
    user
  end

  factory :user do
    username
    email
    password 'testpass'
    password_confirmation 'testpass'
  end
end
