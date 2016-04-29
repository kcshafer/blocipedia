require 'faker'

5.times do
    User.create!(
        email:    Faker::Internet.email,
        password: Faker::Internet.free_email
    )
end
users = User.all

10.times do
    Wiki.create!(
        title: Faker::Lorem.word,
        body: Faker::Lorem.sentences(4),
        private: false,
        user_id: users.sample.id
    )
end