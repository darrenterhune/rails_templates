if yes?("Do you want to use the base.rb template first?")
  load_template "/Users/darrenterhune/Code/rails_templates/base.rb"
end

puts "Fetching boilerplate..."
git "clone git://github.com/paulirish/html5-boilerplate.git"
run "mv html5-boilerplate/css/* public/stylesheets/"
run "mv html5-boilerplate/js/* public/javascripts/"
run "mv html5-boilerplate/crossdomain.xml public/"
run "mv html5-boilerplate/.htaccess public/"

puts "Generating default layout for boilerplate..."  
if yes?("Do you want to overwrite the application.html.erb file?")
  run "rm app/views/layouts/application.html.erb" if File.exists? "app/views/layouts/application.html.erb"
  run "cp html5-boilerplate/index.html app/views/layouts/application.html.erb"  
end

run 'ruby -pi -e "gsub(/js\//, \"javascripts/\")" app/views/layouts/application.html.erb'
run 'ruby -pi -e "gsub(/css\//, \"stylesheets/\")" app/views/layouts/application.html.erb'

puts "House cleaning..."
run "rm -rf html5-boilerplate"

puts "You will want to add icons for ipad, iphone, itouch and browsers:"
puts "114x114 - public/apple-touch-icon.png"

puts "Boiler plate template applied!"