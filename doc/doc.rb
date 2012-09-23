require "fileutils"

$html_pre = '<html>
<head>
<link
href="https://a248.e.akamai.net/assets.github.com/assets/github-8a13a03ffae59e2edbf9c984f0b5dfd683540538.css"
media="screen" rel="stylesheet" type="text/css" />
<link
href="https://a248.e.akamai.net/assets.github.com/assets/github2-930e3b288a944b966459c5167a677e106ffc2588.css"
media="screen" rel="stylesheet" type="text/css" />
</head>
<body>
<div id="wrapper">
<div class="site hfeed" itemscope itemtype="http://schema.org/WebPage">
<div class="container hentry">
<div id="js-repo-pjax-container">
<div id="slider">
<div class="frames">
<div class="frame frame-center">
<div class="announce instapaper_body mdown" data-path="/" id="readme">
  <span class="name">
    <span class="mini-icon mini-icon-readme"></span>
    Preview
  </span>
  <article class="markdown-body entry-content" itemprop="mainContentOfPage">'

$html_post='</article></div></div></div></div></div></div></div></div></body></html>'

puts "Monitor changes in markdown files (.md extension). When changes are
detected, the markdown files are (re)compiled to html. Deleting a markdown file
causes the associated html file to be also deleted."

def rmext(fname)
  fname.chomp(File.extname(fname))
end

def rebuild(md_file)
    html_file = "#{rmext md_file}.html"
    if File.exists?(md_file)
      p "rebuild #{md_file}"
      File.open(html_file, "w") {|f| f.write($html_pre) }
      system "github-markup #{md_file} >> #{html_file}"
      File.open(html_file, "a") {|f| f.write($html_post) }
    else
      p "delete #{md_file}"
      FileUtils.rm(html_file)
    end
end

# watchr wrapper
require "watchr"
def watchr(glob, dir=".", &action)
  Dir.chdir(dir) do
    script = Watchr::Script.new
    script.watch(glob, &action)
    Watchr::Controller.new(script, Watchr.handler.new).run
  end
end

watchr(/.*\.md$/) do |m| rebuild(m[0]) end
