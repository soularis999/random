// /////////////////////////////////////////////////////////////////////////////
// DR DOBB'S CHALLENGES
//
// Filename       : level.cpp
// Date           : February 2008
//
// Description    : Refer to description in corresponding header.
//
// ///////////////////////////////////////////////////////////////////////////


// ///////////////////////////////////////////////////////////////////////////
// HEADERS (#include)
// ///////////////////////////////////////////////////////////////////////////
#include "level.h"
#include "entity.h"


// ///////////////////////////////////////////////////////////////////////////
// CONSTANTS (#define)
// ///////////////////////////////////////////////////////////////////////////
#define LEVEL_COUNT  20


// ///////////////////////////////////////////////////////////////////////////
// STATIC INITIALIZATION
// ///////////////////////////////////////////////////////////////////////////
std::vector<CLevel*> CLevel::allLevels;


// ///////////////////////////////////////////////////////////////////////////
// CONSTRUCTORS AND DESTRUCTORS
// ///////////////////////////////////////////////////////////////////////////
CLevel::CLevel(int level) {
   // Append level to vector
   allLevels.push_back(this);

   // Initialize tiles and score
   ZeroMemory(allTiles,sizeof(allTiles));
   score = 0;

   // Read corresponding level file
   char fn[MAX_PATH];
   sprintf_s(fn,MAX_PATH,"level%i.txt",level+1);
   read(fn);
}

CLevel::~CLevel() {
}


// ///////////////////////////////////////////////////////////////////////////
// PROTECTED/PRIVATE METHODS
// ///////////////////////////////////////////////////////////////////////////
void CLevel::initBasic() {
   // When a level file does not exist or is invalid, create a basic level
   // with just a platform on the bottom row, the player, and one token.

   // Clear existing tile array
   ZeroMemory(allTiles,sizeof(allTiles));

   // Create platform at bottom of screen
   for (int x=0; x<TILE_XCOUNT; x++) {
      allTiles[x][TILE_YCOUNT-1] = ENTITY_TYPE_GRASS;
   }

   // Create token
   allTiles[4][TILE_YCOUNT-2] = ENTITY_TYPE_TOKEN;

   // Create player
   allTiles[20][TILE_YCOUNT-2] = ENTITY_TYPE_PLAYER;
}

void CLevel::read(char* file) {
   FILE* fd;

   // Ensure level file exists and can be opened
   if (fopen_s(&fd,file,"r") != 0) {
      // If not, create the default basic level
      Log("CLevel()  Level file '%s' does not exist.\n", file);
      initBasic();
   } else {
      // Initialize current tile
      int tx = 0;
      int ty = 0;

      // Initialize AI counters
      int aiCurrentTotal = 0; // Total AI directions found after tile data
      int aiCurrentLine  = 0; // Total AI directions found on current line
      int aiLine         = 0; // Total AI defined on current line

      // Initialize line content flags
      bool isComment = false; // Indicates comment to be ignored
      bool isData    = false; // Indicates data, but not necessarily for tile
      bool isTile    = false; // Indicates tile data

      // Initialize level validity flags
      bool hasToken  = false;
      bool hasPlayer = false;

      // Obtain first character in level file
      char ch = fgetc(fd);

      // Loop through file until EOF reached or last tile row read
      while ((ch != EOF) && (ty < TILE_YCOUNT)) {

         // If current character is '\n', reset for next line
         if (ch == '\n') {
            tx = 0;

            // Increment total AI directions found by total AI defined
            // on line (rather than "AI directions" found) to ensure
            // unspecified AI keep using default directions.
            aiCurrentTotal += aiLine;

            // Reset AI line counters
            aiCurrentLine  = 0;
            aiLine         = 0;

            // Only increment TX if not a comment line
            // NOTE: This ensures the level file can include as many comment
            //       lines as needed without affecting the row count
            if (!isComment) ty++;
            isComment = false;
            isData    = false;
            isTile    = false;

         // If not already flagged as a comment line, read data as a tile row
         } else if (!isComment) {
            // Flag row as a comment line if first character in row is '#'
            if ((tx == 0) && (ch == '#')) {
               isComment = true;

            // Flag remaining data in row as tile data if character is '|'
            // NOTE: This allows for a row counter before data without
            //       affecting level data.
            // NOTE: Subsequent '|' found after data indicates post-tile data;
            //       in this case, AI directional specificaitons.
            } else if (ch == '|') {
               isData = true;
               isTile = !isTile;

            // If row location flagged as tile data, parse data
            } else if (isData) {
               // If current TX within tile boundaries and flagged as tile
               // data, assign to allTiles[][]
               if (isTile && (tx < TILE_XCOUNT)) {
                  switch(ch) {
                     case 'G':
                        allTiles[tx][ty] = ENTITY_TYPE_GRASS;
                        break;
                     case 'S':
                        allTiles[tx][ty] = ENTITY_TYPE_GLUE;
                        break;
                     case 'F':
                        allTiles[tx][ty] = ENTITY_TYPE_AIFLY;

                        // Assign initial direction to default (DOWN)
                        aiDirection.push_back(DIR_DOWN);
                        aiLine++;
                        break;
                     case 'W':
                        allTiles[tx][ty] = ENTITY_TYPE_AIWALK;

                        // Assign initial direction to default (LEFT)
                        aiDirection.push_back(DIR_LEFT);
                        aiLine++;
                        break;
                     case 'T':
                        allTiles[tx][ty] = ENTITY_TYPE_TOKEN;
                        hasToken = true;
                        break;
                     case 'P':
                        allTiles[tx][ty] = ENTITY_TYPE_PLAYER;
                        hasPlayer = true;
                        break;
                     default:
                        allTiles[tx][ty] = ENTITY_TYPE_NONE;
                        break;
                  }

               // Otherwise, if not tile data (but isData=true), then assume
               // subsequent data is AI directional information.
               } else if (!isTile) {

                  // Ensure directions for all AI have not already been
                  // specified across entire level file and that all AI
                  // for the current line have not already been specified.
                  if ((aiCurrentTotal < (int)aiDirection.size())
                        && (aiCurrentLine < aiLine)) {

                     // Ensure data specifies a valid direction [0,7], where
                     // directions < 4 represent counter-clockwise and >= 4
                     // represent clockwise.
                     if ((ch >= '0') && (ch <= '7')) {

                        // If so, reassign aiDirection[] to new direction
                        aiDirection[aiCurrentTotal+aiCurrentLine] = ch - '0';
                     }

                     // Increment AI-per-line counter to ensure directions are
                     // not specified for more AI than there is on the current
                     // line.
                     aiCurrentLine++;
                  }
               }

               // Increment x column counter
               tx++;
            }
         }

         // Obtain next character in file
         ch = fgetc(fd);
      }

      // Close level file
      fclose(fd);

      // Check if level is valid (ie. must have player location
      // and at least one token.
      if (!hasToken || !hasPlayer) {
         Log("CLevel()  Level file '%s' invalid. All levels must have a player and 1+ tokens.\n", file);
         initBasic();
      }
   }
}

// ///////////////////////////////////////////////////////////////////////////
// PUBLIC METHODS
// ///////////////////////////////////////////////////////////////////////////
int CLevel::GetTile(unsigned int tx, unsigned int ty) {
   // Ensure that TX is bound to [0,TILE_XCOUNT-1] and
   // TY is bound to [0,TILE_YCOUNT-1]
   if ((tx < TILE_XCOUNT) && (ty < TILE_YCOUNT)) return allTiles[tx][ty];

   // Otherwise, simple return nothing
   else return ENTITY_TYPE_NONE;
}

int CLevel::GetAIDirection(unsigned int aiID) {
   // Ensure specified AI exists in level.  If so, return stored direction
   if (aiID < aiDirection.size()) return aiDirection[aiID];

   // Otherwise, simply return 0
   else return 0;
}

int CLevel::GetScore() { return score; }

bool CLevel::UpdateScore(int newScore) {
   // Save score if current score is zero (ie. incomplete) or 
   // greater than the new score (ie. slower time)
   if ((score == 0) || (score > newScore)) {
      score = newScore;
      SaveScores();
      Log("CLevel()  Updated score to %i from %i.\n", newScore, score);
      return true;
   } else {
      Log("CLevel()  Ignored score of %i (current = %i).\n", newScore, score);
      return false;
   }
}


// ///////////////////////////////////////////////////////////////////////////
// STATIC  METHODS
// ///////////////////////////////////////////////////////////////////////////
void CLevel::Init() {
   Log("Initializing CLevel...\n");

   // Load all levels from "level*.txt" data files
   Log("CLevel()  Loading level data files.\n");
   CLevel* pLevel;
   for (int l=0; l<LEVEL_COUNT; l++) pLevel = new CLevel(l);

   // Load all scores from "scores.dat" file
   FILE* fd;
   Log("CLevel()  Loading scores data file.\n");
   if (fopen_s(&fd,"scores.dat","rb") != 0) {
      Log("CLevel()     'scores.dat' does not exist.  Creating a new one.\n");
      // Default all scores to zero
      for (int i=0; i<LEVEL_COUNT; i++) allLevels[i]->score = 0;

      // Save new scores.dat file
      SaveScores();
   } else {
      int s;
      // Read LEVEL_COUNT integers from binary scores file
      for (int i=0; i<LEVEL_COUNT; i++) {
         fread(&s,sizeof(int),1,fd);
         allLevels[i]->score = s;
      }
      fclose(fd);
   }
}

void CLevel::Release() {
   Log("Releasing CLevel...\n");

   // Loop through allLevels and delete each level
   for (int l=0; l<LEVEL_COUNT; l++) delete allLevels[l];
   allLevels.clear();
}

void CLevel::SaveScores() {
   FILE* fd;
   Log("CLevel()  Saving scores data file.\n");
   // Attempt to open new scores.dat binary file
   if (fopen_s(&fd,"scores.dat","wb") != 0) {
      Log("CLevel()    Error creating 'scores.dat' file.\n");
   } else {
      // Loop through each level and write score to file
      for (int i=0; i<LEVEL_COUNT; i++) {
         fwrite(&allLevels[i]->score,sizeof(int),1,fd);
      }
      fclose(fd);
   }
}

CLevel* CLevel::GetLevel(unsigned int level) {
   // Return corresponding level pointer, if level is valid number
   if (level < allLevels.size()) return allLevels.at(level);
   // Otherwise, simply return first level by default
   else return allLevels.at(0);
}

// ///////////////////////////////////////////////////////////////////////////
// END OF CODE
// ///////////////////////////////////////////////////////////////////////////