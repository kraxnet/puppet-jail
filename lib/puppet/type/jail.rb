Puppet::Type.newtype(:jail) do

  desc 'jail is a type for managing jails on FreeBSD'

  ensurable do
   desc "The jail's ensure field can assume one of the following values:
  `running`:
    Creates jail, it's config file, and makes sure the jail is running.
  `installed`:
    Creates jail, it's file, but doesn't touch the state of the jail.
  `stopped`:
    Creates jail, it's config file, and makes sure the jail is not running.
  `absent`:
    Removes config file, and makes sure the jail is not running.
  `purged`:
    Purge all files related (including jail's data) /NOT IMPLEMENTED/."
    newvalue(:stopped) do
      provider.stop
    end

    newvalue(:running) do
      provider.start
    end

    newvalue(:installed) do
      provider.create
    end

    newvalue(:absent) do
      provider.destroy
    end

    # newvalue(:purged) do
    #   provider.purge
    # end

    defaultto(:running)

    def retrieve
      provider.status
    end
  end

  newparam(:name, :namevar => true) do
    desc 'Jails\'s hostname'
  end

  newparam(:ip_address) do
    desc 'Jail\'s ip address'
  end

end