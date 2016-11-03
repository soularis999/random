// /////////////////////////////////////////////////////////////////////////////
// DR DOBB'S CHALLENGES
//
// Filename       : entityTerrainGlue.cpp
// Date           : February 2008
//
// Description    : Refer to description in corresponding header.
//
// ///////////////////////////////////////////////////////////////////////////


// ///////////////////////////////////////////////////////////////////////////
// HEADERS (#include)
// ///////////////////////////////////////////////////////////////////////////
#include "entityTerrainGlue.h"

// ///////////////////////////////////////////////////////////////////////////
// CONSTANTS (#define)
// ///////////////////////////////////////////////////////////////////////////

// Define the number of images for each tile type (for randomizer)
#define GLUE_SINGLE_COUNT  4
#define GLUE_MID_COUNT     6
#define GLUE_LEFT_COUNT    2
#define GLUE_RIGHT_COUNT   2


// ///////////////////////////////////////////////////////////////////////////
// CONSTRUCTORS AND DESTRUCTORS
// ///////////////////////////////////////////////////////////////////////////
CEntityTerrainGlue::CEntityTerrainGlue(int xVal, int yVal, bool endLeft, bool endRight) : CEntityTerrain(xVal,yVal,ENTITY_TYPE_GLUE) {
   char filename[MAX_PATH];

   // Use single-tile images if terrain does not exist to the left or right
   if (endLeft && endRight) {
      sprintf_s(filename,MAX_PATH,"glueSingle-%i.png",rand()%GLUE_SINGLE_COUNT);

   // Use left-edge images if terrain does only exists on right
   } else if (endLeft) {
      sprintf_s(filename,MAX_PATH,"glueLEdge-%i.png",rand()%GLUE_LEFT_COUNT);

   // Use right-edge images if terrain does only exists on left
   } else if (endRight) {
      sprintf_s(filename,MAX_PATH,"glueREdge-%i.png",rand()%GLUE_RIGHT_COUNT);

   // Use middle images if terrain exists on both left and right
   } else {
      sprintf_s(filename,MAX_PATH,"glueTile-%i.png",rand()%GLUE_MID_COUNT);
   }

   // Create sprite with selected image
   pSpriteTile = new CSprite(TERRAIN_CX,TERRAIN_CY,SPRITE_TYPE_TERRAIN);
   pSpriteTile->AddImage(filename);
   pSpriteTile->Unhide();
   pSpriteTile->Move(x,y);
}

CEntityTerrainGlue::~CEntityTerrainGlue() {
}

// ///////////////////////////////////////////////////////////////////////////
// END OF CODE
// ///////////////////////////////////////////////////////////////////////////
