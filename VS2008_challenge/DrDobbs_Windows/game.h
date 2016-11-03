// /////////////////////////////////////////////////////////////////////////////
// DR DOBB'S CHALLENGES
//
// Filename       : game.cpp
// Date           : February 2008
//
// Description    : This file defines the CGame class responsible for handling
//                  level GUI and gameplay.  Once instantiated, Update()
//                  must be called within the main game loop while the game
//                  is active.  Stop() is used to determine if the game
//                  has been exited.  Victory() is used to determine if,
//                  after the game has exited, whether or not the player
//                  collected all the tokens.  In which case, GetScore()
//                  is used to obtain the time to complete the level.
//
// ///////////////////////////////////////////////////////////////////////////
#pragma once

// ///////////////////////////////////////////////////////////////////////////
// HEADERS (#include)
// ///////////////////////////////////////////////////////////////////////////
#include "global.h"
#include "sprite.h"
#include "level.h"
#include "text.h"
#include "entityPlayer.h"

// ///////////////////////////////////////////////////////////////////////////
// CLASS DEFINITION
// ///////////////////////////////////////////////////////////////////////////
class CGame {

   // ////////////////////////////////////////////////////////////////////////
   // PROTECTED/PRIVATE METHODS
   // ////////////////////////////////////////////////////////////////////////
   protected:
      // /////////////////////////////////////////////////////////////////////
      // VARIABLES
      CSprite*       pBackground;   // Game background
      CSprite*       pDimmer;       // Pause dimmer
      CText*         pPause;        // Pause text
      CText*         pTimer;        // Timer text
      CText*         pRecord;       // Best Time text

      CLevel*        pLevel;        // Current level
      CEntityPlayer* pPlayer;       // Current player
      int            character;     // Character type

      int   startTime;     // GetTicks() at start of game
      int   pauseTime;     // GetTicks() at pause game
      bool  pauseGame;     // Pause flag
      bool  stopGame;      // Stop flag
      bool  isVictory;     // Victory flag
      bool  isDead;        // Dead flag

      // /////////////////////////////////////////////////////////////////////
      // METHODS
      void updateTimer();
      void pause();
      void unpause();
      void restart();
      void loadLevel();

   // ////////////////////////////////////////////////////////////////////////
   // PUBLIC METHODS
   // ////////////////////////////////////////////////////////////////////////
   public:
      // /////////////////////////////////////////////////////////////////////
      // CONSTRUCTORS/DESTRUCTORS
      CGame(CLevel* pLevel, int character);
      ~CGame();

      // /////////////////////////////////////////////////////////////////////
      // METHODS
      void Update();
      bool Stop();
      bool Victory();
      int  GetScore();

};

// ///////////////////////////////////////////////////////////////////////////
// END OF CODE
// ///////////////////////////////////////////////////////////////////////////
