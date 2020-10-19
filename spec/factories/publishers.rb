FactoryBot.define do
  factory :publisher do
    name { Faker::Lorem.characters(number: 20) }
  end
end
