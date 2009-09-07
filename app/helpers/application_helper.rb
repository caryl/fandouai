# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  require 'uri'
  include TagsHelper
  include WillPaginate::ViewHelpers

  def outer_link?(url)
    return nil if url.nil?
    url_host = URI.parse(url.strip).host
    return false if url_host.blank?
    url_host != request.host
  end

  def auto_link_to(title, url, options={})
    link_to title, url, outer_link?(url) ? {:target=>'_blank'}.merge(options) : options
  end

  def will_paginate_with_i18n(collection, options = {})
    will_paginate_without_i18n(collection, options.merge(:previous_label => I18n.t(:previous), :next_label => I18n.t(:next)))
  end

  alias_method_chain :will_paginate, :i18n
end
