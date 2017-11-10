string agentName = "<Name of Avi>";
key agentKey = "<UUID of Avi>";
key notifyKey = "<UUID of Avi to notify>";
key queryKey;

string createKeyValue(string keyName, string value, integer addComma)
{
    string value = "\"" + keyName + "\": \"" + value + "\"";
    if(addComma == TRUE)
    {
        return value + ", ";
    }
    else
    {
        return value;
    }
}

string packageJSON(list values)
{
    string value = "{";
    integer i;
    integer length = llGetListLength(values);
    for (i = 0; i < length; i += 2)
    {
        integer addComma = i + 2 < length;
        value += createKeyValue(llList2String(values, i), llList2String(values, i+1), addComma);
    }
    value += "}";
    return value;
}

string constructJSON(string aviKey, string aviName, string eventName)
{
    return packageJSON(["key", aviKey, "name", aviName, "event", eventName]);
}

default
{
    state_entry()
    {
        //llOwnerSay(llGetOwner());
        queryKey = llRequestAgentData(agentKey, DATA_ONLINE);
    }
    dataserver(key queryId, string data)
    {
        if(queryKey == queryId)
        {
            integer isOnline = (integer)data;
            if(isOnline == 1)
            {
                state online;
            }
            else
            {
                state offline;
            }
        }
    }

}

state online
{
    on_rez(integer start_param)
    {
        llResetScript();
    }
    state_entry()
    {
        httpRequestId = llHTTPRequest("http://07135943.ngrok.io/session",
            [HTTP_METHOD, "POST", HTTP_MIMETYPE, "application/json"],
            constructJSON(agentKey, agentName, "online"));
        llInstantMessage(notifyKey, llGetTimestamp() + ": " + agentName + " came online");
        llSetTimerEvent(2.0);
    }
    touch(integer numDetected) {
        if(llDetectedKey(0) == llGetOwner())
        {
            llInstantMessage(notifyKey, llGetTimestamp() + ": " + agentName + " is online");
        }
    }
    timer()
    {
        queryKey = llRequestAgentData(agentKey, DATA_ONLINE);
    }
    dataserver(key queryId, string data)
    {
        if(queryKey == queryId)
        {
            integer isOnline = (integer)data;
            if(isOnline == 0)
            {
                state offline;
            }
        }
    }
}

state offline
{
    on_rez(integer start_param)
    {
        llResetScript();
    }
    state_entry()
    {
        httpRequestId = llHTTPRequest("http://07135943.ngrok.io/session",
            [HTTP_METHOD, "POST", HTTP_MIMETYPE, "application/json"],
            constructJSON(agentKey, agentName, "offline"));
        llInstantMessage(notifyKey, llGetTimestamp() + ": " + agentName + " went offline");
        llSetTimerEvent(2.0);
    }
    touch(integer numDetected) {
        if(llDetectedKey(0) == llGetOwner())
        {
            llInstantMessage(notifyKey, llGetTimestamp() + ": " + agentName + " is offline");
        }
    }
    timer()
    {
        queryKey = llRequestAgentData(agentKey, DATA_ONLINE);
    }
    dataserver(key queryId, string data)
    {
        if(queryKey == queryId)
        {
            integer isOnline = (integer)data;
            if(isOnline == 1)
            {
                state online;
            }
        }
    }
}
