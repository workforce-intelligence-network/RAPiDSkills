# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require 'faker'

admin = User.where(email: 'admin@example.com').first_or_create!(password: 'password', password_confirmation: 'password', role: :admin, name: 'Admin')
user = User.where(email: 'foo@example.com').first_or_create!(password: 'password', password_confirmation: 'password', role: :basic, name: 'Foo Bob')

Rake::Task['occupations:import'].invoke

organization = Organization.where(title: "Acme Computing").first_or_create!

occupation_standard = FrameworkStandard.create(
  creator: user,
  organization: organization,
  occupation: Occupation.first,
  title: Faker::Job.title,
)

wps = []
(1..4).each do
  wps << WorkProcess.create(
    title: Faker::Lorem.sentence,
    description: Faker::Lorem.paragraph,
  )
end

wps.each_with_index do |work_process, index|
  oswp = OccupationStandardWorkProcess.create(
    occupation_standard: occupation_standard,
    work_process: work_process,
    sort_order: index,
    hours: 10 * (index + 1),
  )

  (1..2).each_with_index do |i, skill_index|
    skill = Skill.create(description: Faker::Job.key_skill)
    OccupationStandardSkill.create(
      occupation_standard: occupation_standard,
      skill: skill,
      occupation_standard_work_process: oswp,
      sort_order: skill_index,
    )
  end
end

(1..2).each_with_index do |i, index|
 skill = Skill.create(description: Faker::Job.key_skill)
 OccupationStandardSkill.create(
   occupation_standard: occupation_standard,
   skill: skill,
   occupation_standard_work_process: nil,
   sort_order: index,
 )
end

Rake::Task['after_party:run'].invoke
