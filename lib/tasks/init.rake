namespace :site do
  desc "init data"
  task :init => :environment do
    User.create(:user_name => 'admin', :new_password=>'admin', :email=>'admin@fandouai.com')
    Category.create(:title=>'文章分类', :param=>'article')
    Category.create(:title=>'页面分类', :param=>'page')
    puts "done"
  end
end