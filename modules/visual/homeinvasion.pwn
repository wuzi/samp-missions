/*******************************************************************************
* FILENAME :        modules/visual/homeinvasion.pwn
*
* DESCRIPTION :
*       Home Invasion text rendering functions.
*
* NOTES :
*       -
*/

#include <YSI\y_hooks>

static PlayerText:UI[MAX_PLAYERS][2];
static PlayerBar:bUI[MAX_PLAYERS];
static bool:isBarVisible[MAX_PLAYERS];

//------------------------------------------------------------------------------

hook OnPlayerDisconnect(playerid, reason)
{
    for(new i = 0; i < sizeof(UI[]); i++)
        UI[playerid][i] = PlayerText:0;
    return 1;
}

//------------------------------------------------------------------------------

ShowPlayerColonelUI(playerid)
{
    if(UI[playerid][0] != PlayerText:0)
        return 1;

    bUI[playerid] = CreatePlayerProgressBar(playerid, 547.000000, 151.000000, 63.000000, 6.000000, 0xA9C4E4FF);

    UI[playerid][0] = CreatePlayerTextDraw(playerid, 493.000000, 148.000000, "noise");
    PlayerTextDrawBackgroundColor(playerid, UI[playerid][0], 255);
    PlayerTextDrawFont(playerid, UI[playerid][0], 2);
    PlayerTextDrawLetterSize(playerid, UI[playerid][0], 0.229999, 1.000000);
    PlayerTextDrawColor(playerid, UI[playerid][0], -1446714113);
    PlayerTextDrawSetOutline(playerid, UI[playerid][0], 0);
    PlayerTextDrawSetProportional(playerid, UI[playerid][0], 1);
    PlayerTextDrawSetShadow(playerid, UI[playerid][0], 1);
    PlayerTextDrawSetSelectable(playerid, UI[playerid][0], 0);

    new hour, minute;
    GetServerTime(hour, minute);
    hour = 4 - hour;
    minute = 59 - minute;

    new output[27];
    format(output, sizeof(output), "Daylight           %02d:%02d", hour, minute);
    UI[playerid][1] = CreatePlayerTextDraw(playerid, 484.000000, 132.000000, output);
    PlayerTextDrawBackgroundColor(playerid, UI[playerid][1], 255);
    PlayerTextDrawFont(playerid, UI[playerid][1], 2);
    PlayerTextDrawLetterSize(playerid, UI[playerid][1], 0.260000, 1.300000);
    PlayerTextDrawColor(playerid, UI[playerid][1], -1);
    PlayerTextDrawSetOutline(playerid, UI[playerid][1], 0);
    PlayerTextDrawSetProportional(playerid, UI[playerid][1], 1);
    PlayerTextDrawSetShadow(playerid, UI[playerid][1], 1);
    PlayerTextDrawSetSelectable(playerid, UI[playerid][1], 0);

    PlayerTextDrawShow(playerid, UI[playerid][1]);
    return 1;
}

//------------------------------------------------------------------------------

ShowPlayerColonelNoiseBar(playerid)
{
    isBarVisible[playerid] = true;
    PlayerTextDrawShow(playerid, UI[playerid][0]);
    ShowPlayerProgressBar(playerid, bUI[playerid]);
    return 1;
}

//------------------------------------------------------------------------------

HidePlayerColonelNoiseBar(playerid)
{
    isBarVisible[playerid] = false;
    PlayerTextDrawHide(playerid, UI[playerid][0]);
    HidePlayerProgressBar(playerid, bUI[playerid]);
    return 1;
}
//------------------------------------------------------------------------------

UpdatePlayerColonelNoiseBar(playerid, Float:value)
{
    if(isBarVisible[playerid] == false)
        return 1;
    SetPlayerProgressBarValue(playerid, bUI[playerid], value);
    return 1;
}

//------------------------------------------------------------------------------

HidePlayerColonelUI(playerid)
{
    if(UI[playerid][0] == PlayerText:0)
        return 1;

    for(new i = 0; i < sizeof(UI[]); i++)
    {
        PlayerTextDrawDestroy(playerid, UI[playerid][i]);
        UI[playerid][i] = PlayerText:0;
    }
    DestroyPlayerProgressBar(playerid, bUI[playerid]);
    isBarVisible[playerid] = false;
    return 1;
}

//------------------------------------------------------------------------------

UpdatePlayerColonelClock(playerid, hour, minute)
{
    if(UI[playerid][1] == PlayerText:0)
        return 1;
    new output[27];
    format(output, sizeof(output), "Daylight           %02d:%02d", hour, minute);
    PlayerTextDrawSetString(playerid, UI[playerid][1], output);
    return 1;
}
