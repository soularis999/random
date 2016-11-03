// /////////////////////////////////////////////////////////////////////////////
// DR DOBB'S CHALLENGES
//
// Filename       : global.h
// Date           : February 2008
//
// Description    : This file contains the constants (as #define directives)
//                  that are globally used across the application.
//
//                  The 'log.h' header is used by all classes and therefore
//                  included in here to ensure it is always available for use.
//
// ///////////////////////////////////////////////////////////////////////////
#pragma once

// ///////////////////////////////////////////////////////////////////////////
// HEADERS (#include)
// ///////////////////////////////////////////////////////////////////////////
#include "log.h"


// ///////////////////////////////////////////////////////////////////////////
// CONSTANTS (#define)
// ///////////////////////////////////////////////////////////////////////////

// Debug Enable
#define USE_DEBUG             0

// Version ID to appear on the bottom-right corner of the Main Menu
#define VERSION_ID            "v 1.02"

// Resource locations for images and sounds
#define URL_IMAGES            "images/"
#define URL_SOUNDS            "sounds/"

// Display settings
#define SCREEN_WIDTH          800
#define SCREEN_HEIGHT         600
#define MS_PER_FRAME          30

// Game tile layout
#define TILE_WIDTH            32
#define TILE_HEIGHT           32
#define TILE_XCOUNT           25
#define TILE_YCOUNT           18

#define TILE_CENTER           0
#define TILE_LOW              1
#define TILE_HIGH             2

#define DIR_LEFT              0
#define DIR_RIGHT             1
#define DIR_UP                2
#define DIR_DOWN              3

#define PI                    3.14159265f