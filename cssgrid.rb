load_template "http://github.com/darrenterhune/rails_templates/raw/master/base.rb"

if yes?("How bout that awesome 1140 grid layout?")
  puts "Fetching css grid version 1.6..."
  run "wget http://download.cssgrid.net/1140_CssGrid_1.6.zip"
  puts "Un packing the files..."
  run "unzip 1140_CssGrid_1.6.zip"
  run "mv css/* "
  puts "House cleaning..."
  
  puts "Generating default layout for cssgrid..."
  file "app/views/layouts/application.html.erb", <<-END
  <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
  <html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
  <head>
  	<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
  	<meta name="description" content="<%= @description || "" %>"/>
  	<meta name="keywords" content="<%= @keywords || "" %>"/>
  	<title><%= @page_title || "" %></title>
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
  END
  
end

puts "Finished! Enjoy..."