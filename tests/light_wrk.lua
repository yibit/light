-- curl -H 'Content-Type:application/json' -v -k http://192.168.1.33:8090/ussd/send_message/ \
-- {\"timeStamp\":1467272137,\"content\":\":0123456789abcABC测试\",
-- \"called_msisdn\":\"13120333084\",\"dialing_msisdn\":\"01053778375\"}

wrk.method = "POST"
wrk.headers["Content-Type"] = "application/json"
wrk.body =
    '{"timeStamp":1467272137,"content":":0123456789abcABC测试","called_msisdn":"13120333084","dialing_msisdn":"01053778375"}'
