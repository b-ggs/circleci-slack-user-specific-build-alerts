# CircleCI - Slack user-specific build alerts

Get CircleCI build alerts for your own builds on Slack!

![](http://i.imgur.com/XM4EoXL.png)

Why? The [current CircleCI Slack integration](https://slack.com/apps/A0F7VRE7N-circleci) is too noisy, as it gives build alerts for all branches in one Slack channel, which then tends to be ignored and muted by the team because of the sheer amount of build alerts coming in.

This sends build alerts directly to the person who initiated the build (via @slackbot), eliminating the noise and lessening the number of alerts received by one user.

## Getting Started

### Setting up a custom Slack app

- Create a new app on Slack [here](https://api.slack.com/apps).

- Under `OAuth & Permissions` > `Permission Scopes`, add permissions for `chat:write:bot`.

- Generate an OAuth Access Token. This will be used by the app later.

### Setting up the app

- Clone the repository.

- Create your own `secrets.yml` file, following the included `secrets.example.yml` file.

- Put your Slack OAuth Access Token under the `slack_token` attribute.

- Populate the `users` field by providing each user's VCS login (GitHub, BitBucket, etc. username) and their Slack @handle.

- Deploy the app with or without Docker by following the instructions below.

### Deploy the app with Docker

- Run `docker build -t circleci-slack-user-specific-build-alerts .`

- Run `docker run -p 4567:4567 circleci-slack-user-specific-build-alerts`

- Host the app on your preferred service.

- Test if the app is up by visiting the URL or sending a `GET` request to `/`. It should return `PONG`.

### Deploy the app without Docker

- Run `bundle install`.

- Start the server with `ruby app.rb`.

- Host the app on your preferred service.

- Test if the app is up by visiting the URL or sending a `GET` request to `/`. It should return `PONG`.

### Setting up CircleCI hooks

- Add the following to your `circle.yml`

```
notify:
  webhooks:
    - url: http://your-ip-address:4567
```

- For more details, check out the [CircleCI docs](https://circleci.com/docs/1.0/configuration/#notify)

## Usage

Usage is pretty straighforward.

Provided that you've correctly configured everything above, upon the completion of a build on CircleCI, the app sends a Slack message to the associated user notifying them of the completed build.

**Quick tips:**

- Problems with the app will be logged in `app.log` on the project directory.

- You can check if the app is up by visiting the URL or sending a `GET` request to `/`. It should return `PONG`.

## Testing

Tested using [rspec](http://rspec.info/). To run the tests, just run `bundle exec rspec`.

## Support

Feel free to send in [issues](https://github.com/b-ggs/circleci-slack-user-specific-build-alerts/issues) and [pull requests](https://github.com/b-ggs/circleci-slack-user-specific-build-alerts/pulls).
