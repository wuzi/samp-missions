/*******************************************************************************
* FILENAME :        modules/visual/subtitles.pwn
*
* DESCRIPTION :
*       Create, destroy and show subtitles for players.
*
* NOTES :
*       -
*
*/

//------------------------------------------------------------------------------

#include <YSI\y_hooks>

//------------------------------------------------------------------------------

static PlayerText:gpTextDrawSub[MAX_PLAYERS] = {PlayerText:INVALID_TEXT_DRAW, ...};

//------------------------------------------------------------------------------

ShowPlayerSubtitle(playerid, text[], showtime = 0)
{
    if(gpTextDrawSub[playerid] != PlayerText:INVALID_TEXT_DRAW)
    {
        PlayerTextDrawSetString(playerid, gpTextDrawSub[playerid], text);
        return 1;
    }

    gpTextDrawSub[playerid] = CreatePlayerTextDraw(playerid, 325.666625, 425.563018, text);
    PlayerTextDrawLetterSize(playerid, gpTextDrawSub[playerid], 0.400000, 1.600000);
    PlayerTextDrawAlignment(playerid, gpTextDrawSub[playerid], 2);
    PlayerTextDrawColor(playerid, gpTextDrawSub[playerid], 0xe8e8e8ff);
    PlayerTextDrawSetShadow(playerid, gpTextDrawSub[playerid], 1);
    PlayerTextDrawSetOutline(playerid, gpTextDrawSub[playerid], 0);
    PlayerTextDrawBackgroundColor(playerid, gpTextDrawSub[playerid], 255);
    PlayerTextDrawFont(playerid, gpTextDrawSub[playerid], 1);
    PlayerTextDrawSetProportional(playerid, gpTextDrawSub[playerid], 1);
    PlayerTextDrawSetShadow(playerid, gpTextDrawSub[playerid], 1);
    PlayerTextDrawShow(playerid, gpTextDrawSub[playerid]);

    if(showtime > 0)
        defer HidePlayerSubtitle[showtime](playerid);
    return 1;
}

//------------------------------------------------------------------------------

timer HidePlayerSubtitle[6000](playerid)
{
    if(gpTextDrawSub[playerid] == PlayerText:INVALID_TEXT_DRAW)
        return 1;

    PlayerTextDrawDestroy(playerid, gpTextDrawSub[playerid]);
    gpTextDrawSub[playerid] = PlayerText:INVALID_TEXT_DRAW;
    return 1;
}

//------------------------------------------------------------------------------

hook OnPlayerDisconnect(playerid, reason)
{
    gpTextDrawSub[playerid] = PlayerText:INVALID_TEXT_DRAW;
    return 1;
}
