mongo = require 'mongoskin'
cloudq = require 'cloudq'
cron = require 'cron'

class Scheduler
  VERSION: '0.0.2'
  delay: 60000 # every minute

  check_for_updates: ->
    # check cloudq for scheduler updates
    cloudq.consume 'scheduler', (err, resp) ->
      if resp.klass == 'Add'
        [name, schedule, queue, job] = resp.args
        @events.insert { name, schedule, queue, job }, (err, event) -> @create_cron event
    #else TODO Need to figure out how to delete
    #  @events.remove JSON.stringify({ name: event.args[1].name }) if event.first == 'remove'

  load_cron_jobs: ->
    @events.findEach({}, (err, event) ->
      @create_cron event
  
  create_cron: (event) ->
    new cron.CronJob event.schedule, ->
      require('cloudq').cloudq.publish event.queue, event.job.klass, event.job.args

  constructor: (db = 'localhost:27017', collection = 'events') ->
    @events = monogo.db(db).collection(collection)
    
    @load_cron_jobs()
    # every minute
    process.setInterval @check_for_updates, @delay
