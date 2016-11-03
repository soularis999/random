// /////////////////////////////////////////////////////////////////////////////
// DR DOBB'S CHALLENGES
//
// Filename       : entityPlayer.cpp
// Date           : February 2008
//
// Description    : This file defines the CEntityPlayer class for the user's
//                  controllable avatar.  Once instantiated, the primary
//                  methods for control are Jump(), Run() and Drop().  The
//                  game loop (via CGame) must check IsDead() to determine
//                  if the player has died.
//
// ///////////////////////////////////////////////////////////////////////////
#pragma once

// ///////////////////////////////////////////////////////////////////////////
// HEADERS (#include)
// ///////////////////////////////////////////////////////////////////////////
#include "entity.h"
#include "text.h"

// ///////////////////////////////////////////////////////////////////////////
// CONSTANTS (#define)
// ///////////////////////////////////////////////////////////////////////////

// Character types
#define CHARACTER_MUMMY             0
#define CHARACTER_PIRATE            1
#define CHARACTER_DOBB              2
#define CHARACTER_COWBOY            3
#define CHARACTER_SALAMANDER        4

// Player states
#define PLAYER_STATE_NORMAL         0
#define PLAYER_STATE_ATTACK0        1
#define PLAYER_STATE_ATTACK1        2
#define PLAYER_STATE_OOB            3


// ///////////////////////////////////////////////////////////////////////////
// CLASS DEFINITION
// ///////////////////////////////////////////////////////////////////////////
class CEntityPlayer : public CEntity {

   // ////////////////////////////////////////////////////////////////////////
   // PROTECTED/PRIVATE METHODS
   // ////////////////////////////////////////////////////////////////////////
   protected:
      // /////////////////////////////////////////////////////////////////////
      // VARIABLES
      CText*   pLocation;
      CText*   pCharacter;

      CSprite* pSpriteLRun;
      CSprite* pSpriteRRun;
      CSprite* pSpriteLStand;
      CSprite* pSpriteRStand;
      CSprite* pSpriteLJump;
      CSprite* pSpriteRJump;
      CSprite* pSpriteLDrop;
      CSprite* pSpriteRDrop;
      CSprite* pSpriteSmoke;
      CSprite* pSpriteArrow;

      CSound*  pSoundRun[3];
      CSound*  pSoundJump;
      CSound*  pSoundLand;
      CSound*  pSoundExplode;

      int   soundRunDelay;
      int   soundRun;
      int   jumpDelay;
      int   jumpCount;
      bool  onGround;
      bool  isLeft;
      bool  isDropping;
      int   character;
      int   state;

      int   speedGrass;
      int   speedGlue;
      int   soundGrass;
      int   soundGlue;
      int   gravityDelay;
      float gravityAccel;
      float gravityMax;
      float jumpInit;
      int   jumpMax;

      // /////////////////////////////////////////////////////////////////////
      // METHODS
      void loadResources();
      void unloadResources();

      void checkDeath();
      void handleMovement();
      void handleSprite();
      bool handleCollision(float* yDiff);
      bool collisionDetected(int xVal, int yVal);

      void update();

   // ////////////////////////////////////////////////////////////////////////
   // PUBLIC METHODS
   // ////////////////////////////////////////////////////////////////////////
   public:
      // /////////////////////////////////////////////////////////////////////
      // CONSTRUCTORS/DESTRUCTORS
      CEntityPlayer(int xVal, int yVal, int character);
      ~CEntityPlayer();

      // /////////////////////////////////////////////////////////////////////
      // METHODS
      void Jump();
      void Run(bool left);
      void Drop();

      bool IsDead();
      int  GetState();

      // Used to tweak the character-specific values
      void AdjustPhysics(int dSpeedGrass, int dSpeedGlue,
                         int dSoundGrass, int dSoundGlue,
                         int dGravDelay, float dGravAccel, float dGravMax,
                         float dJumpInit, int dJumpMax);

};

// ///////////////////////////////////////////////////////////////////////////
// END OF CODE
// ///////////////////////////////////////////////////////////////////////////