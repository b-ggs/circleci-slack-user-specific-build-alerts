module CircleHelper
  def build_circle_details(payload)
    {
      status: payload['status'],
      build_num: payload['build_num'],
      build_url: payload['build_url'],
      branch: payload['branch'],
      build_time_millis: payload['build_time_millis'],
      vcs_login: payload['all_commit_details'][0]['author_login'],
      vcs_commit_hash: payload['all_commit_details'][0]['commit'],
      vcs_commit_url: payload['all_commit_details'][0]['commit_url']
    }
  end
end
