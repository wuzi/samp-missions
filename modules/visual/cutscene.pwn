/*******************************************************************************
* FILENAME :        modules/visual/cutscene.pwn
*
* DESCRIPTION :
*       Create functions to show black bars at top and bottom of player's screen
*
* NOTES :
*       -
*
*/

//------------------------------------------------------------------------------

#include <YSI\y_hooks>

static Text:TOP;
static Text:BOTTOM;

//------------------------------------------------------------------------------

stock ShowPlayerCutsceneBars(playerid)
{
    TextDrawShowForPlayer(playerid, TOP);
    TextDrawShowForPlayer(playerid, BOTTOM);
}
//------------------------------------------------------------------------------

stock HidePlayerCutsceneBars(playerid)
{
    TextDrawHideForPlayer(playerid, TOP);
    TextDrawHideForPlayer(playerid, BOTTOM);
}

//------------------------------------------------------------------------------

hook OnGameModeInit()
{
    TOP = TextDrawCreate(320.000000, 1.000000, "_");
	TextDrawAlignment(TOP, 2);
	TextDrawBackgroundColor(TOP, 255);
	TextDrawFont(TOP, 1);
	TextDrawLetterSize(TOP, 0.500000, 8.000000);
	TextDrawColor(TOP, -1);
	TextDrawSetOutline(TOP, 0);
	TextDrawSetProportional(TOP, 1);
	TextDrawSetShadow(TOP, 1);
	TextDrawUseBox(TOP, 1);
	TextDrawBoxColor(TOP, 255);
	TextDrawTextSize(TOP, 0.000000, -660.000000);

	BOTTOM = TextDrawCreate(320.000000, 381.000000, "_");
	TextDrawAlignment(BOTTOM, 2);
	TextDrawBackgroundColor(BOTTOM, 255);
	TextDrawFont(BOTTOM, 1);
	TextDrawLetterSize(BOTTOM, 0.500000, 8.000000);
	TextDrawColor(BOTTOM, -1);
	TextDrawSetOutline(BOTTOM, 0);
	TextDrawSetProportional(BOTTOM, 1);
	TextDrawSetShadow(BOTTOM, 1);
	TextDrawUseBox(BOTTOM, 1);
	TextDrawBoxColor(BOTTOM, 255);
	TextDrawTextSize(BOTTOM, 0.000000, -660.000000);
    return 1;
}
