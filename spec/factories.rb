FactoryGirl.define do
  factory :user do
    sequence :email do |n|
      "test#{n}@gmail.com"
    end
    password "secretPass"
    password_confirmation "secretPass"
  end

  factory :post do
    message "hello"
    association :user
  end
end
