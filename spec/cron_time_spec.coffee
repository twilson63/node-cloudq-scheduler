CronTime = require('../lib/cron_time').CronTime

describe 'CronTime', ->
  beforeEach ->
    @cron_tab = new CronTime('* * * * * *')
  it 'should be valid', ->
    (expect @cron_tab.source).toEqual  '* * * * * *'
  it 'should split time', ->
    (expect @cron_tab._split()).toEqual [ '*', '*', '*', '*', '*', '*', '*' ]

