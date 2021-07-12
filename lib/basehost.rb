require 'open-uri'
require 'sys/filesystem'
require 'sys/cpu'
require 'pp'
include Sys

module BlackStack

  module BaseHost

    # Map the status of this host to the attributes of the class
    # Returns the hash descriptor of the object
    def poll()
      b_total_memory = windows_os? ? `wmic ComputerSystem get TotalPhysicalMemory`.delete('^0-9').to_i : `cat /proc/meminfo | grep MemTotal`.delete('^0-9').to_i*1024
      kb_total_memory = b_total_memory / 1024
      mb_total_memory = kb_total_memory / 1024
      gb_total_memory = mb_total_memory / 1024

      kb_free_memory = windows_os? ? `wmic OS get FreePhysicalMemory`.delete('^0-9').to_i : `cat /proc/meminfo | grep MemFree`.delete('^0-9').to_i
      mb_free_memory = kb_free_memory / 1024
      gb_free_memory = mb_free_memory / 1024

      # getting disk free space
      stat = Sys::Filesystem.stat("/")
      mb_total_disk = stat.block_size * stat.blocks / 1024 / 1024
      mb_free_disk = stat.block_size * stat.blocks_available / 1024 / 1024

      # getting public Internet IP
      #remote_ip = remoteIp()

      # getting server name
      hostname = Socket.gethostname

      # mapping cpu status
#      self.id = BlackStack::SimpleHostMonitoring::host_id
      if windows_os?
        self.cpu_architecture = CPU.architecture.to_s
        self.cpu_speed = CPU.freq.to_i
        self.cpu_load_average = CPU.load_avg.to_i
        self.cpu_model = CPU.model.to_s
        self.cpu_type = CPU.cpu_type.to_s
        self.cpu_number = CPU.num_cpu.to_i
      else
        self.cpu_architecture = `lscpu | grep Architecture`.split(':')[1].strip!
        self.cpu_speed = `lscpu | grep "CPU MHz:"`.split(':')[1].strip!.to_f.round
        self.cpu_load_average = Sys::CPU.load_avg.to_s.to_i
        self.cpu_model = `lscpu | grep "Model"`.split(':')[1].strip!
        self.cpu_type = self.cpu_model.split(' ')[0]
        self.cpu_number = `lscpu | grep "^CPU(s):"`.split(':')[1].strip!.to_i
      end

      # mapping ram status
      self.mem_total = mb_total_memory.to_i
      self.mem_free = mb_free_memory.to_i

      # mapping disk status
      self.disk_total = mb_total_disk.to_i
      self.disk_free = mb_free_disk.to_i

      # mapping lan attributes
      self.net_hostname = hostname
      #self.net_remote_ip = remote_ip.to_s
      self.net_mac_address = BlackStack::SimpleHostMonitoring.macaddress

      self.to_hash
    end

    #
    def to_hash
      {
#        :id => self.id,
        :cpu_architecture => self.cpu_architecture,
        :cpu_speed => self.cpu_speed,
        :cpu_load_average => self.cpu_load_average,
        :cpu_model => self.cpu_model,
        :cpu_type => self.cpu_type,
        :cpu_number => self.cpu_number,
        :mem_total => self.mem_total,
        :mem_free => self.mem_free,
        :disk_total => self.disk_total,
        :disk_free => self.disk_free,
        :net_hostname => self.net_hostname,
        #:net_remote_ip => self.net_remote_ip,
        :net_mac_address => self.net_mac_address
      }
    end

    #
    def self.valid_descriptor?(h)
      return false if !h.is_a?(Hash)
#      return false if !h[:id].to_s.guid?
      return false if h[:cpu_architecture].to_s.size==0
      return false if !h[:cpu_speed].to_s.fixnum?
      return false if !h[:cpu_load_average].to_s.fixnum?
      return false if h[:cpu_model].to_s.size==0
      return false if h[:cpu_type].to_s.size==0
      return false if !h[:cpu_number].to_s.fixnum?
      return false if !h[:mem_total].to_s.fixnum?
      return false if !h[:mem_free].to_s.fixnum?
      return false if !h[:disk_total].to_s.fixnum?
      return false if !h[:disk_free].to_s.fixnum?
      return false if h[:net_hostname].to_s.size==0
      #return false if h[:net_remote_ip].to_s.size==0
      return false if h[:net_mac_address].to_s.size==0
      true
    end

    #
    def self.descriptor_validation_details(h)
      s = ''
      s += 'Wrong descriptor format. ' if !h.is_a?(Hash)
#      s += 'Invalid id. ' if !h[:id].to_s.guid?
      s += 'Invalid cpu_architecture. ' if h[:cpu_architecture].to_s.size==0
      s += 'Invalid cpu_speed. ' if !h[:cpu_speed].to_s.fixnum?
      s += 'Invalid cpu_load_average. ' if !h[:cpu_load_average].to_s.fixnum?
      s += 'Invalid cpu_model. ' if h[:cpu_model].to_s.size==0
      s += 'Invalid cpu_type. ' if h[:cpu_type].to_s.size==0
      s += 'Invalid cpu_number. ' if !h[:cpu_number].to_s.fixnum?
      s += 'Invalid mem_total. ' if !h[:mem_total].to_s.fixnum?
      s += 'Invalid mem_free. ' if !h[:mem_free].to_s.fixnum?
      s += 'Invalid disk_total. ' if !h[:disk_total].to_s.fixnum?
      s += 'Invalid disk_free. ' if !h[:disk_free].to_s.fixnum?
      s += 'Invalid net_hostname. ' if h[:net_hostname].to_s.size==0
      #s += 'Invalid :net_remote_ip. ' if h[:net_remote_ip].to_s.size==0
      s += 'Invalid net_mac_address. ' if h[:net_mac_address].to_s.size==0
      s
    end

    #
    def parse(h)
#      self.id = h[:id]
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
    def push(api_key, url)
      BlackStack::Netting::api_call( url, {:api_key => api_key}.merge(self.to_hash) )
    end

    def windows_os?
      (/cygwin|mswin|mingw|bccwin|wince|emx/ =~ RUBY_PLATFORM) != nil
    end

  end # module BaseHost

end # module BlackStack
