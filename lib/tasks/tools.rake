namespace :tools do
  desc "备份数据库"
  task :bak_db => :environment do
    dir = "#{Rails.root}/#{Conf.bak_path}"
    FileUtils.mkdir_p dir unless File.exist? dir
    config = YAML.load(File.read("#{Rails.root}/config/database.yml"))[Rails.env]
    file_name = "#{dir}#{config['database']}_#{Time.now.strftime '%y%m%d%H%M%S'}.gz"
    `mysqldump -u#{config['username']} -p#{config['password']} #{config['database']} | gzip > #{file_name}`
    puts "已备份至#{file_name}."
  end
  desc "备份public文件夹"
  task :bak_file => :environment do
    dir = "#{Rails.root}/#{Conf.bak_path}"
    FileUtils.mkdir_p dir unless File.exist? dir
    file_name = "#{dir}public_#{Time.now.strftime '%y%m%d%H%M%S'}.gz"
    `gzip -c -r #{Rails.root}/public > #{file_name}`
    puts "已备份文件至#{file_name}."
  end
  desc "清空备份文件夹"
  task :bak_clear => :environment do
    dir = "#{Rails.root}/#{Conf.bak_path}"
    `rm #{dir}/*`
  end
end