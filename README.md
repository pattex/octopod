# Octopod - podcast delivery for geeks
Version 0.2.1  
<a href="http://flattr.com/thing/1154435/pattex-on-GitHub" target="_blank"><img src="http://api.flattr.com/button/flattr-badge-large.png" alt="Flattr this" title="Flattr this" border="0" /></a>

Octopod is a set of [Jekyll](http://jekyllrb.com/) templates, helpers and extensions to deliver your podcasts the cool text file lover's way.  
If you want to take a look: I made [this demo](http://pattex.github.com/octopod).

<img src="https://raw.github.com/pattex/octopod/master/img/logo-360x360.png" alt="Octopod logo">

If you are not afraid of the command line of your computer and text files are the stuff to heat up your geeky little heart, Octopod may be worth a trial to publish your podcasts.

The underlying assumptions of Octopod are that static content should be delivered statically and text files are the perfect way to handle podcast metadata. So Octopod makes it easy to generate and deploy a website and feeds for your podcast out of one textfile and at least one audio file per episode.

Octopod brings innately:
* iTunes ready episode feeds for different file formats
* a ready to use [Twitter Bootstrap](http://twitter.github.com/bootstrap/) based layout
* [Flattr](https://flattr.com/) support on the website and in the episode feed
* comments via [Disqus](http://disqus.com/)
* [Podlove Web Player](http://podlove.org/podlove-web-player/)
* [Podlove Alternate Feeds](http://podlove.org/alternate-feeds/)
* [Podlove Simple Chapters](http://podlove.org/simple-chapters/)

***Attention: This project is absolutely in a non 1.0 status. This means that there is no guarantee for not breaking this or that behavior with the next update. Hopefully you are brave enough to play with this cute little toy anyway. [Bug reports](https://github.com/pattex/octopod/issues) and even more push requests are highly welcome.***

## Requirements, installation and setup
Since Jekyll and Octopod are written in the [Ruby programming language](http://www.ruby-lang.org/) you need a running Ruby interpreter – which sadly is sometimes easier said than done – and the [bundler](http://gembundler.com/) gem installed.
And because Octopod lives in a git repository, you may also want to have the [git version control system](http://git-scm.com/) installed.

The first step to your new and shiny podcast publishing system is to get a copy of it. And to get one, the best way should be to clone the repo.
So open your Terminal and type the following command:

    git clone --recursive https://github.com/pattex/octopod.git

Now you have to install all the required software to run Octopod.

    cd octopod
    bundle install

To set up your Octopod, just rename the sample config file and edit it as you need.

    mv _config.yml.sample _config.yml
    <your favourite editor> _config.yml

*You can find a documentation of all the non Octopod specific settings on the [Configuration page of the Jekyll Wiki](https://github.com/mojombo/jekyll/wiki/Configuration).*

## Usage
First of all, your new podcast episode needs audio data. Octopod assumes that your ready to use audio files stay within the `episodes` directory in in your projects root.

    cp ~/my_superduper_audio_files/ocp001.m4a episodes

 In addition, Octopod assumes that the different audio files of each of your episode are the same content in various formats which are the same duration and everything.  
If they are not, you may confuse your listeners. At the least when you are using the chapters feature.

Next up your episode needs some metadata. A title, some kind of a description, maybe chapters and so on. Octopod keeps all these metadata in one single textfile (Protip: these dear little tots feel very lucky when they might live in a version control system! You already got one for free when you `git clone`d the Octopod repo).  
Octopod kindly helps you generating these file with the `octopod episode` command (You will find some more inforamtion on the `octopod` command line tool in [the Octopod wiki](https://github.com/pattex/octopod/wiki/The-octopod-command-line-tool)).

The following command

    octopod episode --title "Why I <3 Octopod"

will generate you a template called **YYYY-MM-DD-why-i-_3-octopod.md** (YYYY-MM-DD represents the current date) in your `_posts` subdirectory. When you open it in your text editor you'll see something like that:

    ---
    title: Why I <3 Octopod
    layout: post
    author: Uncle Octopod
    explicit: 'no'
    audio:
      m4a: name.m4a
      mp3: name.mp3
      opus: name.opus
    ---
    Insert eloquent and worth reading text here.

    {{ page | web_player:site }}

    ## Shownotes
    * Note

The part between the "---" and the "---" is [the YAML front matter](https://github.com/pattex/octopod/wiki/The-post-template). This is where all the metadata is stored. Below the YAML frontmatter is the area (body) where you can write down your posts content (like the show notes and stuff). This strange looking `{{ page | web_player:site }}` thingy is the [Liquid filter](https://github.com/pattex/octopod/wiki/Liquid-filters) which represents the web player later.

When all this work is done you are ready to take a first look.  
The following command generates your site and start a local webserver for a preview. You kann check your new pocasting website by opening [http://localhost:4000](http://localhost:4000).

    octopod --url "http://localhost:4000" --server

If everything is alright you can finally generate your "real" Site:

    octopod

And deploy it to your server:

    octopod deploy

*Attention*: The Rsync settings in your `_config.yml` are mandatory for this last step. But it is no problem to upload the generated website from the `_site` subdirectory via FTP or something.

## Contributing

At the moment Octopod is extremely made to fit my personal needs and preferences. But it's it is a high priority goal to become Octopod more generic. This and of course bug fixes would make the sweet little opctopd smile the most.

But feel free to fork and push request and code and everything.

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Credits
The beautiful Octopod Logo was designed and created by [Thekla "TeMeL" Löhr](http://www.temel-art.de/). Please support her with a little flattr.
<a href="https://flattr.com/thing/526869/TeMeL-on-Flattr" target="_blank"><img src="http://api.flattr.com/button/flattr-badge-large.png" alt="Flattr this" title="Flattr this" border="0" /></a>

Some of this code is not written by me.
I shamelessly took some lines from other projects. And of cause Octopod is based on a list of frameworks, tools and plugins.

Gratitude be to:
* [Jekyll](http://jekyllrb.com/)
* [Twitter Bootstrap](http://twitter.github.com/bootstrap/)
* [The whole Podlove project](http://podlove.org/)
* [Octopress](http://octopress.org/)

## License

### The MIT License

Copyright (c) 2012 Arne Eilermann <eilermann@lavabit.com>

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

### Artwork

Octopod Logo by [Thekla "TeMeL" Löhr](http://www.temel-art.de/) is licensed
under a [Creative Commons Attribution 3.0 Germany License](http://creativecommons.org/licenses/by/3.0/de/).
