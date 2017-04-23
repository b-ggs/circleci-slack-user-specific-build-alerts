require File.expand_path '../spec_helper.rb', __FILE__

describe 'GET /' do
  it 'returns PONG' do
    get '/' do 
      expect(last_response.body).to eq('PONG')
    end
  end
end

describe 'POST /' do
  let(:secrets) {
    {
      'slack_token'=>'123',
      'users'=>{
        'b-ggs'=>'@boggs'
      }
    }
  }

  let(:circle_payload) {
    {
      payload: {
        status: 'success',
        build_num: '123',
        build_url: 'https://oval-ci.com/build/123',
        branch: 'feature/foo',
        build_time_millis: '100',
        all_commit_details: [{
          author_login: 'b-ggs',
          commit: '123',
          commit_url: 'https://tighub.com/commit/123'
        }]
      }
    }
  }

  let(:slack_response) {
    {
      'ok'=>true
    }
  }

  context 'when secrets are valid' do
    before :each do
      expect_any_instance_of(app).to receive(:load_secrets).and_return(secrets)
    end

    it 'responds with OK' do
      expect_any_instance_of(app).to receive(:send_slack_message).and_return(slack_response)

      post '/', circle_payload.to_json do
        expect(last_response).to be_ok
      end
    end

    it 'logs when Slack message send fails' do
      slack_response['ok'] = false
      slack_response['error'] = 'invalid_auth'

      expect_any_instance_of(app).to receive(:send_slack_message).and_return(slack_response)

      expect_any_instance_of(app).to receive(:log).with('Message sending failed with error: invalid_auth', '123')

      post '/', circle_payload.to_json do
        expect(last_response.status).to be(400)
      end
    end

    it 'logs when vcs login doesn\'t have an associated Slack username' do
      circle_payload[:payload][:all_commit_details][0][:author_login] = 'not-boggs'

      expect_any_instance_of(app).to receive(:log).with('User not-boggs has no associated Slack username.', '123')

      post '/', circle_payload.to_json do
        expect(last_response.status).to be(400)
      end
    end
  end

  context 'when secrets are invalid' do
    it 'logs error when there are no secrets given' do
      expect_any_instance_of(app).to receive(:load_secrets).and_return({})
      expect_any_instance_of(app).to receive(:log).with('There is a problem with your secrets file.', nil)
      post '/', circle_payload.to_json do
        expect(last_response.status).to be(400)
      end
    end
  end
end
