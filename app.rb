require 'sinatra'
require 'json'
# require 'byebug'
# require 'pry-byebug'

require_relative 'helpers/application_helper'
require_relative 'helpers/slack_helper'
require_relative 'helpers/circle_helper'

helpers ApplicationHelper
helpers SlackHelper
helpers CircleHelper

set :bind, '0.0.0.0'

get '/' do
  'PONG'
end

before '/' do
  if request.env['REQUEST_METHOD'] == "POST"
    secrets = load_secrets
    @users = secrets['users']
    @slack_token = secrets['slack_token']
    if @users.nil? || @users.empty? || @slack_token.nil? || @slack_token.empty?
      log 'There is a problem with your secrets file.', nil
      halt 400
    end
  end
end

post '/' do
  response = JSON.parse request.body.read
  payload = response['payload']

  build_num = payload['build_num']
  vcs_login = payload['user']['login']
  slack_username = @users[vcs_login]

  if slack_username.nil?
    log "User #{vcs_login} has no associated Slack username.", build_num
    halt 400
  end

  circle_details = build_circle_details payload
  slack_message = build_slack_message circle_details, slack_username
  slack_response = send_slack_message slack_message

  if slack_response['ok']
    status 200
  else
    log "Message sending failed with error: #{slack_response['error']}", build_num
    halt 400
  end
end
