# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first
AdminUser.create_with(password: 'Developer20!!').find_or_create_by(email: 'admin@very_us.com')

EarnOn.active.first_or_create
BurnOn.active.first_or_create
MasterBucketConfig.active.first_or_create
AddTodoDetailsService.call
AddBannersService.call
LocationConfig.active.first_or_create
ApplicationConfig.active.first_or_create

# def get_random_traits
#   ["Athletic", "Creative", "Cultured", "EarlyRiser", "Enthusiastic", "Honest", "Humble", "Humorous", "Innovative", "Intutive", "Leisurely", "Logical", "NightOwls", "Optimistic", "Polite", "Realist", "Social", "Versatile"].sample(rand(10)+1)
# end
