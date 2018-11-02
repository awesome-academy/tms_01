User.create!(name: "Nguyen Huan",
             email: "nguyenhuan1994dn@gmail.com",
             password: "123456",
             password_confirmation: "123456",
             address: "tele tua lua",
             role: "supervisor",
             phone_number: "0123456789")

20.times do |n|
  name  = Faker::Name.name
  email = "example-#{n+1}@railstutorial.org"
  password = "password"
  phone_number = "0123456789"
  address = "to 45"
  User.create!(name:  name,
               email: email,
               password: password,
               password_confirmation: password,
               address: address,
               phone_number: phone_number)
end

20.times do |n|
  title = Faker::Lorem.sentence
  description = Faker::Lorem.paragraph
  Subject.create!(title: title,
    description: description)

    Course.create!(title: "Nguyen Huan",
              description: "nguyenhuan1994dn@gmail.com",
              time_traning: 23)

20.times do |n|
  title = Faker::Lorem.sentence
  description = Faker::Lorem.paragraph
  Course.create!(title: title,
               description: description)
end
