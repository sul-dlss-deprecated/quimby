# frozen_string_literal: true

require 'puppetdb'

class PuppetdbClient
  attr_reader :client

  def initialize
    @client = PuppetDB::Client.new(server: Settings.PUPPETDB_ENDPOINT)
  end

  def ipaddress(fqdn)
    # once we are on facter v. 3, we will have access to
    # the structured 'networking' fact which could be valuable
    response = client.request('facts', ['and', ['=', 'certname', fqdn], ['=', 'name', 'ipaddress']])
    response.data.first['value']
  end

  def all_fqdns
    response = client.request('facts', ['=', 'name', 'hostname'])
    response.data.collect { |key| key['certname'] }
  end

  def pupgraded_fqdns
    response = client.request('facts', ['and',
                                        ['=', 'name', 'fqdn'],
                                        ['in', 'certname',
                                         ['extract', 'certname',
                                          ['select-resources',
                                           ['and', ['=', 'type', 'Class'], ['=', 'title', 'Role::Basenode']]]]]])
    response.data.collect { |key| key['certname'] }
  end

  def pupgraded?(fqdn)
    pupgraded_fqdns.include?(fqdn) ? true : false
  end
end
