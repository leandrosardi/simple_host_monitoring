require_relative './basehost'

module BlackStack

  class RemoteHost
    attr_accessor :cpu_architecture, :cpu_speed, :cpu_load_average, :cpu_model, :cpu_type, :cpu_number, :mem_total, :mem_free, :disk_total, :disk_free, :net_hostname, :net_remote_ip, :net_mac_address  
    include BaseHost
  end # class RemoteHost

end # module BlackStack
