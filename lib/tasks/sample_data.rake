namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    make_users
    make_microposts
    make_relationships
    rand_messages
  end
end

def make_users
  admin = User.create!(name:     "Example User",
                       email:    "example@railstutorial.org",
                       password: "foobar",
                       password_confirmation: "foobar",
                       admin: true)
  99.times do |n|
    name  = Faker::Name.name
    email = "example-#{n+1}@railstutorial.org"
    password  = "password"
    User.create!(name:     name,
                 email:    email,
                 password: password,
                 password_confirmation: password)
  end
end

def make_microposts
  users = User.all(limit: 6)
  50.times do
    content = Faker::Lorem.sentence(5)
    users.each { |user| user.microposts.create!(content: content) }
  end
end

def make_relationships
  users = User.all
  user  = users.first
  followed_users = users[2..50]
  followers      = users[3..40]
  followed_users.each { |followed| user.follow!(followed) }
  followers.each      { |follower| follower.follow!(user) }
end

def make_messages
  users = User.all
  user=User.first
  sendto=users[2..50]
  recvfrom=users[2..50]
  sendto.each   do |reciever| 
                  content = Faker::Lorem.sentence(5)
                  Message.create!(content: content,from_user_id: user.id,to_user_id: reciever.id) 
                end

  recvfrom.each do|sender| 
                   content = Faker::Lorem.sentence(5)
                   Message.create!(content: content,from_user_id: sender.id,to_user_id: user.id) 
                end

end

def rand_messages
   count=User.count
  10000.times do 
     x=rand(1..count)
     y=rand(1..count)
     content = Faker::Lorem.sentence(5)
     Message.create!(content: content,from_user_id: x,to_user_id: y) 
  end
end

