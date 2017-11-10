string agentName = "<Name of Avi>";
key agentKey = "<UUID of Avi>";
key queryKey;

default {
    state_entry() {
        queryKey = llRequestAgentData(agentKey, DATA_ONLINE);
    }
    dataserver(key queryId, string data) {
        if(queryKey == queryId) {
            integer isOnline = (integer)data;
            if(isOnline == 1) {
                state online;
            } else {
                state offline;
            }
        }
    }
}

state online {
    on_rez(integer start_param) {
        llResetScript();
    }
    state_entry() {
        llMessageLinked(LINK_THIS, 1, agentName, agentKey);
        llSetTimerEvent(2.0);
    }
    timer() {
        queryKey = llRequestAgentData(agentKey, DATA_ONLINE);
    }
    dataserver(key queryId, string data) {
        if(queryKey == queryId) {
            integer isOnline = (integer)data;
            if(isOnline == 0) {
                state offline;
            }
        }
    }
}

state offline {
    on_rez(integer start_param) {
        llResetScript();
    }
    state_entry() {
        llMessageLinked(LINK_THIS, 0, agentName, agentKey);
        llSetTimerEvent(2.0);
    }
    timer() {
        queryKey = llRequestAgentData(agentKey, DATA_ONLINE);
    }
    dataserver(key queryId, string data) {
        if(queryKey == queryId) {
            integer isOnline = (integer)data;
            if(isOnline == 1) {
                state online;
            }
        }
    }
}
