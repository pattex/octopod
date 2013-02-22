require 'erb'
require 'uri'
require 'digest/sha1'

module Jekyll
  module OctopodFilters

    # Escapes CDATA sections in post content
    def cdata_escape(input)
      input.gsub(/<!\[CDATA\[/, '&lt;![CDATA[').gsub(/\]\]>/, ']]&gt;')
    end

    # Escapes single quotes in a given string
    #
    #   js_str_escape("Uncle Octopod's podcast") => "Uncle Octopod\'s podcast"
    def js_str_escape(str)
      str.gsub("'", "\\\\'") if str.is_a?(String)
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
    #   {{ site.time | time_to_rssschema }}
    def time_to_rssschema(time)
      time.strftime("%a, %d %b %Y %H:%M:%S %z")
    end

    # Returns the first argument if it's not nil or empty otherwise it returns
    # the second one.
    #
    #   {{ post.author | otherwise:site.author }}
    def otherwise(first, second)
      first = first.to_s
      first.empty? ? second : first
    end

    # Returns the value of a given hash. Is no key as second parameter given, it
    # try first "mp3", than "m4a" and than it will return a more or less random
    # value.
    #
    #   {{ post.audio | audio:"m4a" }} => "my-episode.m4a"
    def audio(hsh, key = nil)
      if key.nil?
        hsh['mp3'] ? hsh['mp3'] : hsh['m4a'] ? hsh['m4a'] : hsh.values.first
      else
        hsh[key]
      end
    end

    # Returns the MIME-Type of a given file format.
    #
    #   {{ "m4a" | mime_type }} => "audio/mp4a-latm"
    def mime_type(format)
      types = {
        'mp3'  => 'mpeg',
        'm4a'  => 'mp4a-latm',
        'ogg'  => 'ogg',
        'opus' => 'opus'
      }

      "audio/#{types[format]}"
    end

    # Returns the size of a given file in bytes. If there is just a filename
    # without a path, this method assumes that the file is an episode audio file
    # which lives in /episodes.
    def file_size(path, rel = nil)
      path = path =~ /\// ? path : File.join('episodes', path)
      path = rel + path if rel
      File.size(path)
    end

    # Returns a slug based on the id of a given page.
    #
    #   {{ page | slug }} => '2012_10_02_octopod'
    def slug(page)
      page['id'][1..-1].gsub('/', '_')
    end

    # Returns an <audio>-tag for a given page with <source>-tags in it for every
    # audio file in the page's YAML front matter.
    #
    # {{ page | audio_tag }}
    def audio_tag(page)
      out = %Q{<audio id="#{slug(page)}_player">\n}
      out + page['audio'].map { |format, filename|
        %Q{<source src="/episodes/#{ERB::Util.url_encode(filename)}" type="audio/#{format == 'm4a' ? 'mp4' : format}"></source>}
      }.join("\n") + "\n</audio>\n"
    end

    # Returns the web player for the episode of a given page.
    #
    # {{ page | web_player:site }}
    def web_player(page, site = nil)
      return if page['audio'].nil?

      options = {
        'poster'              => '/img/logo-360x360.png',
        'alwaysShowHours'     => 'true',
        'startVolume'         => '0.8',
        'width'               => 'auto',
        'summaryVisible'      => 'false',
        'timecontrolsVisible' => 'false',
        'chaptersVisible'     => 'true'
      }

      simple_keys = %w[title alwaysShowHours startVolume width summaryVisible
                         timecontrolsVisible chaptersVisible]

      if site = site.dup
        site.delete('title')
        site.delete('subtitle')
        options = options.merge(site)
      end
      options = options.merge(page)

      out = audio_tag(page)
      out << "<script>\n$('##{slug(page)}_player').podlovewebplayer({\n"
      out << "poster: '#{js_str_escape(options['episode_cover']) || '/img/logo-360x360.png'}',\n"
      out << "subtitle: '#{js_str_escape(options['subtitle'])}',\n" if options['subtitle']
      out << "chapters: '#{options['chapters'].map { |c| js_str_escape(c) }.join(%Q{'+"\\n"+'})}',\n" if options['chapters']
      out << "summary: '#{js_str_escape(options['summary'])}',\n" if options['summary']
      out << "duration: '#{string_of_duration(options['duration'])}',\n"

      out << simple_keys.map { |k|
        "#{k}: #{options[k] =~ /\A(true|false|[0-9\.]+)\z/ ? js_str_escape(options[k]) : "'#{js_str_escape(options[k])}'"}"
      }.join(",\n") + "});\n</script>\n"
    end

    # Gets a number of seconds and returns an human readable duration string of
    # it.
    #
    #   {{ 1252251 | string_of_duration }} => "00:03:13"
    def string_of_duration(duration)
      seconds = duration.to_i
      minutes = seconds / 60
      hours   = minutes / 60

      "#{"%02d" % hours}:#{"%02d" % (minutes % 60)}:#{"%02d" % (seconds % 60)}"
    end

    # Gets a number of bytes and returns an human readable string of it.
    #
    #   {{ 1252251 | string_of_size }} => "1.19M"
    def string_of_size(bytes)
      bytes = bytes.to_i.to_f
      out = '0'
      return out if bytes == 0.0

      jedec = %w[b K M G]
      [3, 2, 1, 0].each { |i|
        if bytes > 1024 ** i
          out = "%.1f#{jedec[i]}" % (bytes / 1024 ** i)
          break
        end
      }

      return out
    end

    # Returns the host a given url
    #
    #   {{ 'https://github.com/pattex/octopod' | host_from_url }} => "github.com"
    def host_from_url(url)
      URI.parse(url).host
    end

    # Generates the config for disqus integration
    # If a page object is given, it generates the config variables only for this
    # page. Otherwise it generate only the global config variables.
    def disqus_config(site, page = nil)
      if page
        disqus_vars = {
          'disqus_identifier'  => page['url'],
          'disqus_url'         => site['url'] + page['url'],
          'disqus_category_id' => page['disqus_category_id'] || site['disqus_category_id'],
          'disqus_title'       => page['title'] || site['site']
        }
      else
        disqus_vars = {
          'disqus_developer'   => site['disqus_developer'],
          'disqus_shortname'   => site['disqus_shortname']
        }
      end

      disqus_vars.delete_if { |_, v| v.nil? }
      disqus_vars.map { |k, v| "var #{k} = '#{v}';" }.compact.join("\n")
    end

    # Returns the hex-encoded hash value of a given string. The optional
    # second argument defines the length of the returned string.
    #
    #   {{ "Octopod" | sha1:8 }} => "8b20a59c"
    def sha1(str, lenght = nil)
      sha1 = Digest::SHA1.hexdigest(str)

      lenght.nil? ? sha1 : sha1[0, lenght.to_i]
    end

    # Returns a, ready to use, navigation list of all pages that have
    # <tt>navigation</tt> set in their YAML front matter. The list is sorted by
    # the value of <tt>navigation</tt>.
    #
    #   {{ site | navigation_list:page }}
    def navigation_list(site, page)
      pages = site['pages'].select { |p|
        p.data['navigation'] && p.data['title']
      }.sort_by { |p| p.data['navigation'] }

      list =  ['<ul class="nav">']
      list << pages.map { |p|
        active = (p.url == page['url']) || (page.has_key?('next') && File.join(p.dir, p.basename) == '/index')
        navigation_list_item(p.url, p.data['title'], active)
      }
      list << ['</ul>']

      list.join("\n")
    end

    def navigation_list_item(url, title, active = false)
      a_class = active ? ' class="active"' : ''
      %Q{<li#{a_class}><a #{a_class} href="#{url}">#{title}</a></li>}
    end

    # Returns an array of all episode feeds named by the convetion
    # 'episodes.<episode_file_format>.rss' within the root directory. Also it
    # contains all additional feeds specified by 'additional_feeds' in the
    # '_config.yml'. If an 'episode_file_format' or key of 'additional_feeds'
    # equals the optional parameter 'except', it will be skipped.
    #
    #   episode_feeds(site, except = nil) =>
    #   [
    #     ["m4a Episode RSS-Feed", "/episodes.m4a.rss"],
    #     ["mp3 Episode RSS-Feed", "/episodes.mp3.rss"],
    #     ["Torrent Feed m4a", "http://bitlove.org/octopod/octopod_m4a/feed"],
    #     ["Torrent Feed mp3", "http://bitlove.org/octopod/octopod_mp3/feed"]
    #   ]
    def episode_feeds(site, except = nil)
      feeds = []

      if site['episode_feed_formats']
        site['episode_feed_formats'].map { |f|
         feeds << ["#{f} Episode RSS-Feed", "/episodes.#{f}.rss"] unless f == except
        }
      end

      if site['additional_feeds']
        site['additional_feeds'].each { |k, v|
          feeds << [k.gsub('_', ' '), v] unless k == except
        }
      end

      feeds
    end

    # Returns HTML links to all episode feeds named by the convetion
    # 'episodes.<episode_file_format>.rss' within the root directory. Also it
    # returns all additional feeds specified by 'additional_feeds' in the
    # '_config.yml'. If an 'episode_file_format' or key of 'additional_feeds'
    # equals the optional parameter 'except', it will be skipped.
    #
    #   {{ site | episode_feeds_html:'m4a' }} =>
    #   <link rel="alternate" type="application/rss+xml" title="mp3 Episode RSS-Feed" href="/episodes.mp3.rss" />
    #   <link rel="alternate" type="application/rss+xml" title="Torrent Feed m4a" href="http://bitlove.org/octopod/octopod_m4a/feed" />
    #   <link rel="alternate" type="application/rss+xml" title="Torrent Feed mp3" href="http://bitlove.org/octopod/octopod_mp3/feed" />
    def episode_feeds_html(site, except = nil)
      episode_feeds(site, except).map { |f|
        %Q{<link rel="alternate" type="application/rss+xml" title="#{f.first || f.last}" href="#{f.last}" />}
      }.join("\n")
    end

    # Returns RSS-XML links to all episode feeds named by the convetion
    # 'episodes.<episode_file_format>.rss' within the root directory. Also it
    # returns all additional feeds specified by 'additional_feeds' in the
    # '_config.yml'. If an 'episode_file_format' or key of 'additional_feeds'
    # equals the optional parameter 'except', it will be skipped.
    #
    #   {{ site | episode_feeds_rss:'m4a' }} =>
    #   <atom:link rel="alternate" href="/episodes.mp3.rss" type="application/rss+xml" title="mp3 Episode RSS-Feed"/>
    #   <atom:link rel="alternate" href="http://bitlove.org/octopod/octopod_m4a/feed" type="application/rss+xml" title="Torrent Feed m4a"/>
    #   <atom:link rel="alternate" href="http://bitlove.org/octopod/octopod_mp3/feed" type="application/rss+xml" title="Torrent Feed mp3"/>
    def episode_feeds_rss(site, except = nil)
      episode_feeds(site, except).map { |f|
        %Q{<atom:link rel="alternate" href="#{f.last}" type="application/rss+xml" title="#{f.first || f.last}"/>}
      }.join("\n")
    end

  end
end

Liquid::Template.register_filter(Jekyll::OctopodFilters)
