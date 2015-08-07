/*******************************************************************************
* FILENAME :        modules/def/missions.pwn
*
* DESCRIPTION :
*       List and constants of current implemented missions.
*
* NOTES :
*       -
*/

#include <YSI\y_hooks>

enum Mission (+=1)
{
    INVALID_MISSION_ID,
    MISSION_INTRO = 1,
    MISSION_SWEET_CALL
}
static Mission:gplAccomplishedMissions[MAX_PLAYERS];

Mission:GetPlayerCurrentMission(playerid)
{
    return Mission:(_:gplAccomplishedMissions[playerid] + 1);
}

SetPlayerCurrentMission(playerid, Mission:missionid)
{
    gplAccomplishedMissions[playerid] = missionid;
}

hook OnPlayerConnect(playerid)
{
    gplAccomplishedMissions[playerid] = INVALID_MISSION_ID;
    return 1;
}
