// /////////////////////////////////////////////////////////////////////////////
// DR DOBB'S CHALLENGES
//
// Filename       : mainmenu.cpp
// Date           : February 2008
//
// Description    : Refer to description in corresponding header.
//
// ///////////////////////////////////////////////////////////////////////////


// ///////////////////////////////////////////////////////////////////////////
// HEADERS (#include)
// ///////////////////////////////////////////////////////////////////////////
#include "mainmenu.h"
#include "input.h"
#include "level.h"
#include "entityPlayer.h"

// ///////////////////////////////////////////////////////////////////////////
// CONSTANTS (#define)
// ///////////////////////////////////////////////////////////////////////////

// Button ID offsets for each type
#define BUTTON_BASE_LEVEL     0
#define BUTTON_BASE_PLAYER    20
#define BUTTON_BASE_QUIT      25

// Layout definitions for level buttons
#define BUTTON_LEVEL_X0       34
#define BUTTON_LEVEL_Y0       272
#define BUTTON_LEVEL_COLUMNS  5
#define BUTTON_LEVEL_XOFFSET  65
#define BUTTON_LEVEL_YOFFSET  77

// X/Y Tolerances for mouse-to-button proximities
#define BUTTON_XTOL_CHARACTER       50
#define BUTTON_YTOL_CHARACTER       95
#define BUTTON_XTOL_LEVEL           24
#define BUTTON_YTOL_LEVEL           24
#define BUTTON_XTOL_QUIT            50
#define BUTTON_YTOL_QUIT            30

// ///////////////////////////////////////////////////////////////////////////
// CONSTRUCTORS AND DESTRUCTORS
// ///////////////////////////////////////////////////////////////////////////
CMainMenu::CMainMenu() {
   // Display version ID
   pVersion = new CText(0,580,SCREEN_WIDTH-5,30,VERSION_ID,15,FW_BOLD,false,DT_RIGHT,0xFFFFFFFF);

   // Create background sprite
   pBackground = new CSprite(0,0,SPRITE_TYPE_BACKGROUND);
   pBackground->AddImage("menu.png");
   pBackground->Unhide();

   // Create level buttons
   int x;
   int y;
   for (int i=0; i<20; i++) {
      // Calculate X/Y coordinate of current level button
      x = BUTTON_LEVEL_X0+(i%BUTTON_LEVEL_COLUMNS)*BUTTON_LEVEL_XOFFSET;
      y = BUTTON_LEVEL_Y0+(i/BUTTON_LEVEL_COLUMNS)*BUTTON_LEVEL_YOFFSET;

      // Create sprite for highlighted version of level button
      pHighlight[i] = new CSprite(0,0,SPRITE_TYPE_BACKGROUND+100);
      pHighlight[i]->AddImage("buttonGlow.png");
      pHighlight[i]->Move(x,y);

      // Create sprite for selected version of level button
      pSelected[i] = new CSprite(0,0,SPRITE_TYPE_BACKGROUND+100);
      pSelected[i]->AddImage("buttonSelected.png");
      pSelected[i]->Move(x,y);

      // Create level ID text
      char str[20];
      sprintf_s(str,20,"%i",i+1);
      pLevel[i] = new CText(x-13,y-12,64,64,str,20,FW_BOLD,false,DT_CENTER|DT_VCENTER,0xFF880000);

      // Determine appropriate score text from level data
      int csec = CLevel::GetLevel(i)->GetScore()/10;
      if (csec == 0) {
         sprintf_s(str,20,"N/A");
      } else {
         int sec = csec/100;
         int min = sec/60;
         sprintf_s(str,20,"%i:%02i.%02i",min,sec%60,csec%100);
      }

      // Create level score text
      pScore[i] = new CText(x-5,y+45,50,25,str,15,FW_NORMAL,false,DT_CENTER|DT_VCENTER,0xFF880000);

   }

   // Create sprite for highlighted version for each character
   pHighlight[20] = new CSprite(0,0,SPRITE_TYPE_BACKGROUND+100);
   pHighlight[20]->AddImage("mummyGlow.png");
   pHighlight[20]->Move(52,13);
   pHighlight[21] = new CSprite(0,0,SPRITE_TYPE_BACKGROUND+100);
   pHighlight[21]->AddImage("pirateGlow.png");
   pHighlight[21]->Move(136,37);
   pHighlight[22] = new CSprite(0,0,SPRITE_TYPE_BACKGROUND+100);
   pHighlight[22]->AddImage("dobbsGlow.png");
   pHighlight[22]->Move(337,92);
   pHighlight[23] = new CSprite(0,0,SPRITE_TYPE_BACKGROUND+100);
   pHighlight[23]->AddImage("cowboyGlow.png");
   pHighlight[23]->Move(478,37);
   pHighlight[24] = new CSprite(0,0,SPRITE_TYPE_BACKGROUND+100);
   pHighlight[24]->AddImage("SalamanderGlow.png");
   pHighlight[24]->Move(568,33);

   // Create sprite for selected version for each character
   // NOTE:  Dobb (#22) selected (ie. unhidden) by default
   pSelected[20] = new CSprite(0,0,SPRITE_TYPE_BACKGROUND+105);
   pSelected[20]->AddImage("mummySelect.png");
   pSelected[20]->Move(52,13);
   pSelected[21] = new CSprite(0,0,SPRITE_TYPE_BACKGROUND+105);
   pSelected[21]->AddImage("pirateSelect.png");
   pSelected[21]->Move(136,37);
   pSelected[22] = new CSprite(0,0,SPRITE_TYPE_BACKGROUND+105);
   pSelected[22]->AddImage("dobbsSelect.png");
   pSelected[22]->Move(337,92);
   pSelected[22]->Unhide();
   pSelected[23] = new CSprite(0,0,SPRITE_TYPE_BACKGROUND+105);
   pSelected[23]->AddImage("cowboySelect.png");
   pSelected[23]->Move(478,37);
   pSelected[24] = new CSprite(0,0,SPRITE_TYPE_BACKGROUND+105);
   pSelected[24]->AddImage("SalamanderSelect.png");
   pSelected[24]->Move(568,33);

   // Create sprite for highlighted version for QUIT button
   pHighlight[25] = new CSprite(0,0,SPRITE_TYPE_BACKGROUND+100);
   pHighlight[25]->AddImage("quitGlow.png");
   pHighlight[25]->Move(645,532);

   // Create sprite for selected version for QUIT button
   pSelected[25] = new CSprite(0,0,SPRITE_TYPE_BACKGROUND+105);
   pSelected[25]->AddImage("quitSelected.png");
   pSelected[25]->Move(645,532);

   // Initialize highlighted and selected level/player
   highlighted    = -1;
   selectedLevel  = -1;
   selectedPlayer = CHARACTER_DOBB;

   // Create sounds for mouse click and rollover
   pClick      = new CSound("click.wav");
   pRollover   = new CSound("rollover.wav");

   // Initialize remaining members
   clickLeft   = false;
   startGame   = false;
   quitGame    = false;
}

CMainMenu::~CMainMenu() {
   // Release all GUI controls
   delete pBackground;
   for (int i=0; i<26; i++) {
      delete pHighlight[i];
      delete pSelected[i];
      if (i < 20) {
         delete pScore[i];
         delete pLevel[i];
      }
   }

   // Release sounds
   delete pClick;
   delete pRollover;

   // Release version text
   delete pVersion;
}

// ///////////////////////////////////////////////////////////////////////////
// PROTECTED/PRIVATE METHODS
// ///////////////////////////////////////////////////////////////////////////
void CMainMenu::handleMouse() {
   // Obtain current X/Y coordinates
   int mx = CInput::MouseX();
   int my = CInput::MouseY();

   // Initialize new highlight ID
   int newHighlight = -1;

   // Check within "character selection" rectangle
   // NOTE:  Approximately, the upper half of the screen
   if ((mx >= 50) && (mx <= 750) && (my >= 50) && (my <= 265)) {
      
      // Check along center-Y for 1st and 5th character
      if (abs(my - 145) < BUTTON_YTOL_CHARACTER) {

         // Check along center-X for 1st character
         if (abs(mx - 130) < BUTTON_XTOL_CHARACTER) {
            // Highlight pPlayer0
            newHighlight = 20;

         // Check along center-X for 5th character
         } else if (abs(mx - 670) < BUTTON_XTOL_CHARACTER) {
            // Highlight pPlayer4
            newHighlight = 24;
         }
      }

      // Check along center-Y for 2nd and 4th character
      if (abs(my - 165) < BUTTON_YTOL_CHARACTER) {

         // Check along center-X for 2nd character
         if (abs(mx - 265) < BUTTON_XTOL_CHARACTER) {
            // Highlight pPlayer1
            newHighlight = 21;

         // Check along center-X for 4th character
         } else if (abs(mx - 535) < BUTTON_XTOL_CHARACTER) {
            // Highlight pPlayer3
            newHighlight = 23;
         }
      }

      // Check along center-Y for 3rd character
      if (abs(my - 185) < BUTTON_YTOL_CHARACTER) {

         // Check along center-X for 3rd character
         if (abs(mx - 400) < BUTTON_XTOL_CHARACTER) {
            // Highlight pPlayer2
            newHighlight = 22;
         }
      }

   // Check within "level selection" rectangle
   // NOTE:  Approximately, the bottom-left quarter of the screen
   } else if ((mx >= 25) && (mx <= 350) && (my >= 265) && (my <= 555)) {
      int row = -1;
      int col = -1;

      // Check along 4 center-Y's to determine row
      if (abs(my - 293) < BUTTON_YTOL_LEVEL) {
         row = 0;
      } else if (abs(my - 371) < BUTTON_YTOL_LEVEL) {
         row = 1;
      } else if (abs(my - 451) < BUTTON_YTOL_LEVEL) {
         row = 2;
      } else if (abs(my - 529) < BUTTON_YTOL_LEVEL) {
         row = 3;
      }

      // Check along 5 center-X's to determine column
      if (abs(mx - 53) < BUTTON_XTOL_LEVEL) {
         col = 0;
      } else if (abs (mx - 121) < BUTTON_XTOL_LEVEL) {
         col = 1;
      } else if (abs (mx - 186) < BUTTON_XTOL_LEVEL) {
         col = 2;
      } else if (abs (mx - 253) < BUTTON_XTOL_LEVEL) {
         col = 3;
      } else if (abs (mx - 318) < BUTTON_XTOL_LEVEL) {
         col = 4;
      }

      // If row and column selected, then calculate new highlight ID
      if ((row != -1) && (col != -1)) {
         newHighlight = row*5 + col;
      }

   // Check within "QUIT" rectangle
   // NOTE:  Approximately, the very bottom-right corner of the screen
   } else if ((abs(mx - 690) < BUTTON_XTOL_QUIT) && (abs(my - 560) < BUTTON_YTOL_QUIT)) {
      newHighlight = BUTTON_BASE_QUIT;
   }

   // Check if new highlight is found
   if (newHighlight != highlighted) {
      // If current highlight is not -1, then hide the corresponding sprite
      if (highlighted != -1) pHighlight[highlighted]->Hide();

      // Assign the new highlight value
      highlighted = newHighlight;

      // If new highlight is not -1, then unhide the corresponding sprite
      // and play the rollover sound
      if (highlighted != -1) {
         pHighlight[highlighted]->Unhide();
         pRollover->Play();
      }
   }
}


// ///////////////////////////////////////////////////////////////////////////
// PUBLIC METHODS
// ///////////////////////////////////////////////////////////////////////////
void CMainMenu::Update() {
   // Update the highlighted value for the current mouse location
   handleMouse();

   // Handle the left mouse button
   if (CInput::MouseButtonDown(DIM_LB)) {

      // Check if a button is currently highlighted
      // NOTE:  The order of highlight value checks is relevant
      //        in this IF-ELSE form.  Using the ">" comparison
      //        means values must be checked from HIGH to LOW.
      if (highlighted != -1) {
         // If mouse is over QUIT, unhide the selected QUIT sprite
         if (highlighted == BUTTON_BASE_QUIT) {
            pSelected[BUTTON_BASE_QUIT]->Unhide();

         // If mouse is over a character, hide the currently selected
         // character, unhide the highlighted character, and update
         // the selected player.
         } else if (highlighted >= BUTTON_BASE_PLAYER) {
            pSelected[BUTTON_BASE_PLAYER + selectedPlayer]->Hide();
            selectedPlayer = highlighted - BUTTON_BASE_PLAYER;
            pSelected[BUTTON_BASE_PLAYER + selectedPlayer]->Unhide();

         // Otherwise, a level button must be highlighted.  In which case,
         // hide the currently selected level, if appropriate, unhide
         // the highlighted level, and update the selected level.
         } else {
            if (selectedLevel != -1) pSelected[selectedLevel]->Hide();
            selectedLevel = highlighted;
            pSelected[selectedLevel]->Unhide();
         }

         // If button just pressed, then play mouse click sound
         if (!clickLeft) pClick->Play();

      // If the mouse button is pressed but nothing is highlighted when a
      // a level is previously selected, hide the currently selected level.
      } else if (selectedLevel != -1) {
         pSelected[selectedLevel]->Hide();
         selectedLevel = -1;

      // Otherwise, hide the selected quit button
      } else {
         pSelected[BUTTON_BASE_QUIT]->Hide();
      }

      // Assert the clickLeft flag
      clickLeft = true;

   // Otherwise, mouse button must be released
   } else {
      // For "active-low" buttons, must check when button is first released
      if (clickLeft) {
         // If QUIT button is highlighted, then quit application
         if (highlighted == BUTTON_BASE_QUIT) {
            quitGame = true;

         // Otherwise, if level has been selected, then start the game
         } else if (selectedLevel != -1) {
            startGame = true;
         }
      }

      // Reset the clickLeft flag
      clickLeft = false;
   }

   // Check for ESC to exit the application
   if (CInput::KeyPressed(DIK_ESCAPE)) { quitGame = true; }
}


bool CMainMenu::Start() { return startGame; }
bool CMainMenu::Quit() { return quitGame; }
int CMainMenu::GetLevel() { return selectedLevel; }
int CMainMenu::GetPlayer() { return selectedPlayer; }


void CMainMenu::Hide() {
   // This method is used to hide all main menu components between
   // playing levels.  Hide all sprites and text.
   pBackground->Hide();
   for (int i=0; i<26; i++) {
      pHighlight[i]->Hide();
      pSelected[i]->Hide();
      if (i < 20) {
         pScore[i]->Hide();
         pLevel[i]->Hide();
      }
   }
   pVersion->Hide();
}

void CMainMenu::Unhide() {
   // This method is used to unhide all main menu components when not
   // playing levels.  Unhide background and all text.
   pBackground->Unhide();
   for (int i=0; i<20; i++) {
      pScore[i]->Unhide();
      pLevel[i]->Unhide();
   }
   pVersion->Unhide();

   // Unhide only the selected player sprite
   pSelected[BUTTON_BASE_PLAYER + selectedPlayer]->Unhide();

   // Reset startGame flag
   startGame = false;

   // Update text for score of last level played
   int csec = CLevel::GetLevel(selectedLevel)->GetScore()/10;
   if (csec == 0) {
      pScore[selectedLevel]->SetText("N/A");
   } else {
      int sec = csec/100;
      int min = sec/60;
      pScore[selectedLevel]->SetText("%i:%02i.%02i",min,sec%60,csec%100);
   }

   // Reset selected level
   selectedLevel = -1;

}

// ///////////////////////////////////////////////////////////////////////////
// END OF CODE
// ///////////////////////////////////////////////////////////////////////////