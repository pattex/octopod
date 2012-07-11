require 'erb'
require 'uri'
require 'digest/sha1'

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
        'mp3' => 'audio/mpeg',
        'm4a' => 'audio/mp4a-latm',
        'ogg' => 'application/ogg'
      }

      types[format]
    end

    def file_size(path, rel = nil)
      path = path =~ /\// ? path : File.join('episodes', path)
      path = rel + path if rel
      File.size(path)
    end

    # Returns an <audio> tag for the given file. As a second argument it takes
    # one of the three possible preload behaviors auto/metadata/none.
    #
    #   {{ 'audiofile.m4a' | audio_tag }}
    def audio_tag(filename, preload = nil)
      return if filename.nil?
      preload ||= 'none'
      %Q{<audio src="/episodes/#{ERB::Util.url_encode(filename)}" preload="#{preload}" />}
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

  end
end

Liquid::Template.register_filter(Jekyll::OctopodFilters)
