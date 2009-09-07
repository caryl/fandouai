#简单的状态
#用法：
#include SimpleState
#has_state :collection => [[:unactived, 0, "未激活"],[:normal, 1, "正常"],[:locked, 2, "已锁定"]], :default_state => 1
module SimpleState
  def self.included(base)
    base.extend ClassMethods
  end

  module ClassMethods
    def has_state(options)
      cattr_accessor :states
      self.states = options[:collection]
      self.send(:include, InstanceMethods)
    end
    #for select element
    def options_for_state
      self.states.map{|s|[s.last, s.second]}
    end
    def state_value(key)
      self.states.assoc(key).second
    end
  end

  module InstanceMethods
    def state
      self.class.states.rassoc(self.state_id).try(:last)
    end
    def state_is?(key)
      self.class.state_value(key) == self.state_id
    end
  end
end