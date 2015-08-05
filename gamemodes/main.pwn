/*******************************************************************************
* FILENAME :        main.pwn
*
* DESCRIPTION :
*       Includes all modules, includes and constants.
*
* NOTES :
*       This file is not intended to handle player's processes.
*
* THANKS :
*       SA:MP Team past, present and future - SA:MP.
*       Y_Less - YSI.
*
*/

// Required to be at the top
#include <a_samp>

//------------------------------------------------------------------------------

// Script version
#define SCRIPT_VERSION_MAJOR							0
#define SCRIPT_VERSION_MINOR							1
#define SCRIPT_VERSION_PATCH							0
#define SCRIPT_VERSION_NAME								"GTA:Missions"

//------------------------------------------------------------------------------

// Libraries
#include <YSI\y_hooks>

//------------------------------------------------------------------------------

hook OnGameModeInit()
{
	print("\n\n============================================================\n");
	print("Initializing...\n");
    SetGameModeText(SCRIPT_VERSION_NAME " " #SCRIPT_VERSION_MAJOR "." #SCRIPT_VERSION_MINOR "." #SCRIPT_VERSION_PATCH);

	// Gamemode settings
	ShowNameTags(1);
	UsePlayerPedAnims();
	DisableInteriorEnterExits(); // For server-sided entrances
	SetNameTagDrawDistance(40.0);
	EnableStuntBonusForAll(false);
	return 1;
}

//------------------------------------------------------------------------------

// Modules

//------------------------------------------------------------------------------

main()
{
	printf("\n\n%s %d.%d.%d initialiazed.\n", SCRIPT_VERSION_NAME, SCRIPT_VERSION_MAJOR, SCRIPT_VERSION_MINOR, SCRIPT_VERSION_PATCH);
	print("============================================================\n");
}
