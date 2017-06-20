# frozen_string_literal: true

class RepositoriesController < ApplicationController
  def index
    @repositories = Repository.all
  end

  def show
    @repository = Repository.friendly.find(params[:id])
  end
end
