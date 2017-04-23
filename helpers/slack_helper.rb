require 'httparty'

SLACK_API_POST_MESSAGE_URL = 'https://slack.com/api/chat.postMessage'

module SlackHelper
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
