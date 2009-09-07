# Set the host name for URL creation
SitemapGenerator::Sitemap.default_host = "http://www.#{Conf.site_domain}"

SitemapGenerator::Sitemap.add_links do |sitemap|
  # Put links creation logic here.
  #
  # The root path '/' and sitemap index file are added automatically.
  # Links are added to the Sitemap in the order they are specified.
  #
  # Usage: sitemap.add path, options
  #        (default options are used if you don't specify)
  #
  # Defaults: :priority => 0.5, :changefreq => 'weekly', 
  #           :lastmod => Time.now, :host => default_host

  
  # Examples:
  
  # add '/articles'
  sitemap.add articles_path, :priority => 0.7, :changefreq => 'daily'
  articles = Article.visible.paginate(:page=>1)
  (2 .. articles.total_pages).each do |page|
    sitemap.add "#{articles_path}/page/#{page}", :priority => 0.7, :changefreq => 'daily'
  end

  # add all individual articles
  Article.find(:all).each do |a|
    sitemap.add article_path(a), :lastmod => a.updated_at
  end

  Page.find(:all).each do |a|
    sitemap.add page_path(a), :lastmod => a.updated_at
  end
  # add merchant path
  sitemap.add '/authors', :priority => 0.7, :host => "https://www.#{Conf.site_domain}"
  sitemap.add '/tags', :priority => 0.7, :host => "https://www.#{Conf.site_domain}"
  sitemap.add '/authors', :priority => 0.7, :host => "https://www.#{Conf.site_domain}"

end
