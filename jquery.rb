if File.exists?("public/javascripts/prototype.js")
  if yes?("Do you want to remove prototype and dependencies?")
    puts "Removing prototype from your library..."
    run "rm public/javascripts/prototype.js"
    run "rm public/javascripts/effects.js"
    run "rm public/javascripts/dragdrop.js"
    run "rm public/javascripts/controls.js"
  end
end

puts "Fetching and installing jQuery and jQueryUi"
file 'public/javascripts/jquery.min.js', open('http://ajax.googleapis.com/ajax/libs/jquery/1.4.4/jquery.min.js').read
file 'public/javascripts/jquery-ui.min.js', open('http://ajax.googleapis.com/ajax/libs/jqueryui/1.8.6/jquery-ui.min.js').read

if yes?("Do you want to automagically commit changes to git?")
  git :add => "."
  git :commit => "-a -m 'Added jQuery with UI plugin and removed prototype'"
end