User.create!(name:  "テスト",
             email: "test@test.com",
             password:              "testtest",
             password_confirmation: "testtest",
             admin: true)

User.create!(name:  "管理者",
             email: "email@sample.com",
             password:              "password",
             password_confirmation: "password",
             admin: true)

59.times do |n|
  name  = Faker::Name.name
  email = "email#{n+1}@sample.com"
  password = "password"
  User.create!(name:  name,
               email: email,
               password:              password,
               password_confirmation: password)
end