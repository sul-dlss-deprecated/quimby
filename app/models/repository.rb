# frozen_string_literal: true

class Repository < ApplicationRecord
  include Filterable

  has_many :deploy_environments
  has_many :servers, through: :deploy_environments
  has_many :dependencies

  scope :language, ->(language) { where(language: language) }
  scope :dependency, ->(dependency) do
    left_outer_joins(:dependencies).where('dependencies.name': dependency)
  end
  scope :deployable, ->(deployable = true) { where(has_capistrano: deployable) }
  scope :monitorable, ->(monitorable) do
    if monitorable == 'true'
      where(has_okcomputer: monitorable).or(where(has_is_it_working: monitorable))
    else
      where(has_okcomputer: monitorable).where(has_is_it_working: monitorable)
    end
  end
  scope :tested, ->(tested) { where(has_travis: tested) }
  scope :tracked, ->(tracked) do
    if tracked == 'true'
      where.not(gemnasium_alerts: nil).or(where(has_honeybadger: tracked))
    else
      where(gemnasium_alerts: nil).where(has_honeybadger: tracked)
    end
  end
  scope :documented, ->(documented) do
    if documented == 'true'
      where.not(documentation_url: nil)
    else
      where(documentation_url: nil)
    end
  end

  extend FriendlyId
  friendly_id :name, use: :slugged

  def unique_deploy_envs
    deploy_environments.map(&:name).uniq
  end

  def servers_deployed_to(env)
    deploy_environments.where(name: env).map { |e| e.server.hostname }
  end
end
