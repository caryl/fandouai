# 全局配置类，使用condig/configuration.yml
class Conf
  $configuration = YAML.load(ERB.new(File.read(RAILS_ROOT + "/config/site_config.yml")).result)[Rails.env]
  # 动态产生Config.xxx调用
  def self.method_missing(name, *arguments)
    key = name.to_s
    if key == 'admin_users'
      $configuration[key].split(',')
    else
      $configuration[key]
    end
  end
end

TagList.delimiter = " "
CAPTCHA_SALT = 'OI*^&D^SJ(;sjwl@#sldkfmK'
