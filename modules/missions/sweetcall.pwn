/*******************************************************************************
* FILENAME :        modules/missions/sweetcall.pwn
*
* DESCRIPTION :
*       After first call sweet calls CJ.
*
* NOTES :
*       -
*/

#include <YSI\y_hooks>

static gplCurrentSound[MAX_PLAYERS] = {-1, ...};
static bool:gplIsPhoneRinging[MAX_PLAYERS];

static gCutsceneData[][][] =
{
    {29098, 1500, !"Sweet, hey, wassup?"},
    {29099, 2000, !"Thought I'd explain some shit."},
    {29100, 2500, !"Since you been away, shit has changed 'round here."},
    {29101, 2150, !"Grove Street Families ain't big no more."},
    {29102, 4200, !"Seville Boulevard Families and Temple Drive Families are beefing, and split with the Grove."},
    {29103, 4200, !"Now we so busy set tripping, Ballas and Vagos have taken over, so watch yo'self out there."},
    {29104, 3100, !"Just because theyre wearing greens, dont mean theyre allies. Copy?"},
    {29105, 1500, !"Yeah, I hear you."},
    {29106, 1500, !"Thanks for the heads up."},
    {29107, 1500, !"Don't mention it."}
};

hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
    if((newkeys & KEY_YES) && gplIsPhoneRinging[playerid])
    {
        gplCurrentSound[playerid] = 0;
        gplIsPhoneRinging[playerid] = false;
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_USECELLPHONE);
        HidePlayerInfoMessage(playerid);
        defer ProcessPhoneCutscene(playerid);
    }
    return 1;
}

hook OnPlayerSpawn(playerid)
{
    if(GetPlayerCurrentMission(playerid) == MISSION_SWEET_CALL && gplIsPhoneRinging[playerid] == false)
        defer RingPlayerPhone(playerid);
    return 1;
}

hook OnPlayerDisconnect(playerid, reason)
{
    gplCurrentSound[playerid] = -1;
    gplIsPhoneRinging[playerid] = false;
    return 1;
}

timer ProcessPhoneCutscene[1000](playerid)
{
    new i = gplCurrentSound[playerid];
    if(i < sizeof(gCutsceneData))
    {
        gplCurrentSound[playerid]++;
        PlayerPlaySound(playerid, gCutsceneData[i][0][0], 0.0, 0.0, 0.0);
        ShowPlayerSubtitle(playerid, gCutsceneData[i][2]);
        defer ProcessPhoneCutscene[gCutsceneData[i][1][0]](playerid);
    }
    else if(i == sizeof(gCutsceneData))
    {
        HidePlayerSubtitle(playerid);
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_STOPUSECELLPHONE);
        SetPlayerCurrentMission(playerid, GetPlayerCurrentMission(playerid) + Mission:1);
    }
}

timer RingPlayerPhone[3000](playerid)
{
    if(IsPlayerInAnyVehicle(playerid))
    {
        defer RingPlayerPhone(playerid);
        return 1;
    }
    else if(gplCurrentSound[playerid] == -1)
    {
        defer RingPlayerPhone(playerid);
        gplIsPhoneRinging[playerid] = true;
        PlayerPlaySound(playerid, 20600, 0.0, 0.0, 0.0);
        ShowPlayerInfoMessage(playerid, "Press Y to answer de phone.");
    }
    return 1;
}
