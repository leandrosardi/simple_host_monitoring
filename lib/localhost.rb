require_relative './basehost'
require_relative './localhosthistory'

module BlackStack
  
  class LocalHost < Sequel::Model(:host)
    include BaseHost
    LocalHost.dataset = LocalHost.dataset.disable_insert_output
  
    # 
    def parse(h)
      #self.id = h[:id]
      self.cpu_architecture = h[:cpu_architecture]
      self.cpu_speed = h[:cpu_speed]
      self.cpu_load_average = h[:cpu_load_average]
      self.cpu_model = h[:cpu_model]
      self.cpu_type = h[:cpu_type]
      self.cpu_number = h[:cpu_number]    
      self.mem_total = h[:mem_total]
      self.mem_free = h[:mem_free]
      self.disk_total = h[:disk_total]
      self.disk_free = h[:disk_free]
      self.net_hostname = h[:net_hostname]
      #self.net_remote_ip = h[:net_remote_ip]
      self.net_mac_address = h[:net_mac_address] 
    end
  
    # 
    def track
      h = LocalHostHistory.new
      h.id = guid()
      h.id_host = self.id
      h.create_time = now()
      h.cpu_architecture = self.cpu_architecture
      h.cpu_speed = self.cpu_speed
      h.cpu_load_average = self.cpu_load_average
      h.cpu_model = self.cpu_model
      h.cpu_type = self.cpu_type
      h.cpu_number = self.cpu_number    
      h.mem_total = self.mem_total
      h.mem_free = self.mem_free
      h.disk_total = self.disk_total
      h.disk_free = self.disk_free
      h.net_hostname = self.net_hostname
      h.net_remote_ip = self.net_remote_ip
      h.net_mac_address = self.net_mac_address 
      h.save
    end 
  
    # 
    def mem_load
      100.to_f*(self.mem_total.to_f - self.mem_free.to_f) / self.mem_total.to_f
    end
  
    # 
    def disk_load
      100.to_f*(self.disk_total.to_f - self.disk_free.to_f) / self.disk_total.to_f
    end
    
  end # class LocalHost

end # module BlackStack
