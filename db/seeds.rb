# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
User.where(email: 'admin@example.com').first_or_create!(password: 'password', password_confirmation: 'password', role: :admin, name: 'Admin')

Rake::Task['occupations:import'].invoke
Rake::Task['after_party:run'].invoke
