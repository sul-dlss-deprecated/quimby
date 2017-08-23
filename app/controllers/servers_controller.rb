# frozen_string_literal: true

class ServersController < ApplicationController
  def index
    @servers = Server.order(:hostname).filter(params.slice(:pupgraded))
  end
end
