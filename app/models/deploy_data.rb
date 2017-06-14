# frozen_string_literal: true

class DeployData
  attr_reader :client

  def initialize(org)
    @client = GithubClient.new(org)
  end

  def self.run(org)
    new(org).load_data
  end

  # rubocop:disable MethodLength
  def load_data
    repo_deploy_envs_and_servers.each do |repo, envs|
      envs.each do |env, servers|
        servers.each do |server|
          r = Repository.find_by(name: repo)
          s = Server.find_by(fqdn: server)
          DeployEnvironment.find_or_create_by(repository: r, server: s).tap do |deploy_env|
            deploy_env.update(name: env)
          end
        end
      end
    end
    true
  end
  # rubocop:enable MethodLength

  private

  def repo_deploy_env_paths
    deploy_envs = {}
    Repository.deployable.each do |repo|
      deploy_envs[repo.name] = client.list_files_at_path(repo.name, 'config/deploy/')
    end
    deploy_envs.reject { |_k, v| v.empty? }
  end

  # rubocop:disable MethodLength
  def repo_deploy_envs_and_servers
    repos = {}
    repo_deploy_env_paths.each do |repo, env_paths|
      repos[repo] = {}
      env_paths.each do |env|
        environment = File.basename(env, '.rb')
        repos[repo][environment] = []
        content = client.file_content(repo, env)
        repos[repo][environment] = get_servers(content)
      end
    end
    repos
  end
  # rubocop:enable MethodLength

  def get_servers(content)
    servers = []
    content.each_line do |line|
      next unless line[/^server\s/]
      match = line[/[a-z0-9-]+.stanford.edu/]
      servers << match if match
    end
    servers
  end
end
