if Rails.env.development?
  Category.create!(name: "宿泊施設")
  Category.create!(name: "飲食店")
  Category.create!(name: "アミューズメントパーク")
  Category.create!(name: "ショッピングモール")
  Category.create!(name: "観光名所")
  Category.create!(name: "公園")
  Category.create!(name: "運動施設")
  Category.create!(name: "交通施設")
  Category.create!(name: "その他")
end

if Rails.env.production?
  Category.delete_by(name: "その他")
  Category.create!(name: "ショッピングモール")
  Category.create!(name: "観光名所")
  Category.create!(name: "公園")
  Category.create!(name: "運動施設")
  Category.create!(name: "交通施設")
  Category.create!(name: "その他")
end

if Rails.env.test?
  Category.create!(name: "hotel")
  Category.create!(name: "restaurant")
  Category.create!(name: "amusement-park")
  Category.create!(name: "others")
end
