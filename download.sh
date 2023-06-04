#!/bin/bash
## copyright https://qiita.com/takayuki_tk/items/0e8f2364bfdca281bdf0

log_group_name=$1
log_stream_name=$2
response=`aws logs get-log-events --log-group-name ${log_group_name} --log-stream-name "${log_stream_name}" --start-from-head`
next_token=`echo $response | jq -r '.nextForwardToken'`
while [ -n "${next_token}" ]; do
    echo ${response} | jq -r .events[].message
    response=`aws logs get-log-events --log-group-name ${log_group_name} --log-stream-name "${log_stream_name}" --start-from-head --next-token ${next_token}`
    next_token=`echo $response | jq -r '.nextForwardToken'`
    if [[ $(echo ${response} | jq -e '.events == []') == "true" ]]; then
        break
fi
done
