module Jekyll
  module OctopodFilters

    # Escapes CDATA sections in post content
    def cdata_escape(input)
      input.gsub(/<!\[CDATA\[/, '&lt;![CDATA[').gsub(/\]\]>/, ']]&gt;')
    end

    # Replaces relative urls with full urls
    def expand_urls(input, url='')
      url ||= '/'
      input.gsub /(\s+(href|src)\s*=\s*["|']{1})(\/[^\"'>]*)/ do
        $1+url+$3
      end
    end

    # Formats a Time to be RSS compatible like "Wed, 15 Jun 2005 19:00:00 GMT"
    #
    # {{ site.time | time_to_rssschema }}
    def time_to_rssschema(time)
      time.strftime("%a, %d %b %Y %H:%M:%S %z")
    end

    # Returns the first argument if it's not nil or empty otherwise it returns
    # the second one.
    #
    # {{ post.author | otherwise:site.author }}
    def otherwise(first, second)
      first.nil? || first.empty? ? second : first
    end

    def audio(filename, preload = nil)
      preload ||= 'auto'
      %Q{<audio src="/files/episodes/#{ERB::Util.url_encode(filename)}" preload="#{preload}" />}
    end

  end
end

Liquid::Template.register_filter(Jekyll::OctopodFilters)
