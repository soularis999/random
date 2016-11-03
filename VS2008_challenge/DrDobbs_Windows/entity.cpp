// /////////////////////////////////////////////////////////////////////////////
// DR DOBB'S CHALLENGES
//
// Filename       : entity.cpp
// Date           : February 2008
//
// Description    : Refer to description in corresponding header.
//
// ///////////////////////////////////////////////////////////////////////////


// ///////////////////////////////////////////////////////////////////////////
// HEADERS (#include)
// ///////////////////////////////////////////////////////////////////////////
#include "entity.h"

// ///////////////////////////////////////////////////////////////////////////
// STATIC INITIALIZATION
// ///////////////////////////////////////////////////////////////////////////
std::vector<CEntity*> CEntity::allEntities;
std::vector<CEntity*> CEntity::allTerrain;
std::vector<CEntity*> CEntity::allAI;

int CEntity::terrain[TILE_XCOUNT][TILE_YCOUNT];
int CEntity::totalTokens = 0;
int CEntity::collectedTokens = 0;


// ///////////////////////////////////////////////////////////////////////////
// CONSTRUCTORS AND DESTRUCTORS
// ///////////////////////////////////////////////////////////////////////////
CEntity::CEntity(int xVal, int yVal, int collX, int collY) {
   // Append entity to static entity list
   allEntities.push_back(this);

   // Copy parameters into local members
   x = prevX   = xVal;
   y = prevY   = yVal;
   collisionX  = collX;
   collisionY  = collY;

   // Initialize remaining members
   type              = ENTITY_TYPE_NONE;
   velX              = 0.0;
   velY              = 0.0;
   pSpriteActive     = NULL;
   pSpriteInactive   = NULL;
}

CEntity::~CEntity() {
}

// ///////////////////////////////////////////////////////////////////////////
// PROTECTED/PRIVATE METHODS
// ///////////////////////////////////////////////////////////////////////////
bool CEntity::overlapsX(CEntity* pEntity, int xVal, int minOverlap) {
   // Ignore if entity does not exists
   if (pEntity == NULL) return false;

   // Calculate left/right x-coordinates for current and target entity
   int left1   = xVal - collisionX;
   int right1  = xVal + collisionX;
   int left2   = pEntity->x - pEntity->collisionX;
   int right2  = pEntity->x + pEntity->collisionX;

   // If right-side of entity1 is left of left-side of entity2, then no overlap
   if (right1 <= left2 + minOverlap) return false;

   // If right-side of entity2 is left of left-side of entity2, then no overlap
   if (right2 <= left1 + minOverlap) return false;

   // Otherwise, must be overlapping on the X-axis
   return true;
}

bool CEntity::overlapsY(CEntity* pEntity, int yVal, int minOverlap) {
   // Ignore if entity does not exists
   if (pEntity == NULL) return false;

   // Calculate top/bottom y-coordinates for current and target entity
   int top1    = yVal - collisionY;
   int bottom1 = yVal + collisionY;
   int top2    = pEntity->y - pEntity->collisionY;
   int bottom2 = pEntity->y + pEntity->collisionY;

   // If bottom of entity1 is above top of entity2, then no overlap
   if (bottom1 <= top2 + minOverlap) return false;

   // If bottom of entity2 is above top of entity1, then no overlap
   if (bottom2 <= top1 + minOverlap) return false;

   // Otherwise, must be overlapping on the Y-axis
   return true;
}

bool CEntity::overlaps(CEntity* pEntity, int xVal, int yVal, int minOverlap) {
   // Check for x/y overlap
   return (overlapsX(pEntity, xVal, minOverlap) && overlapsY(pEntity, yVal, minOverlap));
}

bool CEntity::overlapsX(CEntity* pEntity, int minOverlap) {
   // If no xVal specified, then use the current x to check for x-axis overlaps
   return overlapsX(pEntity,x,minOverlap);
}
bool CEntity::overlapsY(CEntity* pEntity, int minOverlap) {
   // If no yVal specified, then use the current y to check for y-axis overlaps
   return overlapsY(pEntity,y,minOverlap);
}
bool CEntity::overlaps(CEntity* pEntity, int minOverlap) {
   // If no xVal/yVal specified, then use the current x/y to check for overlaps
   return overlaps(pEntity,x,y,minOverlap);
}

bool CEntity::onTileBoundary(int edge, int xVal, int yVal, int tolerance) {
   int tile;
   int diff;

   // Determine if entity is currently on the specified tile
   // boundary, based on the current X/Y and corresponding
   // collision offsets.
   switch(edge) {
      case DIR_LEFT:
         // Compare X of left-edge TX to actual left-edge X
         tile = GetTX(TILE_LOW,xVal);
         diff = (xVal - collisionX) - (tile*TILE_WIDTH + TILE_OFFSETX);
         break;
      case DIR_RIGHT:
         // Compare X of right-edge TX+1 to actual right-edge X
         tile = GetTX(TILE_HIGH,xVal);
         diff = ((tile+1)*TILE_WIDTH + TILE_OFFSETX) - (xVal + collisionX);
         break;
      case DIR_UP:
         // Compare Y of top-edge TY to actual top-edge Y
         tile = GetTY(TILE_LOW,yVal);
         diff = (yVal - collisionY) - (tile*TILE_HEIGHT + TILE_OFFSETY);
         break;
      case DIR_DOWN:
         // Compare Y of bottom-edge TY+1 to actual bottom-edge Y
         tile = GetTY(TILE_HIGH,yVal);
         diff = ((tile+1)*TILE_HEIGHT + TILE_OFFSETY) - (yVal + collisionY);
         break;
   }

   // Check if difference is within the specified tolerance
   return (diff <= tolerance);
}

bool CEntity::onTileBoundary(int edge, int tolerance) {
   // If no xVal/yVal specified, then use the current x/y to check boundary
   return onTileBoundary(edge,x,y,tolerance);
}


// ///////////////////////////////////////////////////////////////////////////
// PUBLIC METHODS
// ///////////////////////////////////////////////////////////////////////////

// Position Control
void CEntity::Move(int xVal, int yVal) {
   x = xVal;
   y = yVal;
}

void CEntity::MoveRel(int xOff, int yOff) {
   x += xOff;
   y += yOff;
}

int CEntity::GetX() { return x; }
int CEntity::GetY() { return y; }
int CEntity::GetCollisionX() { return collisionX; }
int CEntity::GetCollisionY() { return collisionY; }

int CEntity::GetTX(int tile, int xVal) {
   // Determine TX for:
   //    TILE_LOW:      left-edge of entity
   //    TILE_CENTER:   center of entity (ie. current x value)
   //    TILE_HIGH:     right-edge of entity
   int tmpX;
   if (tile == TILE_LOW) tmpX = xVal - TILE_OFFSETX - collisionX + 1;
   else if (tile == TILE_HIGH) tmpX = xVal - TILE_OFFSETX + collisionX - 1;
   else tmpX = xVal - TILE_OFFSETX;

   return tmpX/TILE_WIDTH;
}

int CEntity::GetTX(int tile) {
   // If no xVal specified, then use the current x for tile calculation
   return GetTX(tile,x);
}

int CEntity::GetTY(int tile, int yVal) {
   // Determine TY for:
   //    TILE_LOW:      top-edge of entity
   //    TILE_CENTER:   center of entity (ie. current y value)
   //    TILE_HIGH:     bottom-edge of entity
   int tmpY;
   if (tile == TILE_LOW) tmpY = yVal - TILE_OFFSETY - collisionY + 1;
   else if (tile == TILE_HIGH) tmpY = yVal - TILE_OFFSETY + collisionY - 1;
   else tmpY = yVal - TILE_OFFSETY;

   // Increment tmpY by TILE_HEIGHT if negative to ensure
   // correct tile is calculated.  Without this increment,
   // TY would be counted "-2 -1 0 0 1 2", rather than
   // "-3 -2 -1 0 1 2".
   if (tmpY < 0) tmpY -= TILE_HEIGHT;

   // Calculate tile from tmpY
   return tmpY/TILE_HEIGHT;
}

int CEntity::GetTY(int tile) {
   // If no yVal specified, then use the current y for tile calculation
   return GetTY(tile,y);
}

int CEntity::GetType() { return type; }

// ///////////////////////////////////////////////////////////////////////////
// STATIC METHODS
// ///////////////////////////////////////////////////////////////////////////
void CEntity::Init() {
   // Clear terrain array
   ZeroMemory(terrain,sizeof(terrain));

   // Initialize vectors
   allEntities.clear();
   allAI.clear();
   allTerrain.clear();

   // Initialize token counts
   collectedTokens = 0;
   totalTokens = 0;
}

void CEntity::ReleaseAll() {
   // Loop through all entities and delete
   std::vector<CEntity*>::iterator e;
   for(e = allEntities.begin(); e != allEntities.end(); e++) {
      delete (*e);
   }
}

void CEntity::UpdateAll() {
   // Loop through all entities
   std::vector<CEntity*>::iterator e;
   for(e = allEntities.begin(); e != allEntities.end(); e++) {
      // Update entity state
      (*e)->update();

      // Copy current x/y coordinates to previous coordinates
      (*e)->prevX = (*e)->x;
      (*e)->prevY = (*e)->y;
   }
}

bool CEntity::TokensCollected() { return (collectedTokens == totalTokens); }

int CEntity::GetTerrain(unsigned int tx, unsigned int ty) {
   // Check if TX/TY within tile boundaries
   if ((tx >= TILE_XCOUNT) || (ty >= TILE_YCOUNT)) return 0;
   
   // Return terrain[][] value
   return terrain[tx][ty];
}
bool CEntity::IsTerrain(unsigned int tx, unsigned int ty) {
   // Check if TX/TY within tile boundaries
   if ((tx >= TILE_XCOUNT) || (ty >= TILE_YCOUNT)) return false;

   // Return TRUE if terrain[][] is non-zero
   return (terrain[tx][ty] != 0);
}


// ///////////////////////////////////////////////////////////////////////////
// END OF CODE
// ///////////////////////////////////////////////////////////////////////////
