/*******************************************************************************
* FILENAME :        modules/game/clock.pwn
*
* DESCRIPTION :
*       Synchronize the clock to all the players.
*
* NOTES :
*       -
*
*/

#include <YSI\y_hooks>

//------------------------------------------------------------------------------

// Server start time - 00:00
new gCurrentHour = 00;
new gCurrentMinute = 00;

new Text:gClockTD;
new bool:gplClockLoaded[MAX_PLAYERS];

//------------------------------------------------------------------------------

hook OnPlayerDisconnect(playerid, reason)
{
    gplClockLoaded[playerid] = false;
    return 1;
}

//------------------------------------------------------------------------------

hook OnPlayerSpawn(playerid)
{
    if(!gplClockLoaded[playerid])
    {
        gplClockLoaded[playerid] = true;
        TextDrawShowForPlayer(playerid, gClockTD);
    }
    return 1;
}

//------------------------------------------------------------------------------

stock ShowPlayerClock(playerid)
{
    TextDrawShowForPlayer(playerid, gClockTD);
}

//------------------------------------------------------------------------------

stock HidePlayerClock(playerid)
{
    TextDrawHideForPlayer(playerid, gClockTD);
}

//------------------------------------------------------------------------------

hook OnGameModeInit()
{
    gClockTD = TextDrawCreate(545.000000, 20.000000, "03:00");
    TextDrawBackgroundColor(gClockTD, 255);
    TextDrawFont(gClockTD, 3);
    TextDrawLetterSize(gClockTD, 0.6, 2.0);
    TextDrawColor(gClockTD, 0xc3c3c3ff);
    TextDrawBoxColor(gClockTD, 0x000000ff);
    TextDrawSetOutline(gClockTD, 2);
    TextDrawSetShadow(gClockTD, 0);
    TextDrawSetProportional(gClockTD, 1);
    return 1;
}

//------------------------------------------------------------------------------

stock GetServerTime(&hour, &minute)
{
    hour = gCurrentHour;
    minute = gCurrentMinute;
}

//------------------------------------------------------------------------------

task UpdateServerClock[1000]()
{
    gCurrentMinute++;
    if(gCurrentMinute > 59)
    {
        gCurrentHour++;
        gCurrentMinute = 0;
        if(gCurrentHour > 23)
            gCurrentHour = 0;
    }

    new sCT[12];
    format(sCT, sizeof(sCT), "%02d:%02d", gCurrentHour, gCurrentMinute);
    TextDrawSetString(gClockTD, sCT);

    foreach(new i: Player)
        SetPlayerTime(i, gCurrentHour, gCurrentMinute);
}
