User.create!(name:  "テスト",
             email: "test@test.com",
             password:              "testtest",
             password_confirmation: "testtest",
             admin: true,
             superior: true)

User.create!(name:  "管理者",
             email: "email@sample.com",
             password:              "password",
             password_confirmation: "password",
             admin: true)
             
User.create!(name:  "上長A",
             email: "emailA@sample.com",
             password:              "password",
             password_confirmation: "password",
             superior: true)
             
User.create!(name:  "上長B",
             email: "emailB@sample.com",
             password:              "password",
             password_confirmation: "password",
             superior: true)

59.times do |n|
  name  = Faker::Name.name
  email = "email#{n+1}@sample.com"
  password = "password"
  User.create!(name:  name,
               email: email,
               password:              password,
               password_confirmation: password)
end