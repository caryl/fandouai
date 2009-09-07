ActionController::Routing::Routes.draw do |map|
  map.resources :comments, :only => [:create], :member => {:vote => :post}
  map.resources :articles, :only => [:index, :show], :collection => {:prime=>:get, :hot=>:get}, :member => {:vote => :post}, :has_many => :comments
  map.resources :pages, :only => [:show], :has_many => :comments
  map.resources :users, :only => [:index, :show, :new, :create]
  map.resources :authors, :only => [:index], :has_many => :articles
  map.resources :categories, :only => [], :has_many => :articles
  map.resources :tags, :only => [:index], :has_many => :articles
  map.resources :contributes, :except=>[:destroy]

  map.namespace :admin do |admin|
    admin.resources :categories, :except => [:show]
    admin.resources :articles, :except => [:show], :member => {:manage => :get, :update_manage => :put}
    admin.resources :pages, :except => [:show]
    admin.resources :users
    admin.resources :comments, :except => [:new, :create]
    admin.resource :system, :only=>[:show],
      :collection => {:restart=>:post, :sitemap => :get, :config => :get , :update_config => :post, 
      :css => :get , :update_css => :post, :rake => :post, :bakup=> :get, :download=>:get}
  end

  map.resource :my, :except=>[:new, :create, :destroy], :as => 'my', :collection=>{:send_password=>:post, :reset_password=>:get}
  
  map.root :controller => 'articles'

  map.login '/login', :controller => 'session', :action => 'new'
  map.logout '/logout', :controller => 'session', :action => 'destroy'
  map.findback_password '/findback_password', :controller => 'session', :action => 'findback_password'
  map.signup '/signup', :controller => 'users', :action => 'new'
  
  map.simple_captcha '/simple_captcha/:action', :controller => 'simple_captcha'

  #pager
  map.connect ':controller/page/:page', :requirements => { :page => /\d+/ }, :action => :index
  map.connect '/categories/:category_id/articles/page/:page', :requirements => { :page => /\d+/ }, :controller=>'articles'
  map.connect '/tags/:tag_id/articles/page/:page', :requirements => { :page => /\d+/ }, :controller=>'articles'
  map.connect '/authors/:author_id/articles/page/:page', :requirements => { :page => /\d+/ }, :controller=>'articles'
  map.connect ':controller/:action/page/:page', :requirements => { :page => /\d+/ }
  
  map.connect "logged_exceptions/:action/:id", :controller => "logged_exceptions"
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
