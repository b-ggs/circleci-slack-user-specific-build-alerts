module CircleHelper
  def build_circle_details(payload)
    last_commit = payload['all_commit_details'].last
    {
      status: payload['status'],
      build_num: payload['build_num'],
      build_url: payload['build_url'],
      branch: payload['branch'],
      build_time_millis: payload['build_time_millis'],
      vcs_login: payload['user']['login'],
      vcs_commit_login: last_commit['committer_login'],
      vcs_commit_hash: last_commit['commit'],
      vcs_commit_url: last_commit['commit_url'],
      vcs_commit_message: last_commit['subject']
    }
  end
end
