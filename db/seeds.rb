# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
# Category.create!(name: "宿泊施設")
# Category.create!(name: "飲食店")
# Category.create!(name: "アミューズメントパーク")
# Category.create!(name: "その他")

if Rails.env.development? || Rails.env.production?
  Category.create!(name: "宿泊施設")
  Category.create!(name: "飲食店")
  Category.create!(name: "アミューズメントパーク")
  Category.create!(name: "その他")
end

if Rails.env.test?
  Category.create!(name: "hotel")
  Category.create!(name: "restaurant")
  Category.create!(name: "amusement-park")
  Category.create!(name: "others")
end
