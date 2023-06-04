#!/bin/zsh

# 3つ目以降のパラメーターを文字列として連結する

ignore_string_1="--log-group-name"
ignore_string_2="--log-stream-name"
ignore_string_3="--start-from-head"
ignore_string_4="--next-token"
concatenated_string=""
for param in "${@:3}"; do
  if [[ "$param" == *"$ignore_string_1"* ]]; then
    echo "指定された文字列 '$ignore_string_1' が見つかりました。スクリプトを終了します。"
    exit 1
  fi
  if [[ "$param" == *"$ignore_string_2"* ]]; then
    echo "指定された文字列 '$ignore_string_2' が見つかりました。スクリプトを終了します。"
    exit 1
  fi
  if [[ "$param" == *"$ignore_string_3"* ]]; then
    echo "指定された文字列 '$ignore_string_3' が見つかりました。スクリプトを終了します。"
    exit 1
  fi
  if [[ "$param" == *"$ignore_string_4"* ]]; then
    echo "指定された文字列 '$ignore_string_4' が見つかりました。スクリプトを終了します。"
    exit 1
  fi

  concatenated_string="${concatenated_string} ${param}"
done

log_group_name=$1
log_stream_name=$2
response=`aws logs get-log-events --log-group-name ${log_group_name} --log-stream-name "${log_stream_name}" --start-from-head ${concatenated_string}`
next_token=`echo $response | jq -r '.nextForwardToken'`
while [ -n "${next_token}" ]; do
    echo ${response} | jq -r .events[].message
    response=`aws logs get-log-events --log-group-name ${log_group_name} --log-stream-name "${log_stream_name}" --start-from-head --next-token ${next_token} ${concatenated_string}`
    next_token=`echo $response | jq -r '.nextForwardToken'`
    if [[ $(echo ${response} | jq -e '.events == []') == "true" ]]; then
        break
fi
done
