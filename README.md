# Simple Host Monitoring
Easy library to track memory, CPU and disk space of any host.

This gem has been designed as a part of the **BlackStack** framework.

I ran tests in Windows environments only.

Email to me if you want to collaborate, by testing this library in any Linux platform.

## Installing

```
gem install simple_host_monitoring
```

## Signup to **ConnectionSphere**

While you run the SHM client in your computers, you need to access [ConnectionSphere](https://connectionspheere.com/signup) to watch their status.

1. Go to [ConnectionSpheere.com/signup](https://connectionspheere.com/signup). If you already have an account, go [the logging page](https://connectionspheere.com/login) to login. If you don't remember your password, yo can [reset it here](https://connectionsphere.com/forgot).

2. Generate your API key. Follow [this tutorial](https://help.expandedventure.com/developers/getting-your-api-key) in order to 

	- generate your **API key**, and

	- get the **access points URL** for your API calls.

## Running the tests

Here is a very short script to

1. get the status of your host's CPU, memory and hard drive (polling); and

2. push such numbers to your **ConnectionSphere**'s account every X second.

```ruby
require 'simple_host_monitoring'

# 
parser = BlackStack::SimpleCommandLineParser.new(
  :description => 'This command will launch a SimpleHostMonitoring client that will push the status of the host every X seconds.', 
  :configuration => [{
    :name=>'log', 
    :mandatory=>false, 
    :description=>'Write a logfile with the status of this command.', 
    :type=>BlackStack::SimpleCommandLineParser::BOOL,
    :default=>false
  },
  {
    :name=>'log_auto_delete', 
    :mandatory=>false, 
    :description=>'Write a logfile with the status of this command.', 
    :type=>BlackStack::SimpleCommandLineParser::BOOL,
    :default=>true
  },
  {
    :name=>'poll_seconds', 
    :mandatory=>false, 
    :description=>'How many delay seconds between the starting of a poll cycle and the starting of the next one.', 
    :type=>BlackStack::SimpleCommandLineParser::INT,
    :default=>10
  },
  ]
)

# 
logger = BlackStack::LocalLoggerFactory.create('./shmclient.log')

#
while (true) 
  url = "https://127.0.0.1:444/api1.4/shm/update.json" # TODO: Replace 120.0.0.1:444 with your **access points URL**
  api_key = 'XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX' # TODO: Write your **API key**

  logger.logs "Flag start time... "
  start_time = Time.now
  logger.done
  
  logger.logs "Poll... "
  host = BlackStack::RemoteHost.new
  host.poll
  logger.done

  logger.logs "Flag end time... "
  end_time = Time.now
  logger.done

  logger.logs "Push... "
  host.push(api_key, url) 
  logger.done

  logger.logs "Sleep... "
  enlapsed_seconds = end_time - start_time
  poll_seconds = parser.value('poll_seconds')
  sleep( poll_seconds - enlapsed_seconds ) if poll_seconds > enlapsed_seconds
  logger.done
end
```

## Wathing and Managing Your Monitors

Run the script above in as many hosts as you want.

Login to your **ConnectionSphere** account, and then go [here](https://connectionsphere.com/shm/dashboard) to watch your monitors and setup email alerts.

## Further Work

* Run the script above as a Windows service.
* Develop and publish an MSI to install the Windows service mentioned above.




