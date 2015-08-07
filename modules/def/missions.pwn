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
    MISSION_INTRO,
    MISSION_SWEET_CALL = 1,
    MISSION_HOME_INVASION
}
static Mission:gplAccomplishedMissions[MAX_PLAYERS];

Mission:GetPlayerCurrentMission(playerid)
{
    return gplAccomplishedMissions[playerid];
}

SetPlayerCurrentMission(playerid, Mission:missionid)
{
    gplAccomplishedMissions[playerid] = missionid;
}

hook OnPlayerConnect(playerid)
{
    gplAccomplishedMissions[playerid] = MISSION_INTRO;
    return 1;
}
