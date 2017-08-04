# frozen_string_literal: true

class Repository < ApplicationRecord
  has_many :deploy_environments
  has_many :servers, through: :deploy_environments

  scope :deployable, -> { where(has_capistrano: true) }
  scope :monitorable, -> { where(has_okcomputer: true).or(where(has_is_it_working: true)) }

  extend FriendlyId
  friendly_id :name, use: :slugged

  def unique_deploy_envs
    deploy_environments.map(&:name).uniq
  end

  def servers_deployed_to(env)
    deploy_environments.where(name: env).map { |e| e.server.hostname }
  end
end
