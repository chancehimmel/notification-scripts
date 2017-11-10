key queryKey;
key requestKey;

default {
    state_entry() {
        llRequestURL();
    }
    http_request(key id, string method, string body) {
        if(method == URL_REQUEST_GRANTED) {
            llSay(0, body);
        } else if(method == "POST") {
            requestKey = id;
            queryKey = llRequestAgentData(body, DATA_NAME);
        }
    }
    dataserver(key thisKey, string data) {
        if(queryKey == thisKey) {
            llHTTPResponse(requestKey, 200, data);
        }
    }
}
