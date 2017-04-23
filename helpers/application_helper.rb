require 'yaml'
require 'logger'

module ApplicationHelper 
  def load_secrets
    YAML.load_file(File.expand_path '../../secrets.yml', __FILE__)
  end

  def format_message(message, build_num)
    "#{Time.now.to_s} - Build #{build_num} - #{message}"
  end

  def log(message, build_num)
    message = format_message message, build_num
    File.open 'app.log', 'a+' do |f|
      f.puts message
    end
    $stderr.puts message
  end
end
