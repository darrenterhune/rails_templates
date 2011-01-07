if yes?("Do you want to use the base.rb template first?")
  load_template "/Users/darrenterhune/Code/rails_templates/base.rb"
end

puts "Fetching cssgrid..."
git "clone git://github.com/darrenterhune/cssgrid.git"
run "mv cssgrid/css/* public/stylesheets"

if yes?("Do you want to replace application.html.erb with cssgrid's basic layout?")
  run "rm app/views/layouts/application.html.erb" if File.exists? "app/views/layouts/application.html.erb"
  run "cp cssgrid/index.html app/views/layouts/application.html.erb"  
end

puts "House cleaning..."
run "rm -rf cssgrid"

puts "You will want to add icons for ipad, iphone, itouch and browsers:"
puts "57x57 - public/apple-touch-icon-iphone.png"
puts "72x72 - public/apple-touch-icon-ipad.png"
puts "114x114 - public/apple-touch-icon-iphone4.png"

puts "CSSGrid template applied!"