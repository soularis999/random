// /////////////////////////////////////////////////////////////////////////////
// DR DOBB'S CHALLENGES
//
// Filename       : entity.h
// Date           : February 2008
//
// Description    : This file defines the CEntity class which is the parent
//                  class of all in-game entities.  All child entities must
//                  be based on this class.
//
//                  Init() must be called at the beginning of game level
//                  to ensure all static states are initialized before
//                  new level entities are created.  ReleaseAll() must be
//                  called at the end of a game level, either when CGame
//                  is deleted or a level is restarted (and therefore,
//                  entities are re-created).
//
// ///////////////////////////////////////////////////////////////////////////
#pragma once

// ///////////////////////////////////////////////////////////////////////////
// HEADERS (#include)
// ///////////////////////////////////////////////////////////////////////////
#include <vector>
#include "global.h"
#include "sprite.h"
#include "sound.h"

// ///////////////////////////////////////////////////////////////////////////
// CONSTANTS (#define)
// ///////////////////////////////////////////////////////////////////////////
#define TILE_OFFSETX             0
#define TILE_OFFSETY             12
#define ENTITY_OFFSETX           (TILE_OFFSETX+16)
#define ENTITY_OFFSETY           (TILE_OFFSETY+16)

#define ENTITY_TYPE_NONE        0
#define ENTITY_TYPE_GRASS       1
#define ENTITY_TYPE_GLUE        2
#define ENTITY_TYPE_TOKEN       3
#define ENTITY_TYPE_AIFLY       4
#define ENTITY_TYPE_AIWALK      5
#define ENTITY_TYPE_PLAYER      6

// ///////////////////////////////////////////////////////////////////////////
// CLASS DEFINITION
// ///////////////////////////////////////////////////////////////////////////
class CEntity {

   // ////////////////////////////////////////////////////////////////////////
   // PROTECTED/PRIVATE METHODS
   // ////////////////////////////////////////////////////////////////////////
   protected:
      // /////////////////////////////////////////////////////////////////////
      // STATIC COMPONENTS
      static std::vector<CEntity*> allEntities;
      static std::vector<CEntity*> allTerrain;
      static std::vector<CEntity*> allAI;
      static int  collectedTokens;
      static int  totalTokens;

      static int terrain[TILE_XCOUNT][TILE_YCOUNT];

      // /////////////////////////////////////////////////////////////////////
      // VARIABLES
      int   type;
      int   x;
      int   y;
      int   collisionX;
      int   collisionY;
      int   prevX;
      int   prevY;
      float velX;
      float velY;

      CSprite* pSpriteActive;
      CSprite* pSpriteInactive;

      // /////////////////////////////////////////////////////////////////////
      // METHODS
      bool overlaps(CEntity* pEntity, int minOverlap=0);
      bool overlaps(CEntity* pEntity, int xVal, int yVal, int minOverlap=0);
      bool overlapsY(CEntity* pEntity, int minOverlap=0);
      bool overlapsY(CEntity* pEntity, int xVal, int minOverlap);
      bool overlapsX(CEntity* pEntity, int minOverlap=0);
      bool overlapsX(CEntity* pEntity, int yVal, int minOverlap);

      bool onTileBoundary(int edge, int tolerance=0);
      bool onTileBoundary(int edge, int xVal, int yVal, int tolerance=0);

      virtual void update() = 0;


   // ////////////////////////////////////////////////////////////////////////
   // PUBLIC METHODS
   // ////////////////////////////////////////////////////////////////////////
   public:

      // /////////////////////////////////////////////////////////////////////
      // CONSTRUCTORS/DESTRUCTORS
      CEntity(int xVal, int yVal, int collX, int collY);
      virtual ~CEntity();

      // /////////////////////////////////////////////////////////////////////
      // METHODS
      void Move(int xVal, int yVal);
      void MoveRel(int xOff, int yOff);

      int GetX();
      int GetY();
      int GetTX(int tile=TILE_CENTER);
      int GetTX(int tile, int xVal);
      int GetTY(int tile=TILE_CENTER);
      int GetTY(int tile, int yVal);
      int GetCollisionX();
      int GetCollisionY();

      int GetType();


      // /////////////////////////////////////////////////////////////////////
      // STATIC METHODS
      static void Init();
      static void UpdateAll();
      static void ReleaseAll();
      static int  GetTerrain(unsigned int tx, unsigned int ty);
      static bool IsTerrain(unsigned int tx, unsigned int ty);
      static bool TokensCollected();

};


// ///////////////////////////////////////////////////////////////////////////
// END OF CODE
// ///////////////////////////////////////////////////////////////////////////