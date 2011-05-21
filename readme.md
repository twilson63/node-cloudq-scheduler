# Cloudq-Scheduler

## DISCLAIMER - Still a work in progress

Cloudq Scheduler is a cloudq worker written in nodejs, the purpose of
this worker is to take tasks and schedule them like an alarm system.
Then publish the body of the task based on the alarm system rules.

The alarm system should support all kinds of scheduled task from
re-occuring to one specific alert.

# Requirements
    NodeJs
    MongoDb

# Install

    git clone http://github.com/twilson63/node-cloudq-scheduler.git

# Usage
    # Load dependencies
    npm install .

    # Setup your MongoDb ENV Variables
    export MONGODB_URL=mongo://localhost:27017/scheduler

    # run as a cloudq worker...

    > coffee app.coffee
    or 
    > node app.js

    # publish jobs to schedule
    # POST - http://cloudq.com/scheduler
    # Arguments
    # [name, schedule, queue, job]
    
    { job: {
      klass: 'Add'
      args: ['backup-full', '00 30 11 * * *', 'backup', 
        { klass: 'Backup', args: ['full'] }
      ]}
    }


# Feedback

# Contribution

# License



