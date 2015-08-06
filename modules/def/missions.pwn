/*******************************************************************************
* FILENAME :        modules/def/missions.pwn
*
* DESCRIPTION :
*       List and constants of current implemented missions.
*
* NOTES :
*       -
*/

enum Mission (+=1)
{
    INVALID_MISSION_ID,
    MISSION_INTRO = 1
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
