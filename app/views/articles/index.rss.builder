xml.instruct! :xml, :version => "1.0"
xml.rss :version => "2.0" do
  xml.channel do
    xml.title "#{Conf.site_name}-最新文章-#{@title || "全部"}"
    xml.description Conf.site_discription
    xml.link articles_url

    for article in @articles
      xml.item do
        xml.title h(article.title)
        xml.description h(article.short_content) + link_to("by #{article.author.try(:name)}", author_articles_path(article.author))
        xml.pubDate article.created_at.to_s(:db)
        xml.link article_url(article)
        xml.guid article_url(article)
      end
    end
  end
end

