FactoryBot.define do
  factory :movie do
    title { Faker::Movie.quote }
    rating  { Faker::Number.digit }
    url { Faker::Internet.url }
  end
end