#!/bin/bash

mongoexport -h mongo --db webitel --collection cdr --type=csv --fields  variables.uuid,callflow.0.times.created_time,callflow.0.times.answered_time,callflow.0.times.bridged_time,callflow.0.times.hangup_time,variables.billsec,variables.duration,callflow.0.caller_profile.destination_number,callflow.0.caller_profile.caller_id_number,variables.presence_id,variables.outbound_caller_id_number,variables.cc_queue,variables.cc_agent,variables.cc_side,variables.cc_member_uuid -q
'{"callflow.times.created_time": {$gte: '`date "+%s%6N" --date="-1 day"`'}}' --out /export/cdr-`date "+%Y-%m-%d"`.csv
