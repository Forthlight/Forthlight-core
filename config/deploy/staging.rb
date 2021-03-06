# Simple Role Syntax
# ==================
# Supports bulk-adding hosts to roles, the primary
# server in each group is considered to be the first
# unless any hosts have the primary property set.
# Don't declare `role :all`, it's a meta role
role :app, %w{jodg11@stagelight.johandamm.com}
role :web, %w{jodg11@stagelight.johandamm.com}
role :db,  %w{jodg11@stagelight.johandamm.com}

set :rails_env, "staging"

# Extended Server Syntax
# ======================
# This can be used to drop a more detailed server
# definition into the server list. The second argument
# something that quacks like a hash can be used to set
# extended properties on the server.
server 'stagelight.johandamm.com', user: 'jodg11', roles: %w{web app}, my_property: :my_value
set :branch, "dev"
set :deploy_to, '~/www/stagelight/forthlight'
# you can set custom ssh options
# it's possible to pass any option but you need to keep in mind that net/ssh understand limited list of options
# you can see them in [net/ssh documentation](http://net-ssh.github.io/net-ssh/classes/Net/SSH.html#method-c-start)
# set it globally
#  set :ssh_options, {
#    keys: %w(/home/rlisowski/.ssh/id_rsa),
#    forward_agent: false,
#    auth_methods: %w(password)
#  }
# and/or per server
# server 'example.com',
#   user: 'user_name',
#   roles: %w{web app},
#   ssh_options: {
#     user: 'user_name', # overrides user setting above
#     keys: %w(/home/user_name/.ssh/id_rsa),
#     forward_agent: false,
#     auth_methods: %w(publickey password)
#     # password: 'please use keys'
#   }
# setting per server overrides global ssh_options


namespace :deploy do

  desc "Restart application"
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      execute("pkill -f puma && cd /home/jodg11/www/stagelight/forthlight/current && bundle exec puma -e staging -d -b unix:///tmp/stagelight.sock")

      puts "Server should now have restarted"
    end
  end

  after :finishing, "deploy:cleanup"
  after :finishing, "deploy:restart"

end
