
FactoryBot.define do
  factory :user, class: 'TwitterResearch::Database::User' do
    name { Faker::Name.name }
    username { Faker::Internet.username }
    description { Faker::Books::Lovecraft.paragraph }
    url { Faker::Internet.url }
    _role { Faker::TvShows::StarTrek.specie }

    public_metrics do
      { 'followers_count' => Faker::Number.number,
        'following_count' => Faker::Number.number }
    end
  end
end
