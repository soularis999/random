// /////////////////////////////////////////////////////////////////////////////
// DR DOBB'S CHALLENGES
//
// Filename       : entityTerrainGrass.cpp
// Date           : February 2008
//
// Description    : Refer to description in corresponding header.
//
// ///////////////////////////////////////////////////////////////////////////


// ///////////////////////////////////////////////////////////////////////////
// HEADERS (#include)
// ///////////////////////////////////////////////////////////////////////////
#include "entityTerrainGrass.h"

// ///////////////////////////////////////////////////////////////////////////
// CONSTANTS (#define)
// ///////////////////////////////////////////////////////////////////////////

// Define the number of images for each tile type (for randomizer)
#define GRASS_SINGLE_COUNT 4
#define GRASS_MID_COUNT    10
#define GRASS_LEFT_COUNT   3
#define GRASS_RIGHT_COUNT  3


// ///////////////////////////////////////////////////////////////////////////
// CONSTRUCTORS AND DESTRUCTORS
// ///////////////////////////////////////////////////////////////////////////
CEntityTerrainGrass::CEntityTerrainGrass(int xVal, int yVal, bool endLeft, bool endRight) : CEntityTerrain(xVal,yVal,ENTITY_TYPE_GRASS) {
   char filename[MAX_PATH];

   // Use single-tile images if terrain does not exist to the left or right
   if (endLeft && endRight) {
      sprintf_s(filename,MAX_PATH,"grassSingle-%i.png",rand()%GRASS_SINGLE_COUNT);

   // Use left-edge images if terrain does only exists on right
   } else if (endLeft) {
      sprintf_s(filename,MAX_PATH,"grassLEdge-%i.png",rand()%GRASS_LEFT_COUNT);

   // Use right-edge images if terrain does only exists on left
   } else if (endRight) {
      sprintf_s(filename,MAX_PATH,"grassREdge-%i.png",rand()%GRASS_RIGHT_COUNT);

   // Use middle images if terrain exists on both left and right
   } else {
      sprintf_s(filename,MAX_PATH,"grassTile-%i.png",rand()%GRASS_MID_COUNT);
   }

   // Create sprite with selected image
   pSpriteTile = new CSprite(TERRAIN_CX,TERRAIN_CY,SPRITE_TYPE_TERRAIN);
   pSpriteTile->AddImage(filename);
   pSpriteTile->Unhide();
   pSpriteTile->Move(x,y);
}

CEntityTerrainGrass::~CEntityTerrainGrass() {
}

// ///////////////////////////////////////////////////////////////////////////
// END OF CODE
// ///////////////////////////////////////////////////////////////////////////
