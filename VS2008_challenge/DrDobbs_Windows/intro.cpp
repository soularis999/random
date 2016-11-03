// /////////////////////////////////////////////////////////////////////////////
// DR DOBB'S CHALLENGES
//
// Filename       : intro.cpp
// Date           : February 2008
//
// Description    : Refer to description in corresponding header.
//
// ///////////////////////////////////////////////////////////////////////////


// ///////////////////////////////////////////////////////////////////////////
// HEADERS (#include)
// ///////////////////////////////////////////////////////////////////////////
#include "intro.h"
#include "input.h"


// ///////////////////////////////////////////////////////////////////////////
// CONSTRUCTORS AND DESTRUCTORS
// ///////////////////////////////////////////////////////////////////////////
CIntro::CIntro() {
   // Create background sprite
   pBackground = new CSprite(0,0,SPRITE_TYPE_BACKGROUND);
   pBackground->AddImage("menu_instructions.png");
   pBackground->Unhide();

   // Initialize remaining members
   closeIntro = false;
   clickLeft  = false;
}

CIntro::~CIntro() {
   // Release all GUI controls
   delete pBackground;
}

// ///////////////////////////////////////////////////////////////////////////
// PUBLIC METHODS
// ///////////////////////////////////////////////////////////////////////////
void CIntro::Update() {
   // Check if any keys have been pressed
   if (CInput::AnyKeyPressed()) closeIntro = true;

   // Check if LMB was just released (ie. active-low)
   if (CInput::MouseButtonDown(DIM_LB)) {
      clickLeft = true; 
   } else {
      if (clickLeft) closeIntro = true;
   }
}


bool CIntro::Close() { return closeIntro; }

// ///////////////////////////////////////////////////////////////////////////
// END OF CODE
// ///////////////////////////////////////////////////////////////////////////
