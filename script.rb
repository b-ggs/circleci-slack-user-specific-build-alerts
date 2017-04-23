require 'sinatra'
require 'json'
require 'yaml'
require 'httparty'
require 'byebug'
require 'pry-byebug'

SLACK_API_POST_MESSAGE_URL = 'https://slack.com/api/chat.postMessage'

get '/' do
  "PONG"
end

before '/' do
  if request.env['REQUEST_METHOD'] == "POST"
    secrets = load_secrets
    @users = secrets['users']
    @slack_token = secrets['slack_token']
    halt 400 if @users.nil? || @users.empty? || @slack_token.nil? || @slack_token.empty?
  end
end

post '/' do
  response = JSON.parse request.body.read
  payload = response['payload']

  vcs_login = payload['all_commit_details'][0]['author_login']
  slack_username = @users[vcs_login]

  if slack_username.nil?
    log "User #{vcs_login} has no associated Slack username."
    return
  end

  build_details = {
    status: payload['status'],
    build_num: payload['build_num'],
    build_url: payload['build_url'],
    branch: payload['branch'],
    build_time_millis: payload['build_time_millis'],
    vcs_login: vcs_login,
    vcs_commit_hash: payload['all_commit_details'][0]['commit'],
    vcs_commit_url: payload['all_commit_details'][0]['commit_url']
  }

  slack_message = build_slack_message build_details, slack_username

  send_slack_message slack_message

  status 200
end

helpers do
  def load_secrets
    YAML.load_file(File.expand_path '../secrets.yml', __FILE__)
  end

  def log(message)
    puts message
  end

  def build_slack_message(build_details, slack_username)
    text = if build_details[:status] == 'success'
             'Your build passed!'
           else
             'There was a problem with your build.'
           end
    attachments = [
      {
        title: 'Build details',
        fields: [
          {
            title: 'Status',
            value: build_details[:status],
            short: true
          },
          {
            title: 'Branch',
            value: build_details[:branch],
            short: true
          },
          {
            title: 'Build Number',
            value: "<#{build_details[:build_url]}|#{build_details[:build_num]}>",
            short: true
          },
          {
            title: 'Commit',
            value: "<#{build_details[:vcs_commit_url]}|#{build_details[:vcs_commit_hash]}>",
            short: true
          }
        ]
      }
    ]
    {
      token: @slack_token,
      channel: slack_username,
      text: text,
      attachments: attachments.to_json
    }
  end

  def send_slack_message(slack_message)
    HTTParty.post(SLACK_API_POST_MESSAGE_URL, body: slack_message)
  end
end
