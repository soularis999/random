// /////////////////////////////////////////////////////////////////////////////
// DR DOBB'S CHALLENGES
//
// Filename       : entityTerrainGlue.h
// Date           : February 2008
//
// Description    : This file defines the CEntityTerrainGlue class for glue
//                  terrain.  The constructor is really the only relevant
//                  member of this class, randomly selecting the tile image
//                  to use, based on whether or not there is terrain to the
//                  immediate left and/or right of it.
//
// ///////////////////////////////////////////////////////////////////////////
#pragma once

// ///////////////////////////////////////////////////////////////////////////
// HEADERS (#include)
// ///////////////////////////////////////////////////////////////////////////
#include "entityTerrain.h"


// ///////////////////////////////////////////////////////////////////////////
// CLASS DEFINITION
// ///////////////////////////////////////////////////////////////////////////
class CEntityTerrainGlue : public CEntityTerrain {
   // ////////////////////////////////////////////////////////////////////////
   // PUBLIC METHODS
   // ////////////////////////////////////////////////////////////////////////
   public:
      // /////////////////////////////////////////////////////////////////////
      // CONSTRUCTORS/DESTRUCTORS
      CEntityTerrainGlue(int xVal, int yVal, bool endLeft, bool endRight);
      ~CEntityTerrainGlue();
};

// ///////////////////////////////////////////////////////////////////////////
// END OF CODE
// ///////////////////////////////////////////////////////////////////////////