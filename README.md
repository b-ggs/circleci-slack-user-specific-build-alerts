# CircleCI - Slack user-specific build alerts

Get CircleCI build alerts for your own builds on Slack!

Why? The [current CircleCI Slack integration](https://slack.com/apps/A0F7VRE7N-circleci) is too noisy, as it gives build alerts for all branches in one Slack channel, which then tends to be ignored and muted by the team because of the sheer amount of build alerts coming in.

This sends build alerts directly to the person who initiated the build (via @slackbot), eliminating the noise and lessening the number of alerts received by one user.

## Getting Started

### Setting up a custom Slack app

- Create a new app on Slack [here](https://api.slack.com/apps).

- Under `OAuth & Permissions` > `Permission Scopes`, add permissions for `chat:write:bot`.

- Generate an OAuth Access Token. This will be used by the app later.

### Setting up the Sinatra app

- Clone the repository.

- Create your own `secrets.yml` file, following the included `secrets.example.yml` file.

- Put your Slack OAuth Access Token under the `slack_token` attribute.

- Populate the `users` field by providing each user's VCS login (GitHub, BitBucket, etc. username) and their Slack @handle.

- Run `bundle install`.

- Start the server with `ruby app.rb`.

- Host the app on your preferred service.

- Test if the app is up by sending a `GET` request to `/`. It should return `PONG`.

### Setting up CircleCI hooks

- Add the following to your `circle.yml`

```
notify:
  webhooks:
    - url: http://where-you-hosted-your-app.com/
```

For more details, check out the [CircleCI docs](https://circleci.com/docs/1.0/configuration/#notify)
