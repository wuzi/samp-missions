/*******************************************************************************
* FILENAME :        modules/missions/intro.pwn
*
* DESCRIPTION :
*       First mission the player will receive.
*
* NOTES :
*       -
*/

static gplCurrentSound[MAX_PLAYERS];
static gplBMX[MAX_PLAYERS] = {INVALID_VEHICLE_ID, ...};
static Timer:gplHomeSoundTimer[MAX_PLAYERS] = {Timer:-1, ...};
static bool:gplHomeSound[MAX_PLAYERS];

static gCutsceneData[][][] =
{
    {43200, 2500, "Ah shit, here we go again."},
    {43201, 2000, "Worst place in the world."},
    {43202, 2000, "Rollin Heights Balla country."},
    {43203, 2750, "I ain't represented Grove Street in five years,"},
    {43204, 2000, "but the Ballas won't give a shit."}
};

#include <YSI\y_hooks>

hook OnPlayerEnterCheckpoint(playerid)
{
    if(IsPlayerInRangeOfPoint(playerid, 2.0, 2495.1477, -1687.3627, 13.5150))
    {
        RemovePlayerMapIcon(playerid, 0);
        SetPlayerCurrentMission(playerid, GetPlayerCurrentMission(playerid) + Mission:1);
        GameTextForPlayer(playerid, "mission passed!~n~~w~respect +", 9000, 0);
        PlayMissionPassedSound(playerid);
    }
    return 1;
}

hook OnPlayerSpawn(playerid)
{
    if(GetPlayerCurrentMission(playerid) == MISSION_INTRO)
    {
        if(gplBMX[playerid] != INVALID_VEHICLE_ID)
            DestroyVehicle(gplBMX[playerid]);

        gplBMX[playerid] = CreateVehicle(481, 2242.8528, -1263.3127, 23.4636, 271.3464, -1, -1, 180);

        gplHomeSoundTimer[playerid] = repeat ProcessGrooveDialog(playerid);
        gplHomeSound[playerid] = false;

        gplCurrentSound[playerid] = 0;
        SetPlayerFacingAngle(playerid, 272.5557);
        SetPlayerPos(playerid, 2218.0745, -1262.5208, 23.9043);
        SetPlayerMapIcon(playerid, 0, 2495.1477, -1687.3627, 13.5150, 15, -1, MAPICON_GLOBAL_CHECKPOINT);
        InterpolateCameraPos(playerid, 2217.1032, -1261.4175, 24.5569, 2232.1492, -1261.3274, 24.6119, 17000, CAMERA_MOVE);
        InterpolateCameraLookAt(playerid, 2218.8735, -1261.3779, 24.5370, 2233.1526, -1261.3199, 24.6220, 17000, CAMERA_MOVE);
        IntroProcessCutscene(playerid);
    }
    return 1;
}

hook OnVehicleSpawn(vehicleid)
{
    for(new i = 0; i < MAX_PLAYERS; i++)
    {
        if(vehicleid == gplBMX[i])
        {
            DestroyVehicle(gplBMX[i]);
            gplBMX[i] = INVALID_VEHICLE_ID;
            break;
        }
    }
    return 1;
}

hook OnPlayerDisconnect(playerid, reason)
{
    if(gplBMX[playerid] != INVALID_VEHICLE_ID)
    {
        DestroyVehicle(gplBMX[playerid]);
        gplBMX[playerid] = INVALID_VEHICLE_ID;
    }

    if(gplHomeSoundTimer[playerid] != Timer:-1)
    {
        stop gplHomeSoundTimer[playerid];
        gplHomeSoundTimer[playerid] = Timer:-1;
    }
    return 1;
}

timer ProcessGrooveDialog[2500](playerid)
{
    if(IsPlayerInArea(playerid, 2440.8914, -1720.0466, 2539.6140, -1630.5706) && gplHomeSound[playerid] == false)
    {
        gplHomeSound[playerid] = true;
        stop gplHomeSoundTimer[playerid];
        gplHomeSoundTimer[playerid] = Timer:-1;

        gplCurrentSound[playerid] = 0;
        IntroProcessCutscene2(playerid);
    }
}

timer IntroProcessCutscene[3000](playerid)
{
    new i = gplCurrentSound[playerid];
    if(i < sizeof(gCutsceneData))
    {
        gplCurrentSound[playerid]++;
        PlayerPlaySound(playerid, gCutsceneData[i][0][0], 0.0, 0.0, 0.0);
        ShowPlayerSubtitle(playerid, gCutsceneData[i][2]);
        ApplyAnimation(playerid, "PED", "WALK_gang1", 4.1, 1, 1, 1, 1, gCutsceneData[i][1][0], 1);
        defer IntroProcessCutscene[gCutsceneData[i][1][0]](playerid);
    }
    else if(i == sizeof(gCutsceneData))
    {
        SetCameraBehindPlayer(playerid);
        HidePlayerSubtitle(playerid);
        ClearAnimations(playerid);
    }
}

timer IntroProcessCutscene2[3000](playerid)
{
    new i = gplCurrentSound[playerid];
    if(i == 0)
    {
        gplCurrentSound[playerid]++;
        PlayerPlaySound(playerid, 43205, 0.0, 0.0, 0.0);
        ShowPlayerSubtitle(playerid, "Grove Street - Home");
        defer IntroProcessCutscene2[2000](playerid);
    }
    else if(i == 1)
    {
        gplCurrentSound[playerid]++;
        PlayerPlaySound(playerid, 43206, 0.0, 0.0, 0.0);
        ShowPlayerSubtitle(playerid, "At least it was before I fucked everything up.");
        defer IntroProcessCutscene2[3500](playerid);
    }
    else
        HidePlayerSubtitle(playerid);
}
