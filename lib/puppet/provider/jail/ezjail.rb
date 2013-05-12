Puppet::Type.type(:jail).provide(:ezjail) do

  confine :operatingsystem => :freebsd
  defaultfor :operatingsystem => :freebsd

  commands :ezjail_admin => 'ezjail-admin'
  
  def exists?
    begin
      ezjail_admin('status', resource[:name])
    rescue Puppet::ExecutionFailure => e
      false
    end
  end

  def create
    ezjail_admin('create', resource[:name], resource[:ip_address])
    @property_hash[:ensure] = :present
  end 

  def destroy
    ezjail_admin('destroy', resource[:name])
    @property_hash.clear
  end

  def start
    ezjail_admin('start', resource[:name])
  end

  def stop
    ezjail_admin('stop', resource[:name])
  end

  def self.instances
    jails = ezjail_admin('list')
    jails.split("\n")[2..-1].collect do |line|
      match = line.scan /\A(.{3}) (.{4}) (.{15}) (.{30}) (.*)\z/
      new( :name => match[4].strip
        :ip_address => match[3].strip
      )
    end
  end

  def self.prefetch(resources)
    jails = instances
    resources.keys.each do |name|
      if provider = jails.find{ |jail| jail.name == name }
        resources[name].provider = provider
      end
    end
  end

  def exists?
    @property_hash[:ensure] == :present
  end

end