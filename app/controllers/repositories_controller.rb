# frozen_string_literal: true

class RepositoriesController < ApplicationController
  def index
    @repositories = if params[:deployable].present?
                      params[:deployable] == 'true' ? Repository.deployable : Repository.where(has_capistrano: false)
                    else
                      Repository.all
                    end
  end

  def show
    @repository = Repository.friendly.find(params[:id])
  end
end
