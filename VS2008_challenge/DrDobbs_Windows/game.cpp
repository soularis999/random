// /////////////////////////////////////////////////////////////////////////////
// DR DOBB'S CHALLENGES
//
// Filename       : game.cpp
// Date           : February 2008
//
// Description    : Refer to description in corresponding header.
//
// ///////////////////////////////////////////////////////////////////////////


// ///////////////////////////////////////////////////////////////////////////
// HEADERS (#include)
// ///////////////////////////////////////////////////////////////////////////
#include "game.h"
#include "input.h"

#include "entityToken.h"
#include "entityTerrainGlue.h"
#include "entityTerrainGrass.h"
#include "entityAIWalk.h"
#include "entityAIFly.h"

// ///////////////////////////////////////////////////////////////////////////
// CONSTRUCTORS AND DESTRUCTORS
// ///////////////////////////////////////////////////////////////////////////
CGame::CGame(CLevel* level, int charValue) {
   // Copy parameters into local members
   pLevel      = level;
   character   = charValue;

   // Create background sprite
   pBackground = new CSprite(0,0,SPRITE_TYPE_BACKGROUND);
   pBackground->AddImage("bg.png");
   pBackground->Unhide();

   // Create dimmer sprite for when game is on pause
   pDimmer = new CSprite(0,0,SPRITE_TYPE_DIMMER);
   pDimmer->AddImage("dimmer.png");

   // Load level entities
   loadLevel();

   // Create text for default game pause
   pPause = new CText(0,0,SCREEN_WIDTH,SCREEN_HEIGHT,
                     "Return to the Main Menu?  [Y/N]",
                     30,FW_BOLD,false,DT_CENTER|DT_VCENTER,0xFFFFFFFF);
   pPause->Hide();

   // Create text for timer
   pTimer = new CText(5,5,200,20,"Time Elapsed:  0:00:00",
                      20,FW_BOLD,false,DT_LEFT,0xFFFFFFFF);

   // Create text for best time
   pRecord = new CText(500,5,295,20,"Current Record:  None",20,FW_BOLD,false,DT_RIGHT,0xFFFFFFFF);
   if (pLevel->GetScore() != 0) {
      int csec = pLevel->GetScore()/10;
      int sec = csec/100;
      int min = sec/60;
      pRecord->SetText("Current Record:  %i:%02i.%02i",min,sec%60,csec%100);
   }

   // Initialize game timer by setting start time to current tick count
   startTime = GetTickCount();
   pauseTime = 0;

   // Initialize remaining members
   pauseGame      = false;
   stopGame       = false;
   isVictory      = false;
   isDead         = false;

   // Reset sprite global pause flag
   // NOTE:  This is just in case this wasn't done at the end of
   //        the last level (via CGame)
   CSprite::UnpauseAll();
}

CGame::~CGame() {
   // Release all instantiated entities
   CEntity::ReleaseAll();

   // Release remaining CGame-specific sprites and text
   delete pBackground;
   delete pDimmer;
   delete pPause;
   delete pTimer;
   delete pRecord;
}

// ///////////////////////////////////////////////////////////////////////////
// PROTECTED/PRIVATE METHODS
// ///////////////////////////////////////////////////////////////////////////
void CGame::updateTimer() {
   // Calculate elapsed time by comparing the current ticks to the start ticks
   int csec = (GetTickCount() - startTime)/10;
   int sec = csec/100;
   int min = sec/60;
   pTimer->SetText("Time Elapsed:  %i:%02i.%02i",min,sec%60,csec%100);
}

void CGame::pause() {
   // Select appropriate pause text
   if (isVictory) {
      pPause->SetText("VICTORY!!  Press space bar to continue.");
   } else if (isDead) {
      switch(pPlayer->GetState()) {
         case PLAYER_STATE_ATTACK0:
         case PLAYER_STATE_ATTACK1:
            pPause->SetText("You have been mauled by a bug.  Press the space bar to restart.");
            break;
         case PLAYER_STATE_OOB:
            pPause->SetText("You have fallen to your doom!!!  Press the space bar to restart.");
            break;
      }
   } else {
      pPause->SetText("Return to the Main Menu?  [Y/N]");
   }

   // When pausing the game, unhide the pause text and dimmer
   pPause->Unhide();
   pDimmer->Unhide();

   // Assert pauseGame to determine what type of inputs are active
   pauseGame = true;

   // Set pauseTime to the current ticks so startTime can be adjusted
   // when the game is unpaused such that time used during the pause
   // won't be included in the overall time elapsed
   pauseTime = GetTickCount();

   // Pause all sprites to ensure nothing is animating during the pause
   CSprite::PauseAll();
}

void CGame::unpause() {
   // When unpausing the game, hide the pause text and dimmer
   pPause->Hide();
   pDimmer->Hide();

   // Assert pauseGame to determine what type of inputs are active
   pauseGame = false;

   // Calculate how much elapsed before pause occured and subtract
   // from the current tick count to determine the new startTime
   startTime = GetTickCount() - (pauseTime - startTime);

   // Unpause all sprites to start animating again
   CSprite::UnpauseAll();
}

void CGame::restart() {
   // Release and reload level entities
   CEntity::ReleaseAll();
   loadLevel();

   // Restart counter
   startTime = GetTickCount();
   updateTimer();

   // Reset flags
   isDead = false;
}

void CGame::loadLevel() {
   CEntity* pEntity;
   bool endLeft  = false;
   bool endRight = false;
   int  x = 0;
   int  y = 0;
   int  tile = 0;
   int  ai = 0;

   // Initialize entity class
   CEntity::Init();

   // Loop through TY = [0,TILE_YCOUNT-1]
   for (int ty=0; ty<TILE_YCOUNT; ty++) {

      // Loop through TX = [0,TILE_XCOUNT-1]
      for (int tx=0; tx<TILE_XCOUNT; tx++) {

         // Calculate the XY center points (ie. +ENTITY_OFFSET)
         x = tx*TILE_WIDTH+ENTITY_OFFSETX;
         y = ty*TILE_HEIGHT+ENTITY_OFFSETY;

         // Retrieve selected tile from level
         tile = pLevel->GetTile(tx,ty);

         switch(tile) {
            // Terrain Tile
            case ENTITY_TYPE_GRASS:
            case ENTITY_TYPE_GLUE:
               // Determine if any terrain tiles exist to the immediate
               // left of the current tile or if it's flagged as a "left
               // endcap"
               endLeft = (tx == 0)
                           || ((pLevel->GetTile(tx-1,ty) != ENTITY_TYPE_GRASS)
                              && (pLevel->GetTile(tx-1,ty) != ENTITY_TYPE_GLUE));

               // Determine if any terrain tiles exist to the immediate
               // right of the current tile or if it's flagged as a "right
               // endcap"
               endRight = (tx == TILE_XCOUNT-1)
                           || ((pLevel->GetTile(tx+1,ty) != ENTITY_TYPE_GRASS)
                              && (pLevel->GetTile(tx+1,ty) != ENTITY_TYPE_GLUE));

               // Once endcap flags are set, create the appropriate terrain
               if (tile == ENTITY_TYPE_GRASS) {
                  pEntity = new CEntityTerrainGrass(x,y,endLeft,endRight);
               } else {
                  pEntity = new CEntityTerrainGlue(x,y,endLeft,endRight);
               }
               break;

            // Token Tile
            case ENTITY_TYPE_TOKEN:
               pEntity = new CEntityToken(x,y);
               break;

            // Flying AI Tile
            case ENTITY_TYPE_AIFLY:
               pEntity = new CEntityAIFly(x,y,pLevel->GetAIDirection(ai));
               ai++;
               break;

            // Walking AI Tile
            case ENTITY_TYPE_AIWALK:
               pEntity = new CEntityAIWalk(x,y,pLevel->GetAIDirection(ai));
               ai++;
               break;

            // Player Tile
            case ENTITY_TYPE_PLAYER:
               pPlayer = new CEntityPlayer(x,y,character);

               // Assign pointer to player entity to pEntity for
               // use below to adjust Y to be tile-aligned.
               pEntity = pPlayer;
               break;
         }

         // Some entities consume more than the space of a single tile.  For
         // this reason, Y is adjusted using collisionY such that the bottom
         // edge aligns with the top edge of the tile below.
         if ((tile == ENTITY_TYPE_AIFLY)
               || (tile == ENTITY_TYPE_AIWALK)
               || (tile == ENTITY_TYPE_PLAYER)) {
            pEntity->Move(x, y - (pEntity->GetCollisionY() - TILE_HEIGHT/2));
         }
      }
   }

   // Initialize static token members (particularly the pointer to the player
   // entity.
   CEntityToken::Init(pPlayer);
}

// ///////////////////////////////////////////////////////////////////////////
// PUBLIC METHODS
// ///////////////////////////////////////////////////////////////////////////
void CGame::Update() {

#if USE_DEBUG == 1
   // Check for LEFT/RIGHT running keys (right-run has precidence)
   // NOTE: This is only available when USE_DEBUG = 1
   if (CInput::KeyPressed(DIK_Q)) pPlayer->AdjustPhysics(-1,0,0,0,0,0.0,0.0,0.0,0);
   else if (CInput::KeyPressed(DIK_W)) pPlayer->AdjustPhysics(1,0,0,0,0,0.0,0.0,0.0,0);
   else if (CInput::KeyPressed(DIK_E)) pPlayer->AdjustPhysics(0,-1,0,0,0,0.0,0.0,0.0,0);
   else if (CInput::KeyPressed(DIK_R)) pPlayer->AdjustPhysics(0,1,0,0,0,0.0,0.0,0.0,0);
   else if (CInput::KeyPressed(DIK_T)) pPlayer->AdjustPhysics(0,0,-1,0,0,0.0,0.0,0.0,0);
   else if (CInput::KeyPressed(DIK_Y)) pPlayer->AdjustPhysics(0,0,1,0,0,0.0,0.0,0.0,0);
   else if (CInput::KeyPressed(DIK_U)) pPlayer->AdjustPhysics(0,0,0,-1,0,0.0,0.0,0.0,0);
   else if (CInput::KeyPressed(DIK_I)) pPlayer->AdjustPhysics(0,0,0,1,0,0.0,0.0,0.0,0);
   else if (CInput::KeyPressed(DIK_1)) pPlayer->AdjustPhysics(0,0,0,0,0,0.0,0.0,-0.1f,0);
   else if (CInput::KeyPressed(DIK_2)) pPlayer->AdjustPhysics(0,0,0,0,0,0.0,0.0,0.1f,0);
   else if (CInput::KeyPressed(DIK_3)) pPlayer->AdjustPhysics(0,0,0,0,0,0.0,0.0,0.0,-1);
   else if (CInput::KeyPressed(DIK_4)) pPlayer->AdjustPhysics(0,0,0,0,0,0.0,0.0,0.0,1);
   else if (CInput::KeyPressed(DIK_5)) pPlayer->AdjustPhysics(0,0,0,0,-1,0.0,0.0,0.0,0);
   else if (CInput::KeyPressed(DIK_6)) pPlayer->AdjustPhysics(0,0,0,0,1,0.0,0.0,0.0,0);
   else if (CInput::KeyPressed(DIK_7)) pPlayer->AdjustPhysics(0,0,0,0,0,-0.1f,0.0,0.0,0);
   else if (CInput::KeyPressed(DIK_8)) pPlayer->AdjustPhysics(0,0,0,0,0,0.1f,0.0,0.0,0);
   else if (CInput::KeyPressed(DIK_9)) pPlayer->AdjustPhysics(0,0,0,0,0,0.0,-0.1f,0.0,0);
   else if (CInput::KeyPressed(DIK_0)) pPlayer->AdjustPhysics(0,0,0,0,0,0.0,0.1f,0.0,0);
#endif

   // Handle normal gameplay when not paused
   if (!pauseGame) {

      // Update timer
      updateTimer();

      // Update all entities
      CEntity::UpdateAll();

      // If all tokens have been collected, end level
      if (CEntity::TokensCollected()) {
         isVictory = true;
         pause();

      // Check for ESC to pause the game (and return to the menu)
      } else if (CInput::KeyPressed(DIK_ESCAPE)) {
         pause();

      // Check for 'R' to restart the level
      } else if (CInput::KeyPressed(DIK_R)) {
         restart();

      // Check if player is still alive...
      } else if (pPlayer->GetState() == PLAYER_STATE_NORMAL) {

         // Check for LEFT/RIGHT running keys (right-run has precidence)
         if (CInput::KeyDown(DIK_RIGHT))     pPlayer->Run(false);
         else if (CInput::KeyDown(DIK_LEFT)) pPlayer->Run(true);

         // Check for UP jump key
         if (CInput::KeyPressed(DIK_UP)) pPlayer->Jump();

         // Check for DOWN drop key
         if (CInput::KeyDown(DIK_DOWN))  pPlayer->Drop();

         // Check for LMB to grab selected token
         if (CInput::MouseButtonPressed(DIM_LB)) CEntityToken::HandleGrab();

      // Otherwise, player must be dead (state != PLAYER_STATE_NORMAL)
      } else {
         // If dead and smoke finished animating, end level (to restart)
         if (pPlayer->IsDead()) {
            isDead = true;
            pause();
         }
      }

   // Handle inputs when game is paused
   } else {
      // Check for SPACEBAR if game paused after VICTORY (to main menu)
      if (isVictory) {
         if (CInput::KeyPressed(DIK_SPACE)) {
            stopGame = true;
         }

      // Check for SPACEBAR if game paused after DEATH (to restart)
      } else if (isDead) {
         if (CInput::KeyPressed(DIK_SPACE)) {
            unpause();
            restart();
         }

      // Otherwise, check for Y/N if game paused after ESCAPE
      } else {
         // If Y to return to main menu, adjust startTime first, then stop
         if (CInput::KeyPressed(DIK_Y)) {
            startTime = GetTickCount() - (pauseTime - startTime);
            stopGame = true;

         // If N to return to game, unpause
         } else if (CInput::KeyPressed(DIK_N)) {
            unpause();
         }
      }
   }

}

bool CGame::Stop() { return stopGame; }
bool CGame::Victory() { return isVictory; }

// Score is the difference between the last time the game was
// paused (on the victory screen) and the recorded startTime.
int CGame::GetScore() { return (pauseTime - startTime); }

// ///////////////////////////////////////////////////////////////////////////
// END OF CODE
// ///////////////////////////////////////////////////////////////////////////
