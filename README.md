fixmystreet.org
===============

The gh-pages branch is [fixmystreet.org](http://fixmystreet.org), the
Jekyll-based static site running on GitHub Pages that is the documentation for
setting up / running the FixMyStreet platform.

## Installation

The site is built by Jekyll. We manage our Ruby gem dependencies via
[bundler](http://bundler.io/) so you’ll need to install that if you don’t
already have it. Then you need to…

```
git clone --recursive -b gh-pages https://github.com/mysociety/fixmystreet fixmystreet-pages
cd fixmystreet-pages
bundle install
```

To preview the site locally, run:

```
bundle exec jekyll serve
```

Jekyll automatically compiles the HTML/Markdown and Sass files as you go.
