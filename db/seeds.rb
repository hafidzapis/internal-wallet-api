# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
# Create Users
require 'bcrypt'

# # Create Users
# user1 = User.create!(user_name: 'user1', password: BCrypt::Password.create('password1'), name: 'John Doe')
# user2 = User.create!(user_name: 'user2', password: BCrypt::Password.create('password2'), name: 'Jane Doe')
#
# # Create Teams
# team1 = Team.create!(user_name: 'team1', password: BCrypt::Password.create('team_password1'), name: 'Team A')
# team2 = Team.create!(user_name: 'team2', password: BCrypt::Password.create('team_password2'), name: 'Team B')
#
# # Create Stocks
# stock1 = Stock.create!(user_name: 'stock1', password: BCrypt::Password.create('stock_password1'), name: 'Company X')
# stock2 = Stock.create!(user_name: 'stock2', password: BCrypt::Password.create('stock_password2'), name: 'Company Y')
#
# # Print a message
# puts 'Data added successfully!'


# Find or Create Users with Wallets
# user1 = User.find_or_create_by(user_name: 'user1') do |user|
#   user.password = BCrypt::Password.create('password1')
#   user.name = 'John Doe'
# end
# Wallet.find_or_create_by(entity: user1)
#
# user2 = User.find_or_create_by(user_name: 'user2') do |user|
#   user.password = BCrypt::Password.create('password2')
#   user.name = 'Jane Doe'
# end
# Wallet.find_or_create_by(entity: user2)
#
# # Print a message
puts 'Data added successfully!'
