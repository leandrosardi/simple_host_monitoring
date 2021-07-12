require_relative '../lib/simple_host_monitoring'

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
logger = BlackStack::LocalLoggerFactory.create('./example01.log')

#
while (true) 
  url = "https://euler.connectionsphere.com/api1.4/shm/update.json"
  api_key = '290582D4-D00C-4D37-82AF-23043B242647'

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
