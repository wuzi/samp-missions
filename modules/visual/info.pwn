/*******************************************************************************
* FILENAME :        modules/visual/cutscene.pwn
*
* DESCRIPTION :
*       Create functions to show info box as in singleplayer.
*
* NOTES :
*       -
*
*/

//------------------------------------------------------------------------------

#include <YSI\y_hooks>

static PlayerText:gplTextDraw[MAX_PLAYERS] = {PlayerText:INVALID_TEXT_DRAW, ...};

//------------------------------------------------------------------------------

ShowPlayerInfoMessage(playerid, message[])
{
    if(gplTextDraw[playerid] != PlayerText:INVALID_TEXT_DRAW)
    {
        PlayerTextDrawSetString(playerid, gplTextDraw[playerid], message);
        return 1;
    }

    gplTextDraw[playerid] = CreatePlayerTextDraw(playerid, 25.000000, 106.000000, message);
    PlayerTextDrawBackgroundColor(playerid, gplTextDraw[playerid], -256);
    PlayerTextDrawFont(playerid, gplTextDraw[playerid], 1);
    PlayerTextDrawLetterSize(playerid, gplTextDraw[playerid], 0.420000, 1.600000);
    PlayerTextDrawColor(playerid, gplTextDraw[playerid], -858993409);
    PlayerTextDrawSetOutline(playerid, gplTextDraw[playerid], 1);
    PlayerTextDrawSetProportional(playerid, gplTextDraw[playerid], 1);
    PlayerTextDrawUseBox(playerid, gplTextDraw[playerid], 1);
    PlayerTextDrawBoxColor(playerid, gplTextDraw[playerid], 0x00000047);
    PlayerTextDrawTextSize(playerid, gplTextDraw[playerid], 168.000000, -3.000000);
    PlayerTextDrawShow(playerid, gplTextDraw[playerid]);
    return 1;
}

//------------------------------------------------------------------------------

HidePlayerInfoMessage(playerid)
{
    if(gplTextDraw[playerid] == PlayerText:INVALID_TEXT_DRAW)
        return 1;

    PlayerTextDrawDestroy(playerid, gplTextDraw[playerid]);
    gplTextDraw[playerid] = PlayerText:INVALID_TEXT_DRAW;
    return 1;
}

//------------------------------------------------------------------------------

hook OnPlayerDisconnect(playerid, reason)
{
    if(gplTextDraw[playerid] != PlayerText:INVALID_TEXT_DRAW)
        gplTextDraw[playerid] = PlayerText:INVALID_TEXT_DRAW;
    return 1;
}
