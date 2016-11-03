// /////////////////////////////////////////////////////////////////////////////
// DR DOBB'S CHALLENGES
//
// Filename       : entityToken.cpp
// Date           : February 2008
//
// Description    : Refer to description in corresponding header.
//
// ///////////////////////////////////////////////////////////////////////////


// ///////////////////////////////////////////////////////////////////////////
// HEADERS (#include)
// ///////////////////////////////////////////////////////////////////////////
#include "entityToken.h"
#include "input.h"

// ///////////////////////////////////////////////////////////////////////////
// CONSTANTS (#define)
// ///////////////////////////////////////////////////////////////////////////
#define TOKEN_CX              14
#define TOKEN_CY              14
#define TOKEN_MIN_OVERLAP     10

#define TOKEN_VEL_RATE        5.0
#define TOKEN_VEL_MIN         2

// ///////////////////////////////////////////////////////////////////////////
// STATIC INITIALIZATION
// ///////////////////////////////////////////////////////////////////////////
CEntityToken*  CEntityToken::pSelectedToken = NULL;
CEntityPlayer* CEntityToken::pPlayer = NULL;
int            CEntityToken::startFrame = 0;

// ///////////////////////////////////////////////////////////////////////////
// CONSTRUCTORS AND DESTRUCTORS
// ///////////////////////////////////////////////////////////////////////////
CEntityToken::CEntityToken(int xVal, int yVal) : CEntity(xVal,yVal,TOKEN_CX,TOKEN_CY) {
   // Define tile type
   type = ENTITY_TYPE_TOKEN;

   // Increment total token count
   totalTokens++;

   // Initialize state to IDLE (ie. not GRABBED or COLLECTED)
   state = TOKEN_STATE_IDLE;

   // Create token sprite
   pSpriteToken = new CSprite(18,12,SPRITE_TYPE_TOKEN,2);
   pSpriteToken->AddImage("collectitem",0,39,".png");
   pSpriteToken->Unhide();
   pSpriteToken->Move(x,y);

   // Set start frme and randomly select next one
   pSpriteToken->SetFrame(startFrame);
   startFrame = rand()%40;

   // Create selected token
   pSpriteSelect = new CSprite(36,33,SPRITE_TYPE_TOKEN);
   pSpriteSelect->AddImage("markerGlow.png");

   // Create "collection" sound
   // NOTE: Each token has its own sound to ensure multiple collection sounds
   //       can play at once without truncating any sound.
   pSoundCollect = new CSound("collect.wav");
}

CEntityToken::~CEntityToken() {
   // Delete token resources
   delete pSpriteToken;
   delete pSpriteSelect;
   delete pSoundCollect;
}

// ///////////////////////////////////////////////////////////////////////////
// PROTECTED/PRIVATE METHODS
// ///////////////////////////////////////////////////////////////////////////
bool CEntityToken::collisionDetected(int xVal, int yVal) {
   // Loop through all terrain and check for overlaps at the given coordinates.
   // This is a less-efficient brute force means of checking for collisions,
   // implemented in this way for simplicity.
   //
   // Ideally, the method should only need to check terrain in the immediate
   // vicinity of the token, rather than all tiles defined in the level.
   // However, with this more robust implementation, it's easier to handle
   // dynamic obstructions of changing locations.
   std::vector<CEntity*>::iterator e;
   for(e = allTerrain.begin(); e != allTerrain.end(); e++) {
      if (overlaps(*e,xVal,yVal)) return true;
   }
   return false;
}


bool CEntityToken::handleCollision(float* xDiff, float* yDiff) {
   // Ignore collision detection if not moving (via jump velocity)
   if ((*xDiff == 0) && (*yDiff == 0)) return false;

   // Prevent "inching" when unit vector is less than one, thereby allowing
   // a token to "inch" toward the player when it's right next to terrain
   // that would otherwise block its path.  Basically, there are 4 scenarios
   // to check:
   //    1.  Upward velocity when terrain immediately above token
   //    2.  Downward velocity when terrain immediately below token
   //    3.  Leftward velocity when terrain immediately left of token
   //    4.  Rightward velocity when terrain immediately right of token
   int tx = GetTX();
   int ty = GetTY();
   if (((*yDiff < 0) && (terrain[tx][ty-1]!=ENTITY_TYPE_NONE) && onTileBoundary(DIR_UP))
         || ((*yDiff > 0) && (terrain[tx][ty+1]!=ENTITY_TYPE_NONE) && onTileBoundary(DIR_DOWN))
         || ((*xDiff < 0) && (terrain[tx-1][ty]!=ENTITY_TYPE_NONE) && onTileBoundary(DIR_LEFT))
         || ((*xDiff > 0) && (terrain[tx+1][ty]!=ENTITY_TYPE_NONE) && onTileBoundary(DIR_RIGHT))) {
      // If one of these special cases is detected, then zero velocity
      // and flag a collision
      *xDiff = 0;
      *yDiff = 0;
      return true;
   }

   // Calculate the angle of the change in X and Y
   float angle = (*xDiff == 0) ? PI/2 : atan((*yDiff)/(*xDiff));

   // Calculate the X and Y components of the direction unit vector
   float xUnit;
   float yUnit;
   if (abs(*xDiff) > abs(*yDiff)) {
      xUnit = *xDiff/abs(*xDiff);
      yUnit = xUnit*tan(angle);
      if (abs(yUnit) < 0.0001) yUnit = 0;
   } else {
      yUnit = *yDiff/abs(*yDiff);
      xUnit = yUnit/tan(angle);
      if (abs(xUnit) < 0.0001) xUnit = 0;
   }

   // Perform a basic sweep test to ensure no collisions happen
   // between x=[0,xDiff] and y=[0,yDiff]
   float xCurrent = 0;
   float yCurrent = 0;
   while ((abs(xCurrent) <= abs(*xDiff)) && (abs(yCurrent) <= abs(*yDiff))) {
      // Increment current (x,y) offset by unit vector
      xCurrent += xUnit;
      yCurrent += yUnit;

      // Check current location against level terrain
      if (collisionDetected(x+(int)xCurrent,y+(int)yCurrent)) {

         // If collision is detected, step back to previous coordinate before
         // unit vector was added in this iteraiton.
         *xDiff = xCurrent - xUnit;
         *yDiff = yCurrent - yUnit;
         return true;
      }
   }
   return false;
}

void CEntityToken::update() {
   // Ignore token update if already collected
   if (state == TOKEN_STATE_COLLECTED) return;

   // Handle mouse-over behaviour (if IDLE or GRABBED)
   if (IsMouseOver()) {
      // If no token is currently selected, then unhide "select" sprite and
      // set the SelectedToken pointer to this token.
      if (pSelectedToken == NULL) {
         pSelectedToken = this;
         pSpriteSelect->Unhide();
      }

      // Update highlight sprite location
      pSpriteSelect->Move(x,y);
   
   // Otherwise, if token is currently selected but the mouse is not over it,
   // then hide the "select" sprite and NULL the SelectedToken pointer.
   } else if (pSelectedToken == this) {
      pSelectedToken = NULL;
      pSpriteSelect->Hide();
   }

   // Move token if currently GRABBED
   if (state == TOKEN_STATE_GRABBED) {
      // Calculate change in X/Y, based on TOKEN_VEL_RATE divisor.  This is an
      // easy way to create a dynamic-looking fast-to-slow movement effect.
      // For example, if TOKEN_VEL_RATE is set to 2, it will move 1/2 the
      // distance between the player and the token every frame.  The larger the
      // number, the smaller the incremental movements.  So if TOKEN_VEL_RATE is
      // set to 10, it will move 1/10th the distance between the player and the
      // token every frame.
      float xDiff = float((pPlayer->GetX() - x)/TOKEN_VEL_RATE);
      float yDiff = float((pPlayer->GetY() - y)/TOKEN_VEL_RATE);

      // If change speed is less than 1, then use minimum speed of TOKEN_VEL_MIN
      if ((xDiff != 0) && abs(xDiff) < 1) xDiff = TOKEN_VEL_MIN*xDiff/abs(xDiff);
      if ((yDiff != 0) && abs(yDiff) < 1) yDiff = TOKEN_VEL_MIN*yDiff/abs(yDiff);

      // Perform "sweep test" for collision detection.
      //
      // Using a divisor (TOKEN_VEL_RATE) to determine the incremental movement
      // each frame means that the token can potentially be moving very fast.
      // For very fast moving objects, it's sometimes useful to use a SWEEP
      // collision test to ensure objects don't move THROUGH obstructions.
      if (handleCollision(&xDiff,&yDiff)) {
         state = TOKEN_STATE_IDLE;
      }

      // Update X/Y after handleCollision() has made modification to xDiff and yDiff
      x += (int)xDiff;
      y += (int)yDiff;
      pSpriteToken->Move(x,y);
   }

   // Collect token if overlaps player by TOKEN_MIN_OVERLAP
   if (overlaps(pPlayer,TOKEN_MIN_OVERLAP)) Collect();
}

// ///////////////////////////////////////////////////////////////////////////
// PUBLIC METHODS
// ///////////////////////////////////////////////////////////////////////////
void CEntityToken::Grab() {
   // Set to GRABBED state
   state = TOKEN_STATE_GRABBED;
}

void CEntityToken::Collect() {
   // Set to COLLECTED state
   state = TOKEN_STATE_COLLECTED;

   // Hide token and selected sprite
   pSpriteSelect->Hide();
   pSpriteToken->Hide();

   // Play token collection sound
   pSoundCollect->Play();

   // Increment count of collected tokens
   collectedTokens++;
}

bool CEntityToken::IsMouseOver() {
   // Check if mouse distance from center is within collision offset values
   int dx = abs(CInput::MouseX() - x);
   int dy = abs(CInput::MouseY() - y);
   return ((dx <= collisionX) && (dy <= collisionY));
}


// ///////////////////////////////////////////////////////////////////////////
// STATIC METHODS
// ///////////////////////////////////////////////////////////////////////////
bool CEntityToken::HandleGrab() {
   // if token is currently selected then change state to GRABBED
   if (pSelectedToken != NULL) {
      pSelectedToken->Grab();
      return true;
   } else {
      return false;
   }
}

void CEntityToken::Init(CEntityPlayer* player) {
   // This should be called at the beginning of level creation.  pPlayer
   // is used by update() to determine where the player entity is currently
   // located.
   pPlayer = player;
   pSelectedToken = NULL;
}


// ///////////////////////////////////////////////////////////////////////////
// END OF CODE
// ///////////////////////////////////////////////////////////////////////////