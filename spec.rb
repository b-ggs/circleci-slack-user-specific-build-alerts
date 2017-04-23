require 'rack/test'
require 'rspec'

ENV['RACK_ENV'] = 'test'

require File.expand_path '../script.rb', __FILE__

module RSpecMixin
  include Rack::Test::Methods
  def app() Sinatra::Application end
end

RSpec.configure { |c| c.include RSpecMixin }

describe 'app' do
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

    context 'has valid secrets' do
      before :each do
        expect_any_instance_of(Sinatra::Application).to receive(:load_secrets).and_return(secrets)
        expect_any_instance_of(Sinatra::Application).to receive(:send_slack_message).and_return(slack_response)
      end

      it 'posts properly' do
        post '/', circle_payload.to_json do
          expect(last_response).to be_ok
        end
      end
    end

    context 'has invalid secrets' do
      it 'fails gracefully if there are no secrets specified' do
        expect_any_instance_of(Sinatra::Application).to receive(:load_secrets).and_return({})
        post '/', circle_payload.to_json do
          expect(last_response.status).to be(400)
        end
      end
    end
  end
end
