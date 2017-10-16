# frozen_string_literal: true

class RepositoriesController < ApplicationController
  def index
    @repositories = Repository.order(:name).filter(params.slice(:language, :dependency, :deployable, :monitorable, :tested, :tracked))
    @dependencies = Dependency.order(:name)
  end

  def show
    @repository = Repository.friendly.find(params[:id])
  end

  def by_org
    render json: Repository.group(:organization).count
  end

  def by_top_5_lang
    render json: Repository.group(:language).order('COUNT(repositories.language) DESC').limit(5).count.chart_json
  end

  def by_lang_dlss
    repos = Repository.where(organization: 'sul-dlss').group(:language).count
    repos['Unknown'] = repos.delete nil
    render json: repos
  end

  def by_lang_cidr
    repos = Repository.where(organization: 'sul-cidr').group(:language).count
    repos['Unknown'] = repos.delete nil
    render json: repos
  end
end
