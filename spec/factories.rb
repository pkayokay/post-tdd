FactoryGirl.define do
  factory :user do
    sequence :email do |n|
      "test#{n}@gmail.com"
    end
    password "secretPass"
    password_confirmation "secretPass"
  end

  factory :post do
    title "Hello"
    message "World"
    association :user
  end
end
