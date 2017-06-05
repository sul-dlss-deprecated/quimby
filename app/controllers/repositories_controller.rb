# frozen_string_literal: true

class RepositoriesController < ApplicationController
  def index
    @repositories = Repository.all
  end
end
