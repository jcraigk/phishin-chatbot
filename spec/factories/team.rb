# frozen_string_literal: true
FactoryBot.define do
  factory :team do
    name { Faker::Name.unique }
    remote_id { Faker::Crypto.md5[0..10] }
    bot_user_id { Faker::Crypto.md5[0..10] }
    token { Faker::Crypto.md5 }
  end
end
