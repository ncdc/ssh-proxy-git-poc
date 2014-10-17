require 'sinatra'
require 'securerandom'

tokens = {}
single_use_keys={}

get '/tokens' do
  out = []
  for token, user in tokens
    out << "user #{user} token #{token}<br>"
  end
  out.join
end

get '/proxy-auth-keys/:user' do |user|
  key = File.read("keys/#{user}.pub")
  token = loop do
    t = SecureRandom.urlsafe_base64(nil, false)
    break t unless tokens.include?(t)
  end
  tokens[token] = user
  r =<<EOF
environment="AUTH_SERVER=#{ENV['AUTH_SERVER']}",environment="TOKEN=#{token}",no-port-forwarding,no-X11-forwarding,no-agent-forwarding,no-pty #{key}
EOF
  r.chomp
end

post '/single-use-keys' do
  token = params[:token]
  token_user = params[:token_user]
  user = params[:user]
  return 401 unless tokens.include?(token) and tokens[token] == token_user
  tokens.delete(token)
  new_key = params[:key]
  single_use_keys[user] ||= []
  single_use_keys[user] << new_key
  201
end

get '/backend-info/:repo' do |repo|
  if repo == 'repo1'
    "-p #{ENV['GIT_PORT']} #{ENV['GIT_SERVER']}"
  end
end

get '/backend-auth-keys' do
  out = []
  for user, keys in single_use_keys
    out << "#{user}<br>"
    for key in keys
      out << "#{key}<br>"
    end
    out << "<p>"
  end
  out.join
end

get '/backend-auth-keys/:user' do |user|
  lines = []
  for key in single_use_keys[user]
    lines << "no-port-forwarding,no-X11-forwarding,no-agent-forwarding,no-pty #{key}"
  end
  keys = lines.join("\n")
  [200, {'Content-Type' => 'text/plain'}, keys]
end
