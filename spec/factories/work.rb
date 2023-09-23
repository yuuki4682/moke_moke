FactoryBot.define do
  factory :work do
    title { Faker::Lorem.characters(number: 20) }
    caption { Faker::Lorem.characters(number: 200) }
    user
    
    after(:build) do |work|
      work.main_image.attach(io: File.open("spec/images/test1.jpg"), filename: "test1.jpg", content_type: "application/xlsx")
      work.sub_images.attach(io: File.open("spec/images/test2.jpg"), filename: "test2.jpg", content_type: "application/xlsx")
    end
  end
end
