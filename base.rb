puts "Setting up your app..."

run "mv README README.rdoc"
run "echo h1. Welcome > README.rdoc"
run "rm -rf public/index.html"
run "touch config/config.yml"
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

if yes?("Do you want to setup general deploy configs? (Dreamhost only)")
  
  file "config/deploy.rb", <<-END
  set :user, '_your-user_'
  set :domain, '_your-server_.dreamhost.com'
  set :project, '_your-project_'
  set :application, '_your-application_'
  set :deploy_to, "/home/#{user}/#{application}"
  set :deploy_via, :copy
  set :use_sudo, false
  set :repository, "."
  set :scm, :none

  role :web, domain
  role :app, domain
  role :db,  domain, :primary => true
  ssh_options[:keys] = %w(/Users/darrenterhune/.ssh/id_rsa)

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
  END
  
end

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
config/initializers/cookie_verification_secret.rb
db/*.sqlite3
CODE

git :add => ".", :commit => "-m 'initial commit'"

if yes?("Do you want restful-authentication?")
  
  plugin "restul-authentication", :git => "git://github.com/technoweenie/restful-authentication.git"
  generate :authenticated, "admin sessions --rspec"
  
  rake "db:migrate"
  
  git :add => ".", :commit => "-m 'added authentication'"
end