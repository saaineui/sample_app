namespace :admin do
  desc "Upgrade user of :id to admin"
  task :adminify, [:id] => :environment do |task, args|
    return false unless User.exists?(args.id)
    @user = User.find(args.id)
    if @user.update(admin: true)
        puts @user.name+" is now an admin."
    else
        puts @user.name+" admin status could not be changed."
    end
  end

  task :downgrade, [:id] => :environment do |task, args|
    return false unless User.exists?(args.id)
    @user = User.find(args.id)
    if @user.update(admin: false)
        puts @user.name+" is not an admin."
    else
        puts @user.name+" admin status could not be changed."
    end
  end
end