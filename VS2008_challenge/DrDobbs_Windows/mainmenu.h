// /////////////////////////////////////////////////////////////////////////////
// DR DOBB'S CHALLENGES
//
// Filename       : mainmenu.cpp
// Date           : February 2008
//
// Description    : This file defines the CMainMenu class responsible for
//                  handling the Main Menu GUI.  Once instantiated, Update()
//                  must be called within the main game loop while the menu
//                  is active.  Start() is used to determine if a level
//                  has been selected for play.  Quit() is used to determine
//                  if the QUIT button or ESC key has been pressed to exit
//                  the application.
//
//                  GetLevel() and GetPlayer() are used to pass the selected
//                  level and player to CGame when a level is selected for
//                  play.
//
//                  Hide() and Unhide() are used to hide/unhide the main
//                  menu between level play, rather than deleting the
//                  menu each time.
//
// ///////////////////////////////////////////////////////////////////////////
#pragma once

// ///////////////////////////////////////////////////////////////////////////
// HEADERS (#include)
// ///////////////////////////////////////////////////////////////////////////
#include "global.h"
#include "sprite.h"
#include "text.h"
#include "sound.h"


// ///////////////////////////////////////////////////////////////////////////
// CLASS DEFINITION
// ///////////////////////////////////////////////////////////////////////////
class CMainMenu {

   // ////////////////////////////////////////////////////////////////////////
   // PROTECTED/PRIVATE METHODS
   // ////////////////////////////////////////////////////////////////////////
   protected:
      // /////////////////////////////////////////////////////////////////////
      // STATIC COMPONENTS

      // /////////////////////////////////////////////////////////////////////
      // VARIABLES
      CSprite*       pBackground;      // Main Menu background
      CSprite*       pSelected[26];    // All selected GUI controls
      CSprite*       pHighlight[26];   // All highlighted GUI controls
      CSound*        pRollover;        // GUI control rollover sound
      CSound*        pClick;           // GUI control click sound
      CText*         pLevel[20];       // Text level IDs
      CText*         pScore[20];       // Text level scores
      CText*         pVersion;         // Text version

      int highlighted;     // Currently highlighted GUI control
      int selectedLevel;   // Currently selected level
      int selectedPlayer;  // Currently selected player

      bool clickLeft;      // Used for "active-low" button pressing

      bool startGame;      // Start level flag
      bool quitGame;       // Quit application flag

      // /////////////////////////////////////////////////////////////////////
      // METHODS
      void handleMouse();


   // ////////////////////////////////////////////////////////////////////////
   // PUBLIC METHODS
   // ////////////////////////////////////////////////////////////////////////
   public:
      // /////////////////////////////////////////////////////////////////////
      // CONSTRUCTORS/DESTRUCTORS
      CMainMenu();
      ~CMainMenu();


      // /////////////////////////////////////////////////////////////////////
      // METHODS
      void Update();

      bool Start();
      bool Quit();

      int GetLevel();
      int GetPlayer();

      void Hide();
      void Unhide();
};

// ///////////////////////////////////////////////////////////////////////////
// END OF CODE
// ///////////////////////////////////////////////////////////////////////////
