// /////////////////////////////////////////////////////////////////////////////
// DR DOBB'S CHALLENGES
//
// Filename       : entityPlayer.cpp
// Date           : February 2008
//
// Description    : Refer to description in corresponding header.
//
// ///////////////////////////////////////////////////////////////////////////


// ///////////////////////////////////////////////////////////////////////////
// HEADERS (#include)
// ///////////////////////////////////////////////////////////////////////////
#include "entityPlayer.h"
#include "entityTerrain.h"


// ///////////////////////////////////////////////////////////////////////////
// CONSTANTS (#define)
// ///////////////////////////////////////////////////////////////////////////
// Original Definitions
/*
#define DOBB_CX                     15    // Collision X-offset
#define DOBB_CY                     32    // Collision Y-offset
#define DOBB_SPEED_GRASS            7     // Running speed on grass
#define DOBB_SPEED_GLUE             2     // Running speed on glue
#define DOBB_SOUND_GRASS            3     // Running sound on grass
#define DOBB_SOUND_GLUE             10    // Running sound on glue
#define DOBB_GRAVITY_DELAY          2     // Gravity delay
#define DOBB_GRAVITY_ACCEL          2.5   // Gravity acceleration
#define DOBB_GRAVITY_MAX            15.0  // Terminal velocity
#define DOBB_JUMP0                  18.0  // Initial jump speed
#define DOBB_JUMP_COUNT_MAX         2     // Maximum jump count
*/

// Dobb Definitions
// o Average
// o Smallest
#define DOBB_CX                     15    // Collision X-offset
#define DOBB_CY                     32    // Collision Y-offset
#define DOBB_SPEED_GRASS            7     // Running speed on grass
#define DOBB_SPEED_GLUE             2     // Running speed on glue
#define DOBB_SOUND_GRASS            3     // Running sound on grass
#define DOBB_SOUND_GLUE             10    // Running sound on glue
#define DOBB_GRAVITY_DELAY          2     // Gravity delay
#define DOBB_GRAVITY_ACCEL          2.5   // Gravity acceleration
#define DOBB_GRAVITY_MAX            15.0  // Terminal velocity
#define DOBB_JUMP0                  19.0  // Initial jump speed
#define DOBB_JUMP_COUNT_MAX         2     // Maximum jump count

// Pirate Definitions
// o Runs faster on glue (peg leg)
// o Slightly slower on grass 
// o Doesn't jump as high
#define PIRATE_CX                   20    // Collision X-offset
#define PIRATE_CY                   42    // Collision Y-offset
#define PIRATE_SPEED_GRASS          6     // Running speed on grass
#define PIRATE_SPEED_GLUE           4     // Running speed on glue
#define PIRATE_SOUND_GRASS          3     // Running sound on grass
#define PIRATE_SOUND_GLUE           5     // Running sound on glue
#define PIRATE_GRAVITY_DELAY        2     // Gravity delay
#define PIRATE_GRAVITY_ACCEL        2.5   // Gravity acceleration
#define PIRATE_GRAVITY_MAX          15.0  // Terminal velocity
#define PIRATE_JUMP0                17.0  // Initial jump speed
#define PIRATE_JUMP_COUNT_MAX       2     // Maximum jump count

// Salamander Definitions
// o Smaller jump, but can triple jump
#define SALAMANDER_CX               30    // Collision X-offset
#define SALAMANDER_CY               35    // Collision Y-offset
#define SALAMANDER_SPEED_GRASS      7     // Running speed on grass
#define SALAMANDER_SPEED_GLUE       2     // Running speed on glue
#define SALAMANDER_SOUND_GRASS      3     // Running sound on grass
#define SALAMANDER_SOUND_GLUE       10    // Running sound on glue
#define SALAMANDER_GRAVITY_DELAY    2     // Gravity delay
#define SALAMANDER_GRAVITY_ACCEL    2.5   // Gravity acceleration
#define SALAMANDER_GRAVITY_MAX      15.0  // Terminal velocity
#define SALAMANDER_JUMP0            14.0  // Initial jump speed
#define SALAMANDER_JUMP_COUNT_MAX   3     // Maximum jump count

// Cowboy Definitions
// o Higher jump
#define COWBOY_CX                   15    // Collision X-offset
#define COWBOY_CY                   40    // Collision Y-offset
#define COWBOY_SPEED_GRASS          8     // Running speed on grass
#define COWBOY_SPEED_GLUE           3     // Running speed on glue
#define COWBOY_SOUND_GRASS          3     // Running sound on grass
#define COWBOY_SOUND_GLUE           8     // Running sound on glue
#define COWBOY_GRAVITY_DELAY        2     // Gravity delay
#define COWBOY_GRAVITY_ACCEL        2.5   // Gravity acceleration
#define COWBOY_GRAVITY_MAX          15.0  // Terminal velocity
#define COWBOY_JUMP0                17.0  // Initial jump speed
#define COWBOY_JUMP_COUNT_MAX       2     // Maximum jump count

// Mummy Definitions
// o Slow on glue (wraps stuck to ground)
// o Slow on grass
// o Average jump with more hang-time
#define MUMMY_CX                    20    // Collision X-offset
#define MUMMY_CY                    43    // Collision Y-offset
#define MUMMY_SPEED_GRASS           6     // Running speed on grass
#define MUMMY_SPEED_GLUE            2     // Running speed on glue
#define MUMMY_SOUND_GRASS           4     // Running sound on grass
#define MUMMY_SOUND_GLUE            10    // Running sound on glue
#define MUMMY_GRAVITY_DELAY         4     // Gravity delay
#define MUMMY_GRAVITY_ACCEL         2.5   // Gravity acceleration
#define MUMMY_GRAVITY_MAX           15.0  // Terminal velocity
#define MUMMY_JUMP0                 16.0  // Initial jump speed
#define MUMMY_JUMP_COUNT_MAX        2     // Maximum jump count

// Jump definitions
// NOTE:  JUMP0 = 18.0 : Single jump = 4 rows, Double jump = 8 rows

// Threshold value of Y when locator arrow is displayed
#define PLAYER_ARROW_THRESHOLD      -10

// ///////////////////////////////////////////////////////////////////////////
// CONSTRUCTORS AND DESTRUCTORS
// ///////////////////////////////////////////////////////////////////////////
CEntityPlayer::CEntityPlayer(int xVal, int yVal, int chVal) : CEntity(xVal,yVal,DOBB_CX,DOBB_CY) {
   // Define type
   type = ENTITY_TYPE_PLAYER;

   // Copy parameters into local members
   character = chVal;

   // Initialize remaining members
   soundRunDelay  = 0;     // Delay since last run sound was played
   soundRun       = 0;     // ID of last run sound played
   jumpDelay      = 0;     // Delay since last jump (before gravity activated)
   jumpCount      = 0;     // Jump count since last touched ground
   isLeft         = true;  // Indicates whether or not facing left
   isDropping     = false; // Indicates whether or not player is dropping
   onGround       = true;  // Indicates whether or not on ground
   state          = PLAYER_STATE_NORMAL;

   // Load sprite and sound resources
   loadResources();
}

CEntityPlayer::~CEntityPlayer() {
   // Unload sprite and sound resources
   unloadResources();
}

// ///////////////////////////////////////////////////////////////////////////
// PROTECTED/PRIVATE METHODS
// ///////////////////////////////////////////////////////////////////////////
void CEntityPlayer::loadResources() {
   // Select sprite images based on 'character' value and adjust collision
   // offsets, as appropriate for each character.  Create action sprites
   // for left/right running, jumping and standing.
   switch(character) {
      case CHARACTER_MUMMY:
         pSpriteLRun = new CSprite(35,38,SPRITE_TYPE_DOBB,1);
         pSpriteLRun->AddImage("MummyLRun-",0,10,".png");
         pSpriteRRun = new CSprite(35,38,SPRITE_TYPE_DOBB,1);
         pSpriteRRun->AddImage("MummyRRun-",0,10,".png");
         pSpriteLJump = new CSprite(50,29,SPRITE_TYPE_DOBB,1);
         pSpriteLJump->AddImage("MummyLJump-0.png");
         pSpriteRJump = new CSprite(23,29,SPRITE_TYPE_DOBB,1);
         pSpriteRJump->AddImage("MummyRJump-0.png");
         pSpriteLStand = new CSprite(28,44,SPRITE_TYPE_DOBB,1);
         pSpriteLStand->AddImage("MummyLStand-0.png");
         pSpriteRStand = new CSprite(21,44,SPRITE_TYPE_DOBB,1);
         pSpriteRStand->AddImage("MummyRStand-0.png");
         pSpriteLDrop = new CSprite(42,36,SPRITE_TYPE_DOBB,1);
         pSpriteLDrop->AddImage("MummyLDrop.png");
         pSpriteRDrop = new CSprite(40,36,SPRITE_TYPE_DOBB,1);
         pSpriteRDrop->AddImage("MummyRDrop.png");
         collisionX     = MUMMY_CX;
         collisionY     = MUMMY_CY;
         speedGrass     = MUMMY_SPEED_GRASS;
         speedGlue      = MUMMY_SPEED_GLUE;
         soundGrass     = MUMMY_SOUND_GRASS;
         soundGlue      = MUMMY_SOUND_GLUE;
         gravityDelay   = MUMMY_GRAVITY_DELAY;
         gravityAccel   = MUMMY_GRAVITY_ACCEL;
         gravityMax     = MUMMY_GRAVITY_MAX;
         jumpInit       = MUMMY_JUMP0;
         jumpMax        = MUMMY_JUMP_COUNT_MAX;
         break;
      case CHARACTER_PIRATE:
         pSpriteLRun = new CSprite(48,54,SPRITE_TYPE_DOBB,1);
         pSpriteLRun->AddImage("PirateLRun-",0,10,".png");
         pSpriteRRun = new CSprite(43,54,SPRITE_TYPE_DOBB,1);
         pSpriteRRun->AddImage("PirateRRun-",0,10,".png");
         pSpriteLJump = new CSprite(33,45,SPRITE_TYPE_DOBB,1);
         pSpriteLJump->AddImage("PirateLJump-0.png");
         pSpriteRJump = new CSprite(40,45,SPRITE_TYPE_DOBB,1);
         pSpriteRJump->AddImage("PirateRJump-0.png");
         pSpriteLStand = new CSprite(40,53,SPRITE_TYPE_DOBB,1);
         pSpriteLStand->AddImage("PirateLStand-0.png");
         pSpriteRStand = new CSprite(40,53,SPRITE_TYPE_DOBB,1);
         pSpriteRStand->AddImage("PirateRStand-0.png");
         pSpriteLDrop = new CSprite(36,45,SPRITE_TYPE_DOBB,1);
         pSpriteLDrop->AddImage("PirateLDrop.png");
         pSpriteRDrop = new CSprite(38,45,SPRITE_TYPE_DOBB,1);
         pSpriteRDrop->AddImage("PirateRDrop.png");
         collisionX     = PIRATE_CX;
         collisionY     = PIRATE_CY;
         speedGrass     = PIRATE_SPEED_GRASS;
         speedGlue      = PIRATE_SPEED_GLUE;
         soundGrass     = PIRATE_SOUND_GRASS;
         soundGlue      = PIRATE_SOUND_GLUE;
         gravityDelay   = PIRATE_GRAVITY_DELAY;
         gravityAccel   = PIRATE_GRAVITY_ACCEL;
         gravityMax     = PIRATE_GRAVITY_MAX;
         jumpInit       = PIRATE_JUMP0;
         jumpMax        = PIRATE_JUMP_COUNT_MAX;
         break;
      case CHARACTER_COWBOY:
         pSpriteLRun = new CSprite(44,40,SPRITE_TYPE_DOBB,1);
         pSpriteLRun->AddImage("CowboyLRun-",0,10,".png");
         pSpriteRRun = new CSprite(14,40,SPRITE_TYPE_DOBB,1);
         pSpriteRRun->AddImage("CowboyRRun-",0,10,".png");
         pSpriteLJump = new CSprite(25,38,SPRITE_TYPE_DOBB,1);
         pSpriteLJump->AddImage("CowboyLJump-0.png");
         pSpriteRJump = new CSprite(25,38,SPRITE_TYPE_DOBB,1);
         pSpriteRJump->AddImage("CowboyRJump-0.png");
         pSpriteLStand = new CSprite(33,41,SPRITE_TYPE_DOBB,1);
         pSpriteLStand->AddImage("CowboyLStand-0.png");
         pSpriteRStand = new CSprite(13,41,SPRITE_TYPE_DOBB,1);
         pSpriteRStand->AddImage("CowboyRStand-0.png");
         pSpriteLDrop = new CSprite(30,37,SPRITE_TYPE_DOBB,1);
         pSpriteLDrop->AddImage("CowboyLDrop.png");
         pSpriteRDrop = new CSprite(30,37,SPRITE_TYPE_DOBB,1);
         pSpriteRDrop->AddImage("CowboyRDrop.png");
         collisionX     = COWBOY_CX;
         collisionY     = COWBOY_CY;
         speedGrass     = COWBOY_SPEED_GRASS;
         speedGlue      = COWBOY_SPEED_GLUE;
         soundGrass     = COWBOY_SOUND_GRASS;
         soundGlue      = COWBOY_SOUND_GLUE;
         gravityDelay   = COWBOY_GRAVITY_DELAY;
         gravityAccel   = COWBOY_GRAVITY_ACCEL;
         gravityMax     = COWBOY_GRAVITY_MAX;
         jumpInit       = COWBOY_JUMP0;
         jumpMax        = COWBOY_JUMP_COUNT_MAX;
         break;
      case CHARACTER_SALAMANDER:
         pSpriteLRun = new CSprite(65,40,SPRITE_TYPE_DOBB,1);
         pSpriteLRun->AddImage("SalamanderLRun-",0,9,".png");
         pSpriteRRun = new CSprite(40,40,SPRITE_TYPE_DOBB,1);
         pSpriteRRun->AddImage("SalamanderRRun-",0,9,".png");
         pSpriteLJump = new CSprite(54,38,SPRITE_TYPE_DOBB,1);
         pSpriteLJump->AddImage("SalamanderLJump-0.png");
         pSpriteRJump = new CSprite(54,38,SPRITE_TYPE_DOBB,1);
         pSpriteRJump->AddImage("SalamanderRJump-0.png");
         pSpriteLStand = new CSprite(39,40,SPRITE_TYPE_DOBB,1);
         pSpriteLStand->AddImage("SalamanderLStand-0.png");
         pSpriteRStand = new CSprite(39,40,SPRITE_TYPE_DOBB,1);
         pSpriteRStand->AddImage("SalamanderRStand-0.png");
         pSpriteLDrop = new CSprite(55,40,SPRITE_TYPE_DOBB,1);
         pSpriteLDrop->AddImage("SalamanderLDrop.png");
         pSpriteRDrop = new CSprite(55,40,SPRITE_TYPE_DOBB,1);
         pSpriteRDrop->AddImage("SalamanderRDrop.png");
         collisionX     = SALAMANDER_CX;
         collisionY     = SALAMANDER_CY;
         speedGrass     = SALAMANDER_SPEED_GRASS;
         speedGlue      = SALAMANDER_SPEED_GLUE;
         soundGrass     = SALAMANDER_SOUND_GRASS;
         soundGlue      = SALAMANDER_SOUND_GLUE;
         gravityDelay   = SALAMANDER_GRAVITY_DELAY;
         gravityAccel   = SALAMANDER_GRAVITY_ACCEL;
         gravityMax     = SALAMANDER_GRAVITY_MAX;
         jumpInit       = SALAMANDER_JUMP0;
         jumpMax        = SALAMANDER_JUMP_COUNT_MAX;
         break;
      default:
         pSpriteLRun = new CSprite(25,30,SPRITE_TYPE_DOBB,1);
         pSpriteLRun->AddImage("dobbsLRun-",0,10,".png");
         pSpriteRRun = new CSprite(35,30,SPRITE_TYPE_DOBB,1);
         pSpriteRRun->AddImage("dobbsRRun-",0,10,".png");
         pSpriteLJump = new CSprite(23,29,SPRITE_TYPE_DOBB,1);
         pSpriteLJump->AddImage("dobbsLJump-0.png");
         pSpriteRJump = new CSprite(23,29,SPRITE_TYPE_DOBB,1);
         pSpriteRJump->AddImage("dobbsRJump-0.png");
         pSpriteLStand = new CSprite(28,38,SPRITE_TYPE_DOBB,1);
         pSpriteLStand->AddImage("dobbsLStand-0.png");
         pSpriteRStand = new CSprite(28,38,SPRITE_TYPE_DOBB,1);
         pSpriteRStand->AddImage("dobbsRStand-0.png");
         pSpriteLDrop = new CSprite(23,27,SPRITE_TYPE_DOBB,1);
         pSpriteLDrop->AddImage("DobbsLDrop.png");
         pSpriteRDrop = new CSprite(23,27,SPRITE_TYPE_DOBB,1);
         pSpriteRDrop->AddImage("DobbsRDrop.png");
         collisionX     = DOBB_CX;
         collisionY     = DOBB_CY;
         speedGrass     = DOBB_SPEED_GRASS;
         speedGlue      = DOBB_SPEED_GLUE;
         soundGrass     = DOBB_SOUND_GRASS;
         soundGlue      = DOBB_SOUND_GLUE;
         gravityDelay   = DOBB_GRAVITY_DELAY;
         gravityAccel   = DOBB_GRAVITY_ACCEL;
         gravityMax     = DOBB_GRAVITY_MAX;
         jumpInit       = DOBB_JUMP0;
         jumpMax        = DOBB_JUMP_COUNT_MAX;
         break;
   }

   // Create smoke sprite for when the player runs into an enemy.
   pSpriteSmoke = new CSprite(128,128,SPRITE_TYPE_DOBB,1);
   pSpriteSmoke->AddImage("smoke_B-",0,15,".png");

   // Create arrow sprite for when player disappears off the top of the screen
   pSpriteArrow = new CSprite(22,25,SPRITE_TYPE_DOBB,0);
   pSpriteArrow->AddImage("arrow.png");

   // Initialize active sprite to left standing
   pSpriteActive = pSpriteLStand;

   // Create sounds for running, jumping, landing, and exploding.
   // NOTE:  There are 3 running sounds that are played back-to-back
   //        in random order to create a prolonged, but unrepetative
   //        sound of running.
   pSoundRun[0] = new CSound("run0.wav");
   pSoundRun[1] = new CSound("run1.wav");
   pSoundRun[2] = new CSound("run2.wav");
   pSoundJump = new CSound("jump.wav");
   pSoundLand = new CSound("land.wav");
   pSoundExplode = new CSound("smoke.wav");

   // Create (debug) text to display current location of player
   pLocation = new CText(10,570,SCREEN_WIDTH,30,"",17,FW_BOLD,false,DT_LEFT,0xff000000);

   // Create (debug) text to display character-specific values
   pCharacter = new CText(10,550,SCREEN_WIDTH,30,"",17,FW_BOLD,false,DT_LEFT,0xff000000);
}

void CEntityPlayer::unloadResources() {
   // Remove sprites
   delete pSpriteLDrop;
   delete pSpriteRDrop;
   delete pSpriteLRun;
   delete pSpriteRRun;
   delete pSpriteLJump;
   delete pSpriteRJump;
   delete pSpriteLStand;
   delete pSpriteRStand;
   delete pSpriteSmoke;
   delete pSpriteArrow;

   // Remove sounds
   for (int i=0; i<3; i++) delete pSoundRun[i];
   delete pSoundJump;
   delete pSoundLand;
   delete pSoundExplode;

   // Remove text (debug)
   delete pLocation;
   delete pCharacter;
}


void CEntityPlayer::handleMovement() {
   // If velocity is > 0 (ie. falling downward) and a terrain collision
   // occurs, then assert onGround flag and play landing sound.  Reset
   // isDropping flag until next drop.
   if ((velY > 0) && handleCollision(&velY)) {
      onGround = true;
      isDropping = false;
      pSoundLand->Play();
   }

   // Increment x/y by (adjusted) X/Y velocity components
   x += (int)velX;
   y += (int)velY;

   // Ensure player does not move beyond the left and right edge of the screen
   if ((x + collisionX) > SCREEN_WIDTH) x = SCREEN_WIDTH - collisionX;
   if ((x - collisionX) < 0) x = collisionX;

   // Handle on-ground and in-air physics:
   // If on ground...
   if (onGround) {
      // If terrain no longer detected directly below the player,
      // then start falling (onGround = false)
      if (!collisionDetected(x,y)) {
         onGround = false;
         isDropping = true;
         jumpDelay = gravityDelay;

      // Otherwise, zero x/y velocity and reset jump count
      } else {
         velX = 0;
         velY = 0;
         jumpCount = 0;
      }

   // If in air...
   } else {
      // Increment jumpDelay if less than gravityDelay
      // before activating gravity
      if (jumpDelay < gravityDelay) {
         jumpDelay++;

      // Otherwise, increment downward velocity by GRAVITY until
      // the terminal velocity (gravityMax) is reached.
      } else {
         velY += gravityAccel;
         if (velY > gravityMax) velY = gravityMax;
      }
   }
}

void CEntityPlayer::checkDeath() {
   // Only check death states if not already in one
   if (state == PLAYER_STATE_NORMAL) {

      // Check if player has fallen below the screen
      if ((y - collisionY) > SCREEN_HEIGHT) {
         state = PLAYER_STATE_OOB;

      // Otherwise, check if player has collided with any AI
      } else {
         // Loop through each AI and check for overlaps
         std::vector<CEntity*>::iterator e;
         for(e = allAI.begin(); e != allAI.end(); e++) {
            if (overlaps(*e)) {
               // Set state to PLAYER_STATE_ATTACK0 or PLAYER_STATE_ATTACK1,
               // depending on type of AI that player has collided with.
               if ((*e)->GetType() == ENTITY_TYPE_AIFLY) state = PLAYER_STATE_ATTACK0;
               else state = PLAYER_STATE_ATTACK1;
               break;
            }
         }
      }
   }

   // Check if death check has resulted in a state change
   if (state != PLAYER_STATE_NORMAL) {
      // Hide current sprite
      pSpriteActive->Hide();

      // Move smoke to current location and unhide
      pSpriteSmoke->Move(x,y);
      pSpriteSmoke->Unhide();

      // Play smoke
      pSoundExplode->Play();
   }
}


bool CEntityPlayer::collisionDetected(int xVal, int yVal) {
   // Since collisions only occur when the player lands on top of a tile
   // boundary, ignore collision detection if not on the bottom tile boundary
   if (!onTileBoundary(DIR_DOWN,xVal,yVal)) return false;

   // Calculate range of TX for width of current character
   int txLeft = GetTX(TILE_LOW,xVal);
   int txRight = GetTX(TILE_HIGH,xVal);

   // Calculate TY for tile directly below the player
   int tyBelow = GetTY(TILE_HIGH,yVal) + 1;

   // Loop through all tiles directly below the player
   for (int tx=txLeft; tx<=txRight; tx++) {

      // Collision detected if tile below is not NONE
      if (GetTerrain(tx,tyBelow) != ENTITY_TYPE_NONE) return true;
   }

   // If reach end of loop without encountering terrain, then no collision
   return false;
}



bool CEntityPlayer::handleCollision(float* yDiff) {
   // Ignore collision detection if not moving vertically
   if (*yDiff == 0) return false;

   // Calculate direction of Y
   int dir = int(*yDiff/abs(*yDiff));

   // Perform a basic sweep test to ensure no collisions happen
   // between yCurrent=[0,yDiff]
   int yCurrent = 0;
   while (abs(yCurrent) <= abs(*yDiff)) {

      // Increment current y offset to next pixel
      yCurrent += 1;

      // Check current location against level terrain
      if (collisionDetected(x,y + dir*yCurrent)) {

         // If collision is detected, step back to previous coordinate before
         // yCurrent was incremented.
         *yDiff = float(yCurrent);
         return true;
      }
   }
   return false;
}

void CEntityPlayer::handleSprite() {
   // Update facing direction only when moved left or right.
   // In other words, ignore vertical-only movements.
   if (prevX > x) isLeft = true;
   else if (prevX < x) isLeft = false;

   // If not on the ground, use JUMP or DROP sprite
   if (!onGround) {
      if (isDropping) pSpriteActive = isLeft ? pSpriteLDrop : pSpriteRDrop;
      else pSpriteActive = isLeft ? pSpriteLJump : pSpriteRJump;

   // Otherwise, if not moving, use STAND sprite
   } else if ((prevX == x) && (prevY == y)) {
      pSpriteActive = isLeft ? pSpriteLStand : pSpriteRStand;

   // Otherwise, use RUN sprite
   } else {
      pSpriteActive = isLeft ? pSpriteLRun : pSpriteRRun;
   }

   // Unhide and move active sprite
   if (pSpriteInactive != pSpriteActive) {
      if (pSpriteInactive != NULL) pSpriteInactive->Hide();
      pSpriteInactive = pSpriteActive;
      if (state == PLAYER_STATE_NORMAL) pSpriteActive->Unhide();
      pSpriteActive->Play();
   }
   pSpriteActive->Move(x,y);

   // If player is above the screen, then display arrow to indicate
   // where the player's current location
   if (y < PLAYER_ARROW_THRESHOLD) {
      pSpriteArrow->Move(x,30);
      pSpriteArrow->Unhide();
   // Otherwise, hide the arrow
   } else {
      pSpriteArrow->Hide();
   }

   // Hide smoke sprite if reached end of animation
   if (!pSpriteSmoke->IsHidden() && pSpriteSmoke->LastFrame()) {
      pSpriteSmoke->Hide();
   }
}


void CEntityPlayer::update() {
   // Only update physics if not dead
   if (state == PLAYER_STATE_NORMAL) {
      // Check for player death
      checkDeath();

      // Update player location
      handleMovement();
   }

   // Update active sprite
   handleSprite();

#if USE_DEBUG == 1
   // Update player location debug text (if USE_DEBUG asserted)
   pLocation->SetText("Player (%i,%i)  T(%i,%i)  TW(%i:%i)  TH(%i:%i)",
                         x,y,GetTX(),GetTY(),
                         GetTX(TILE_LOW),GetTX(TILE_HIGH),
                         GetTY(TILE_LOW),GetTY(TILE_HIGH));

   // Update character debug text (if USE_DEBUG asserted)
   pCharacter->SetText("Character %i:      Jump=%0.1f,%i   Gravity=%i,%0.1f,%0.1f   Collision=(%i,%i)  Speed=%i,%i   Sound=%i,%i\n",
                           character, jumpInit, jumpMax,
                           gravityDelay, gravityAccel, gravityMax,
                           collisionX, collisionY,
                           speedGrass, speedGlue,
                           soundGrass, soundGlue);
#endif

}


// ///////////////////////////////////////////////////////////////////////////
// PUBLIC METHODS
// ///////////////////////////////////////////////////////////////////////////
void CEntityPlayer::Run(bool left) {
   // Ignore Run() request if heading left at the left-edge of the screen
   if (left && (x == collisionX)) return;

   // Ignore Run() request if heading right at the right-edge of the screen
   if (!left && (x == SCREEN_WIDTH - collisionX)) return;

   // Calculate TX/TY for X-center and Y-bottom tile
   int tx = GetTX(TILE_CENTER);
   int ty = GetTY(TILE_HIGH);
   int speed;

   // Play sound if running on ground and run delay is zero
   if (onGround && (soundRunDelay == 0)) {
      pSoundRun[soundRun]->Play();

      // Select a randomly *new* running sound for next time
      int previous = soundRun;
      while (previous == soundRun) { soundRun = rand()%3; }
   }

   // Check if running across glue on the ground
   if (onGround && (GetTerrain(tx,ty+1) == ENTITY_TYPE_GLUE)) {
      // Select the slower running speed
      speed = speedGlue;

      // Increment the sound delay, based on a slower repeat rate
      soundRunDelay = (soundRunDelay + 1) % soundGlue;

      // Adjust the frame delays for running sprites to a slower speed
      pSpriteLRun->SetFrameDelay(2);
      pSpriteRRun->SetFrameDelay(2);

   // Otherwise, player must be walking on grass or flying through the air
   } else {
      // Select the faster running speed
      speed = speedGrass;

      // Increment the sound delay, based on a faster repeat rate
      soundRunDelay = (soundRunDelay + 1) % soundGrass;

      // Adjust the frame delays for running sprites to a faster speed
      pSpriteLRun->SetFrameDelay(1);
      pSpriteRRun->SetFrameDelay(1);
   }

   // Adjust relative movement by 'speed' in the appropriate direction
   int dx = left ? -speed : speed;

   // Use MoveRel(), rather than setting velX because moves only when Run()
   // is called (ie. key held down)
   MoveRel(dx,0);
}

void CEntityPlayer::Jump() {
   // Ignore jump if already jumped twice
   if (jumpCount >= jumpMax) return;

   // Reset the jump delay to ensure gravity is not immediately activated
   jumpDelay = 0;

   // Increment jump counter (to ensure max is not exceeded)
   jumpCount++;

   // Deassert onGround flag
   onGround = false;

   // Reset dropping flag
   isDropping = false;

   // Play jump sound
   pSoundJump->Play();

   // Initiate jump with max upward velocity
   velY = -jumpInit;
}

void CEntityPlayer::Drop() {
   // Ignore if already in the air
   if (!onGround) return;

   // If onGround, then move down one pixel to force player to fall
   y++;
}

int  CEntityPlayer::GetState() { return state; }

bool CEntityPlayer::IsDead() {
   // Used to check when the player has died and the smoke has cleared
   return ((state != PLAYER_STATE_NORMAL) && pSpriteSmoke->IsHidden());
}

void CEntityPlayer::AdjustPhysics(int dSpeedGrass, int dSpeedGlue,
                                  int dSoundGrass, int dSoundGlue,
                                  int dGravDelay, float dGravAccel, float dGravMax,
                                  float dJumpInit, int dJumpMax) {
   // Adjust character specifics by incrementals specified
   speedGrass     += dSpeedGrass;
   speedGlue      += dSpeedGlue;
   soundGrass     += dSoundGrass;
   soundGlue      += dSoundGlue;
   gravityDelay   += dGravDelay;
   gravityAccel   += dGravAccel;
   gravityMax     += dGravMax;
   jumpInit       += dJumpInit;
   jumpMax        += dJumpMax;
}


// ///////////////////////////////////////////////////////////////////////////
// END OF CODE
// ///////////////////////////////////////////////////////////////////////////
