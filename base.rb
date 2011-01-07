puts "Setting up your app..."

run "mv README README.rdoc"
file "README.rdoc", <<-CODE
== Setup

Make sure mysql is running... and you've configured <tt>config/database.yml</tt>

 $ sudo rake gems:install
 $ rake db:create
 $ rake db:migrate
 
 $ cd /path/to/app
 $ script/server

== Requirements

 1. Ruby 1.8.6+
 2. Rails 2.3+
 3. Mysql
 4. Some development know how
 5. Debugging skill if anything goes wrong

== Deploying

We're using capistrano deployment functionality of the excellent
<tt>capistrano</tt> gem to allow you to deploy to your production server. 
If you don't already have this gem installed, please do so by running:

 $ sudo gem install capistrano

To deploy the applications... yes you don't need sftp or ftp clients for this, do:

 $ cap deploy
 
On every deployment, <tt>cap deploy</tt> it will upload all modified files
to the production server, remove cache and then restart passenger. That's it? 
Huh? Ya that's the Ruby way. To restart Passenger aka your app:

 $ cap deploy:restart
 
To empty cache... if there's any cached files:

 $ cap deploy:remove_cache

== Generating Models/Controllers/Mailers

To generate new code you'll want to do something like:

 $ rake rspec_controller name_of_controller
 $ rake rspec_model name_of_model

== Backups

There is a bash/shell script that runs to backup the database once a week.
Example cron would be:

 * 0 2 * * 1 /home/deezbg/backups/mysql.sh

== Testing

No tests have been written, however all files and spec framework are there.
To write test open up spec/ files and write them.

== Other

There is more readme and file in doc/ if you put any files in there and are
using git or any other version control make sure you don't add that dir or
at least doc/README_FOR_APP as it contains some gooders.

CODE
run "rm -rf public/index.html"
run "touch config/config.yml"

puts "Removing prototype... we like jQuery better"
run "rm -rf public/javascripts/*.js"
file "public/javascripts/app.js", <<-CODE
//Add your applications js here
CODE

file "app/views/layouts/application.html.erb", <<-CODE
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
	<meta name="description" content=""/>
	<meta name="keywords" content=""/>
	<title></title>
</head>
<body>
  <div class="container">
  </div>
</body>
</html>
CODE
initializer "load_config.rb", <<-CODE
AppConfig = YAML.load_file(File.join(RAILS_ROOT, 'config', 'config.yml'))
CODE

puts "There's an example_config.yml file for your apps general configurations... rename it to config.yml"

if yes?("Do you want to use the rspec and factory_girl testing frameworks?")
  
  puts "Installing (rspec, rspec-rails -v 1.2.9) and factory_girl"
  
  gem "rspec", :lib => false, :version => "1.2.9"
  gem "rspec-rails", :lib => false, :version => "1.2.9"
  gem "thoughtbot-factory_girl", :lib => "factory_girl", :source => "http://gems.github.com"

  rake "gems:install", :sudo => true
  
  file "config/environments/test.rb", <<-CODE
  config.gem "rspec", :lib => false, :version => "1.2.9"
  config.gem "rspec-rails", :lib => false, :version => "1.2.9"
  config.gem "thoughtbot-factory_girl", :lib => "factory_girl"
  CODE
  
  if yes?("Remove regular test suite dirs?")
    puts "Removing regular test suite..."
    run "rm -rf test"
  end
  
  if yes?("Do you want a rspec_pages controller?")
    name = ask("What do you want the root file to be called?")
    generate "rspec_controller pages #{name}"
    route "map.root :controller => 'pages', :action => '#{name}'"
  end
  
end


if yes?("Do you want to name the database?")
db = ask("What do you want the database to be called?")
file "config/database.yml", <<-CODE
development: 
  adapter: mysql 
  database: #{db}_dev
  timeout: 5000 
  
test: 
  adapter: mysql 
  database: #{db}_test 
  timeout: 5000 
  
production: 
  adapter: mysql 
  database: #{db}_pro 
  timeout: 5000
CODE
end

puts "Capification...."

run "capify ."

if yes?("Do you want to setup general deploy configs?")
  
user = ask("What is the user this app will be deployed to?")
servername = ask("What is the name of the server? eg: bluebird.dreamhost.com")
project = @root.split('/').last
app = ask("What's the url for this domain?")
localuser = ask("What's the name of the localuser on your computer? This will be used to locate your .ssh key for deployment.")

file "config/deploy.rb", <<-CODE
set :user, "#{user}"
set :domain, "#{servername}"
set :project, "#{project}"
set :application, "#{app}"
set :deploy_to, "/home/#{user}/#{app}"
set :deploy_via, :copy
set :use_sudo, false
set :repository, "."
set :scm, :none

role :web, domain
role :app, domain
role :db,  domain, :primary => true
ssh_options[:keys] = %w(/Users/#{localuser}/.ssh/id_rsa)

namespace :deploy do

  desc "Tell Passenger to restart."
  task :restart, :roles => :web do
    run "cd #{deploy_to}/current && RAILS_ENV=production rake db:migrate"
    run "touch #{deploy_to}/current/tmp/restart.txt" 
  end

  desc "Do nothing on startup so we don't get a script/spin error."
  task :start do
    puts "You may need to restart Apache."
  end

  desc "Remove all cached files from server"
  task :remove_cache, :roles => :web do
    run "rm -rf #{deploy_to}/current/public/sitemap.xml"
    run "rm -rf #{deploy_to}/current/public/index.html"
    puts "cache removed!"
  end

end

after "deploy", "deploy:cleanup"
after "deploy", "deploy:remove_cache"
CODE
  
end

puts "Giting init..."

git :init

run "touch .gitignore"
run "cp config/database.yml config/example_database.yml"
run "cp config/config.yml config/example_config.yml"

file ".gitignore", <<-CODE
log/*.log
tmp/**/*
config/database.yml
config/config.yml
config/initializers/session_store.rb
config/initializers/site_keys.rb
config/initializers/cookie_verification_secret.rb
db/*.sqlite3
CODE

puts "Committed initial commit..."

git :add => ".", :commit => "-m 'initial commit'"

if yes?("Do you want restful-authentication?")
  
  plugin "restul-authentication", :git => "git://github.com/technoweenie/restful-authentication.git"
  
  if yes?("Are you running Rails 2.3.8+? Cause if ya are we'll move rake tasks to their proper position.")
    puts "Moving restful-authentication tasks to lib..."
    run "mv vendor/plugins/restful-authentication/tasks/auth.rake* lib/tasks/auth.rake"
    run "rm -rf vendor/plugins/restful-authentication/tasks"
  end
  
  generate :authenticated, "admin sessions --rspec"
  
  if yes?("Do you wanna create the database and run the migrations?")
    rake "db:create"
    rake "db:migrate"
  end
  
  git :add => ".", :commit => "-m 'added authentication'"
end

puts "Base template has been applied..."