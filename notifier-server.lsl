string BASE_URI = <base URL for server>;

/**
 * Create a JSON message for the given avitar key, avitar name and event
 */
string constructJSON(string aviKey, string aviName, string eventName) {
    return packageJSON(["key", aviKey, "name", aviName, "event", eventName]);
}

/**
 * Accepts a key name and a value and returns a string of the form:
 *     "keyName": "value"
 * If 'addComma' is true, it will also add a comma to the end of the value:
 *     "keyName": "value",
 */
string createKeyValue(string keyName, string value, integer addComma) {
    string value = "\"" + keyName + "\": \"" + value + "\"";
    if(addComma == TRUE) {
        return value + ", ";
    } else {
        return value;
    }
}

/**
 * Translate the given event number to a string:
 *     1 - online
 *     anything else - offline
 */
string translateEvent(integer eventNumber) {
    if(eventNumber == 1) {
        return "online";
    } else {
        return "offline";
    }
}

/**
 * Accepts a list of key/value pairs and creates a simple JSON representation of it.
 * The list contains alternating keys and values.
 * For example:
 *     ["key1", "value1", "key2", "value2"]
 * would produce:
 *     {"key1": "value1", "key2": "value2"}
 */
string packageJSON(list values) {
    string value = "{";
    integer i;
    integer length = llGetListLength(values);
    for (i = 0; i < length; i += 2) {
        integer addComma = i + 2 < length;
        value += createKeyValue(llList2String(values, i), llList2String(values, i+1), addComma);
    }
    value += "}";
    return value;
}

default {
    link_message(integer sender_num, integer eventNumber, string agentName, key agentKey) {
        llHTTPRequest(BASE_URI + "/session",
            [HTTP_METHOD, "POST", HTTP_MIMETYPE, "application/json"],
            constructJSON(agentKey, agentName, translateEvent(eventNumber)));
    }
}
