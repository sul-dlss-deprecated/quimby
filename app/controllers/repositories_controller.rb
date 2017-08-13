# frozen_string_literal: true

class RepositoriesController < ApplicationController
  def index
    @repositories = Repository.filter(params.slice(:language, :deployable, :monitorable, :tested, :documented))
  end

  def show
    @repository = Repository.friendly.find(params[:id])
  end
end
