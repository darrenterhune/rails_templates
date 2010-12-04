if yes?("Do you want to use the base.rb template first?")
  load_template "/Users/darrenterhune/Code/rails_templates/base.rb"
end

puts "Fetching css grid version 1.6..."
run "wget http://download.cssgrid.net/1140_CssGrid_1.6.zip"
puts "Un packing the files..."
run "unzip 1140_CssGrid_1.6.zip"
run "mv css/* public/stylesheets"
puts "House cleaning..."
run "rm -rf __MACOSX"
run "rm -rf 1140_CssGrid_1.6"
run "rm -rf css"
run "rm index.html"
run "rm 1140_CssGrid_1.6.zip"


if yes?("Do you want to overwrite the application.html.erb file?")
puts "Generating default layout for cssgrid..."
run "rm app/views/layouts/application.html.erb" if File.exists? "app/views/layouts/application.html.erb"
author = ask("What do you want the meta author tag to be?")
title = ask("What do you want the title to be?")
keywords = ask("What do you want the keywords to be?")
description = ask("What do you want the description to be?")  
file "app/views/layouts/application.html.erb", <<-CODE
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
  <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1"/>
  <meta name="author" content="#{author}"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <meta name="description" content="#{description}"/>
  <meta name="keywords" content="#{keywords}"/>
  <title>#{title}</title>
  <link rel="apple-touch-icon" href="apple-touch-icon-iphone.png" />
  <link rel="apple-touch-icon" sizes="72x72" href="apple-touch-icon-ipad.png" />
  <link rel="apple-touch-icon" sizes="114x114" href="apple-touch-icon-iphone4.png" />
  <link rel="stylesheet" href="/stylesheets/1140.css" type="text/css" media="screen"/>
  <!--[if lte IE 9]><link rel="stylesheet" href="/stylesheets/ie.css" type="text/css" media="screen"/><![endif]-->	
  <link rel="stylesheet" href="/stylesheets/typeimg.css" type="text/css" media="screen"/>
  <link rel="stylesheet" href="/stylesheets/smallerscreen.css" media="only screen and (max-width: 1023px)"/>
  <link rel="stylesheet" href="/stylesheets/mobile.css" media="handheld, only screen and (max-width: 767px)"/>
  <link rel="stylesheet" href="/stylesheets/layout.css" type="text/css" media="screen"/>
  <script language="javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.3.1/jquery.min.js" type="text/javascript"></script>
</head>
<body>
  <div class="container">
    <div class="row">
      <div class="threecol">
        <p>Column 1</p>
      </div>
      <div class="threecol">
        <p>Column 2</p>
      </div>
      <div class="threecol">
        <p>Column 3</p>
      </div>
      <div class="threecol last">
        <p>Column 4</p>
      </div>
    </div>
  </div>
</body>
</html>
CODE
end

puts "You will want to add icons for ipad, iphone, itouch and browsers:"
puts "57x57 - public/apple-touch-icon-iphone.png"
puts "72x72 - public/apple-touch-icon-ipad.png"
puts "114x114 - public/apple-touch-icon-iphone4.png"

puts "CSSGrid template applied..."