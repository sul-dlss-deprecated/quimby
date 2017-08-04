# frozen_string_literal: true

class RepositoriesController < ApplicationController
  has_scope :deployable, type: :boolean
  has_scope :monitorable, type: :boolean

  def index
    @repositories = apply_scopes(Repository).all
  end

  def show
    @repository = Repository.friendly.find(params[:id])
  end
end
