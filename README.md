# Octopod - podcast delivery for geeks

Octopod is a set of [Jekyll](http://jekyllrb.com/) templates, helpers and extensions to deliver your podcasts the cool text file lover's way.

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

*You can find a documentation of all the not Octopod specific settings on the [Configuration page of the Jekyll Wiki](https://github.com/mojombo/jekyll/wiki/Configuration).*

## Usage

## Credits

Some of this code is not written by me.  
I shamelessly took some lines from other projects. And of cause Octopod is based on a list of frameworks, tools and plugins.

Gratitude be to:
* [Jekyll](http://jekyllrb.com/)
* [Twitter Bootstrap](http://twitter.github.com/bootstrap/)
* [Podlove Web Player](http://podlove.org/podlove-web-player/)
* [Octopress](http://octopress.org/)
* And the ones I've forgotten

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
Permissions beyond the scope of this license may be available at
[https://kleinerdrei.net/](https://kleinerdrei.net/).
