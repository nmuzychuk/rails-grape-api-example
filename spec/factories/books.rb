FactoryBot.define do
  factory :book do
    title { Faker::Lorem.characters(number: 30) }
    description { Faker::Lorem.sentence }
    page_count { Faker::Number.number(digits: 3) }

    publisher

    transient do
      categories_count { 1 }
    end

    categories do
      Array.new(categories_count) do
        association(:category, books: [instance])
      end
    end
  end
end
