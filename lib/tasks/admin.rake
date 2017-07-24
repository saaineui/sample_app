namespace :admin do
  desc 'Upgrade user #id to admin'
  task :adminify, [:id] => :environment do |_, args|
    if User.exists?(args.id)
      @user = User.find(args.id)
      alert = @user.update(admin: true) ? ' is now an admin.' : ' admin status could not be changed.'
      puts @user.name + alert
    else
      puts "User #{args.id} does not exist."
    end
  end

  desc 'Remove admin privs from user #id'
  task :downgrade, [:id] => :environment do |_, args|
    if User.exists?(args.id)
      @user = User.find(args.id)
      alert = @user.update(admin: false) ? ' is not an admin.' : ' admin status could not be changed.'
      puts @user.name + alert
    else
      puts "User #{args.id} does not exist."
    end
  end
end
