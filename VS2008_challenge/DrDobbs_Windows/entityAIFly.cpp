// /////////////////////////////////////////////////////////////////////////////
// DR DOBB'S CHALLENGES
//
// Filename       : entityAIFly.cpp
// Date           : February 2008
//
// Description    : Refer to description in corresponding header.
//
// ///////////////////////////////////////////////////////////////////////////


// ///////////////////////////////////////////////////////////////////////////
// HEADERS (#include)
// ///////////////////////////////////////////////////////////////////////////
#include "entityAIFly.h"

// ///////////////////////////////////////////////////////////////////////////
// CONSTANTS (#define)
// ///////////////////////////////////////////////////////////////////////////
#define AIFLY_CX        32
#define AIFLY_CY        36
#define AIFLY_SPEED     4

// ///////////////////////////////////////////////////////////////////////////
// CONSTRUCTORS AND DESTRUCTORS
// ///////////////////////////////////////////////////////////////////////////
CEntityAIFly::CEntityAIFly(int xVal, int yVal, int dir) : CEntityAI(xVal,yVal,ENTITY_TYPE_AIFLY,AIFLY_CX,AIFLY_CY) {
   // Create left and right facing sprites
   pSpriteLeft = new CSprite(32,62,SPRITE_TYPE_AI,1);
   pSpriteLeft->AddImage("BeetleLFly-",0,1,".png");
   pSpriteRight = new CSprite(32,62,SPRITE_TYPE_AI,1);
   pSpriteRight->AddImage("BeetleRFly-",0,1,".png");

   // Initialize direction to specified directon
   // NOTE: Ensure specified 'dir' is confined to [0,7]
   dir = max(0,min(7,dir));
   clockwise = (dir > 3);  // Check if bit 3 is asserted
   direction = dir & 3;    // Bitwise AND with 0b011

   // Initialize active sprite to left-facing
   pSpriteActive = pSpriteLeft;
}

CEntityAIFly::~CEntityAIFly() {
}

// ///////////////////////////////////////////////////////////////////////////
// PROTECTED/PRIVATE METHODS
// ///////////////////////////////////////////////////////////////////////////
void CEntityAIFly::handleCollision() {
   bool collision = false;

   // Check if left-edge is beyond the left screen boundary
   if (x - collisionX < 0) {
      // Realign entity to left screen boundary
      x = collisionX;

      // If already heading LEFT, assert collision flag
      if (direction == DIR_LEFT) collision = true;

   // Otherwise, check if right-edge is beyond the right screen boundary
   } else if (x + collisionX >= SCREEN_WIDTH) {
      // Realign entity to right screen boundary
      x = SCREEN_WIDTH - collisionX - 1;

      // If already heading RIGHT, assert collision flag
      if (direction == DIR_RIGHT) collision = true;
   }


   // Check if top-edge is beyond the top screen boundary
   if (y - collisionY < 0) {
      // Realign entity to top screen boundary
      y = collisionY;

      // If already heading UP, assert collision flag
      if (direction == DIR_UP) collision = true;

   // Otherwise, check if bottom-edge is beyond the bottom screen boundary
   } else if (y + collisionY >= SCREEN_HEIGHT) {
      // Realign entity to bottom screen boundary
      y = SCREEN_HEIGHT - collisionY - 1;

      // If already heading DOWN, assert collision flag
      if (direction == DIR_DOWN) collision = true;
   }


   // If a collision hasn't been detected yet, then loop through all
   // terrain until an overlap is detected.
   if (!collision) {
      std::vector<CEntity*>::iterator e;
      for(e = allTerrain.begin(); e != allTerrain.end(); e++) {
         if (overlaps(*e)) {
            // If LEFTWARD, move X of left-edge to just right of terrain tile
            if (direction == DIR_LEFT) {
               x = (*e)->GetX() + (*e)->GetCollisionX() + collisionX;
               collision = true;
               break;

            // If RIGHTWARD, move X of right-edge to just left of terrain tile
            } else if (direction == DIR_RIGHT) {
               x = (*e)->GetX() - (*e)->GetCollisionX() - collisionX;
               collision = true;
               break;

            // If UPWARD, move Y of top-edge to jut below terrain tile
            } else if (direction == DIR_UP) {
               y = (*e)->GetY() + (*e)->GetCollisionY() + collisionY;
               collision = true;
               break;

            // If DOWNWARD, move Y of bottom-edge to jut above terrain tile
            } else { // direction == DIR_DOWN
               y = (*e)->GetY() - (*e)->GetCollisionY() - collisionY;
               collision = true;
               break;
            }
         }
      }
   }

   // If a collision has been detected, then change direction as appropriate
   if (collision) {
      if (direction == DIR_LEFT) direction = clockwise ? DIR_UP : DIR_DOWN;
      else if (direction == DIR_DOWN) direction = clockwise ? DIR_LEFT : DIR_RIGHT;
      else if (direction == DIR_RIGHT) direction = clockwise ? DIR_DOWN : DIR_UP;
      else direction = clockwise ? DIR_RIGHT : DIR_LEFT;
   }
}

void CEntityAIFly::handleMovement() {
   // Update the X or Y coordinate by AIFLY_SPEED in the appropriate direction
   switch(direction) {
      case DIR_LEFT:
         x -= AIFLY_SPEED;
         break;
      case DIR_DOWN:
         y += AIFLY_SPEED;
         break;
      case DIR_RIGHT:
         x += AIFLY_SPEED;
         break;
      default:
         y -= AIFLY_SPEED;
         break;
   }
}

void CEntityAIFly::handleSprite() {
   if (prevX > x) pSpriteActive = pSpriteLeft;
   else if (prevX < x) pSpriteActive = pSpriteRight;
}

// ///////////////////////////////////////////////////////////////////////////
// END OF CODE
// ///////////////////////////////////////////////////////////////////////////
