# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).

PASSWORD = 'supersecret'

User.destroy_all
Album.destroy_all
Answer.destroy_all
Post.destroy_all

super_user = User.create(
  first_name: 'Jon',
  last_name: 'Snow',
  email: 'js@gmail.com',
  address: 'vancouver',
  contact_number: '7781234567',
  password: PASSWORD,
)
