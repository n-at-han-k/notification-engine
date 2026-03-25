user = User.find_or_create_by!(name: "Demo User")
puts "Seed user: #{user.name} (id: #{user.id})"
