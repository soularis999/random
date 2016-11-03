// /////////////////////////////////////////////////////////////////////////////
// DR DOBB'S CHALLENGES
//
// Filename       : entityAIWalk.cpp
// Date           : February 2008
//
// Description    : Refer to description in corresponding header.
//
// ///////////////////////////////////////////////////////////////////////////


// ///////////////////////////////////////////////////////////////////////////
// HEADERS (#include)
// ///////////////////////////////////////////////////////////////////////////
#include "entityAIWalk.h"

// ///////////////////////////////////////////////////////////////////////////
// CONSTANTS (#define)
// ///////////////////////////////////////////////////////////////////////////
#define AIWALK_CX       32
#define AIWALK_CY       16
#define AIWALK_SPEED    4

// ///////////////////////////////////////////////////////////////////////////
// CONSTRUCTORS AND DESTRUCTORS
// ///////////////////////////////////////////////////////////////////////////
CEntityAIWalk::CEntityAIWalk(int xVal, int yVal, int dir) : CEntityAI(xVal,yVal,ENTITY_TYPE_AIWALK,AIWALK_CX,AIWALK_CY) {
   // Create left and right facing sprites
   pSpriteLeft = new CSprite(32,13,SPRITE_TYPE_AI,1);
   pSpriteLeft->AddImage("BeetleLWalk-",0,7,".png");
   pSpriteRight = new CSprite(32,13,SPRITE_TYPE_AI,1);
   pSpriteRight->AddImage("BeetleRWalk-",0,7,".png");

   // Initialize direction to specified directon
   // NOTE: If not DIR_LEFT, then assume DIR_RIGHT
   direction = (dir != DIR_LEFT) ? DIR_RIGHT : dir;

   // Initialize active sprite to left-facing
   pSpriteActive = pSpriteLeft;
}

CEntityAIWalk::~CEntityAIWalk() {
}

// ///////////////////////////////////////////////////////////////////////////
// PROTECTED/PRIVATE METHODS
// ///////////////////////////////////////////////////////////////////////////
void CEntityAIWalk::handleCollision() {
   int tx;
   int ty;
   bool collision = false;

   // If moving leftward, check if direction change is appropriate
   if (direction == DIR_LEFT) {
      // Calculate bottom-left tile
      tx = GetTX(TILE_LOW);
      ty = GetTY(TILE_HIGH);

      // Check if on leftward tile-boundary and one of the following is TRUE:
      //    (a)  On left edge of screen (tx = 0)
      //    (b)  No terrain exists down and to the left of the current tile
      //    (c)  Terrain exists directly to the left of the current tile
      if (onTileBoundary(DIR_LEFT,AIWALK_SPEED)
            && ((tx == 0)
               || (GetTerrain(tx-1,ty+1) == ENTITY_TYPE_NONE)
               || (GetTerrain(tx-1,ty) != ENTITY_TYPE_NONE))) {
         collision = true;
      }

   // Otherwise, if moving rightward, check if direction change is appropriate
   } else {
      // Calculate bottom-right tile
      tx = GetTX(TILE_HIGH);
      ty = GetTY(TILE_HIGH);

      // Check if on leftward tile-boundary and one of the following is TRUE:
      //    (a)  On right edge of screen (tx = TILE_XCOUNT - 1)
      //    (b)  No terrain exists down and to the right of the current tile
      //    (c)  Terrain exists directly to the right of the current tile
      if (onTileBoundary(DIR_RIGHT,AIWALK_SPEED)
            && ((tx == TILE_XCOUNT+1)
               || (GetTerrain(tx+1,ty+1) == ENTITY_TYPE_NONE)
               || (GetTerrain(tx+1,ty) != ENTITY_TYPE_NONE))) {
         collision = true;
      }
   }

   if (collision) {
      if (direction == DIR_LEFT) direction = DIR_RIGHT;
      else direction = DIR_LEFT;
   }
}

void CEntityAIWalk::handleMovement() {
   // Increment or decrement X by AIWALK_SPEED, depending on direction
   if (direction == DIR_LEFT) x -= AIWALK_SPEED;
   else x += AIWALK_SPEED;
}

void CEntityAIWalk::handleSprite() {
   if (prevX > x) pSpriteActive = pSpriteLeft;
   else if (prevX < x) pSpriteActive = pSpriteRight;
}

// ///////////////////////////////////////////////////////////////////////////
// END OF CODE
// ///////////////////////////////////////////////////////////////////////////
