# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Affinity.create!(name: "Biographies")
Affinity.create!(name: "Science Fiction")
Affinity.create!(name: "Greek Tragedy")

User.create!(name:  "Eve",
             email: "eve@spineless.com",
             password:              "foobar",
             password_confirmation: "foobar",
             affinities: [Affinity.first],
             admin: true)
User.create!(name:  "Adam",
             email: "adam@spineless.com",
             password:              "foobar",
             password_confirmation: "foobar",
             affinities: [Affinity.last])