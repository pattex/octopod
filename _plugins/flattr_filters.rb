require 'erb'

module Jekyll
  module FlattrFilters

    # Generates the query string part for the flattr load.js from the
    # configurations in _config.yml
    #
    # {{ site | flattr_loader_options }}
    def flattr_loader_options(site)
      return if site['flattr_username'].nil?

      params = {
        'mode'     => site['flattr_mode'],
        'https'    => 1,
        'popout'   => site['flattr_popout'],
        'uid'      => site['flattr_username'],
        'button'   => site['flattr_button'],
        'language' => site['flattr_lang'],
        'category' => site['flattr_category']
      }
      params.delete_if { |_, v| v.to_s.empty? }

      params.map { |k, v| "#{k}=#{ERB::Util.url_encode(v)}" }.join('&')
    end

    # Returns a flattr button
    #
    # {{ site | flattr_button:page }}
    def flattr_button(site, page = nil)
      return if site['flattr_username'].nil?
      page = {} if page.nil?

      url         = site['url'] + page['url'].to_s
      title       = page['title']   || site['title']
      description = page['content'] || site['description'] || site['title']

      params = {
        'uid'      => page['flattr_username'] || site['flattr_username'],
        'popout'   => page['flattr_popout']   || site['flattr_popout']   || '0',
        'button'   => page['flattr_button']   || site['flattr_button']   || '',
        'category' => page['flattr_category'] || site['flattr_category'] || 'audio',
        'language' => page['flattr_lang']     || site['flattr_lang']     || 'en_GB'
      }
      params['tags'] = page['tags'].join(', ') if page['tags']

      button =  '<div class="button-wrapper"><a class="FlattrButton" style="display:none;" '
      button << %Q{title="#{title}" href="#{url}" }
      button << params.map { |k, v| %Q{data-flattr-#{k}="#{v}"} }.join(' ')
      button << ">\n\n#{description.gsub(/<\/?[^>]*>/, "")}\n</a></div>"
    end

  end
end

Liquid::Template.register_filter(Jekyll::FlattrFilters)
