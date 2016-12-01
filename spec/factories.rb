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
    picture { fixture_file_upload(Rails.root.join('spec', 'fixtures', 'picture.png'), 'image/png') }
    caption "World"
    association :user
  end
end
