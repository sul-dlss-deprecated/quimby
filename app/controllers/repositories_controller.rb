# frozen_string_literal: true

class RepositoriesController < ApplicationController
  def index
    @repositories = Repository.order(:name).filter(params.slice(:language, :deployable, :monitorable, :tested, :tracked))
  end

  def show
    @repository = Repository.friendly.find(params[:id])
  end
end
