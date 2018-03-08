# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
PASSWORD = 'supersecret'

User.destroy_all
Answer.destroy_all
Post.destroy_all

super_user = User.create(
  first_name: 'Jon',
  last_name: 'Snow',
  email: 'js@gmail.com',
  password: PASSWORD,
)

10.times.each do
  first_name = Faker::Name.first_name
  last_name = Faker::Name.last_name

  User.create(
    first_name: first_name,
    last_name: last_name,
    email: "#{first_name.downcase}.#{last_name.downcase}@example.com",
    password: PASSWORD
  )
end

users = User.all

puts Cowsay.say "Created #{users.count} users", :tux

100.times.each do
  q = Post.create(
    title: Faker::StarWars.quote,
    body: Faker::Lorem.paragraph,
    user: users.sample
  )
  if q.valid?
    rand(0..10).times.each do
      Answer.create(
        body: Faker::Seinfeld.quote,
        post: q,
        user: users.sample
        # post_id: q.id
      )
    end
  end
end

posts = Post.all
answers = Answer.all

puts Cowsay.say "Created #{posts.count} posts", :frogs
puts Cowsay.say "Created #{answers.count} answers", :sheep

puts "Login at admin with #{super_user.email} and password of '#{PASSWORD}'"
