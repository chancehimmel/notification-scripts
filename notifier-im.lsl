key notifyKey = <Avi to notify>";

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

default
{
    link_message(integer sender_num, integer eventNumber, string agentName, key agentKey) {
        llInstantMessage(notifyKey, llGetTimestamp() + ": " + agentName + " is now " + translateEvent(eventNumber));
    }
}
