namespace :bushido do
  desc "Run the initial Bushido install tasks"
  task :install => :environment do
    print "Creating kogo..."
    User.create(:first_name => "kogo", :last_name => "bot")
    puts "Done! Thank you sire!"
  end
end
