class BushidoGitHooks < Bushido::EventObserver
  def git_received
    repo      = params['data']['repository']
    repo_name = repo['name']
    commits   = params['data']['commits']
    actor     = commits.last['author']['name']
    actor   ||= commits.last['author']['email']
    url       = commits.last['url']
    message   = commits.last['message']
    branch    = params['data']['ref'].split("/").last

    message = "#{actor} pushed to #{repo_name}/#{branch}, saying '#{message}' -> See more at #{url}"

    Channel.announce(message)
  end
end
