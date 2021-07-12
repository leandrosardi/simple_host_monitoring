require 'simple_command_line_parser'
require 'simple_cloud_logging'

require 'socket'
require 'time'
require 'uri'
require 'net/http'
require 'json'
require 'openssl'
require 'tiny_tds'
require 'sequel'

require_relative './basehost'
require_relative './remotehost'
#require_relative './localhost'

module BlackStack
  
  module SimpleHostMonitoring

    # get the unique host id from the file ./host_id.data
    # if the file does not exists, it will ask the API for a GUID and create the file
    HOST_ID_FILENAME = './host_id.data'

=begin # derepcated
    @@host_id = nil
    def self.reset_host_id
      @@host_id = BlackStack::Pampa::get_guid
      File.open(HOST_ID_FILENAME, 'w') {|f| f.write(@@host_id) }
      @@host_id
    end
    def self.host_id
      if @@host_id.nil?
        if File.file?(HOST_ID_FILENAME)
          @@host_id = File.read(HOST_ID_FILENAME)
        else
          @@host_id = self.reset_host_id
        end
      end # !@@host_id.nil?
      @@host_id = self.reset_host_id if !@@host_id.guid?
      @@host_id
    end
=end
    # This function works in windows only
    # TODO: Esta funcion no retorna la mac address completa
    # TODO: Validar que no se retorne una macaddress virtual, con todos valores en 0
    def self.macaddress()
      return `cat /sys/class/net/eth0/address`.upcase.strip.gsub(':', '-') unless BlackStack::RemoteHost.new.windows_os?

      s = `ipconfig /all`

      # The standard (IEEE 802) format for printing MAC-48
      # => addresses in human-friendly form is six groups
      # => of two hexadecimal digits, separated by hyphens
      # => - or colons :
      v = s.scan(/(([A-F0-9]{2}\-){5})([A-F0-9]{2}$)/im)

      if (v.size>0)
        return v.first.join.to_s
      else
        return nil
      end
    end

    #
    def self.require_db_classes()
      # You have to load all the Sinatra classes after connect the database.
      require_relative '../lib/localhost.rb'
      require_relative '../lib/localhosthistory.rb'
    end        

  end # module SimpleHostMonitoring
  
end # module BlackStack


