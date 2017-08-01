# frozen_string_literal:true

class Server < ApplicationRecord
  has_many :deploy_environments
  has_many :repositories, through: :deploy_environments

  def self.nic_types
    %w[VirtualVmxnet3 VirtualE1000]
  end
end
