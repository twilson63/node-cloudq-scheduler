mongo = require 'mongoskin'
cloudq = require 'cloudq'
cron = require 'cron'

class Scheduler
  delay: 60000 # every minute

  check_for_updates: ->
    # check cloudq for scheduler updates
    event = cloudq.consume 'events'
    if event.first == 'add'
      @events.insert event.args[1], (err, new_event) -> @create_cron new_event
    #else TODO Need to figure out how to delete
    #  @events.remove JSON.stringify({ name: event.args[1].name }) if event.first == 'remove'

  load_cron_jobs: ->
    @events.findEach({}, (err, event) ->
      @create_cron event
  
  create_cron: (event) ->
    new cron.CronJob event.schedule, ->
      require('cloudq').cloudq.publish event.queue, event.klass, event.args

  constructor: (db = 'localhost:27017', collection = 'events') ->
    @events = monogo.db(db).collection(collection)
    
    @load_cron_jobs()
    # every minute
    process.setInterval @check_for_updates, @delay
