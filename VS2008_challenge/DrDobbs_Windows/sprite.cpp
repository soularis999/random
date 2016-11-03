// /////////////////////////////////////////////////////////////////////////////
// DR DOBB'S CHALLENGES
//
// Filename       : sprite.cpp
// Date           : February 2008
//
// Description    : Refer to description in corresponding header.
//
// ///////////////////////////////////////////////////////////////////////////


// ///////////////////////////////////////////////////////////////////////////
// HEADERS (#include)
// ///////////////////////////////////////////////////////////////////////////
#include "sprite.h"
#include <string>
#include <strsafe.h>

#include "entity.h"
#include "input.h"


// ///////////////////////////////////////////////////////////////////////////
// CONSTANTS (#define)
// ///////////////////////////////////////////////////////////////////////////


// ///////////////////////////////////////////////////////////////////////////
// STATIC INITIALIZATION
// ///////////////////////////////////////////////////////////////////////////
LPDIRECT3D9       CSprite::pD3D = NULL;
LPDIRECT3DDEVICE9 CSprite::pD3DDevice = NULL;
LPD3DXSPRITE      CSprite::pD3DSprite = NULL;

std::vector<LPDIRECT3DTEXTURE9>           CSprite::allTextures;
std::map<std::string,LPDIRECT3DTEXTURE9>  CSprite::mapTextures;
std::vector<CSprite*>                     CSprite::allSprites;

bool     CSprite::pauseAll = false;
CSprite* CSprite::pMouse = NULL;

// ///////////////////////////////////////////////////////////////////////////
// CONSTRUCTORS AND DESTRUCTORS
// ///////////////////////////////////////////////////////////////////////////
CSprite::CSprite(int xCenterOff, int yCenterOff, int zType, int fd) {
   // Copy parameters into local members
   xCenter     = xCenterOff;
   yCenter     = yCenterOff;
   z           = zType;
   frameDelay  = fd;

   // Initialize remaining members
   x           = 0;
   y           = 0;
   frame       = 0;
   delay       = 0;
   isHidden    = true;
   isPlaying   = true;

   // Add sprite to *ordered* sprite list
   addSprite();

   // Set pointer to mouse sprite, if specified
   // NOTE: This is used to easily re-render the mouse over-top
   //       of all rendered text.
   if (z == SPRITE_TYPE_MOUSE) pMouse = this;
}

CSprite::~CSprite() {
   // Remove sprite from static vector
   std::vector<CSprite*>::iterator s;
   for (s = allSprites.begin(); s != allSprites.end(); s++) {
      if ((*s) == this) {
         allSprites.erase(s);
         break;
      }
   }
}


// ///////////////////////////////////////////////////////////////////////////
// PROTECTED/PRIVATE METHODS
// ///////////////////////////////////////////////////////////////////////////
void CSprite::addSprite() {
   // Loop through static vector of existing sprites and insert the new sprite
   // into the correct location, based on the 'z' value.  This vector should
   // be ordered in ascending order so that the front-most sprites are drawn
   // last by the renderer.
   std::vector<CSprite*>::iterator s;
   for (s = allSprites.begin(); s != allSprites.end(); s++) {
      if (z < (*s)->z) {
         allSprites.insert(s,this);
         return;
      }
   }

   // If 'z' is not less than anything in allSprites, then it must be in front
   // of everything so should be added to end of the vector.
   allSprites.push_back(this);
}


void CSprite::update() {
   // Check if sprites are globally paused
   // NOTE:  This is handy at the end of a level when the game is paused
   //        and no sprites should be animating.
   if (pauseAll) return;

   // Ignore pump if sprite is currently hidden
   if (isHidden) return;

   // Ignore pump if not playing
   if (!isPlaying) return;

   // Only animate if there's more than 1 frame and frameDelay > 0
   if ((frameDelay > 0) && ((int)allFrames.size() > 1)) {
      // Increment frame if current delay is zeroed
      if (delay == 0) {
          frame = (frame + 1) % allFrames.size();
      }

      // Increment current delay (within [0,frameDelay-1])
      delay = (delay + 1) % frameDelay;
   }
}

void CSprite::render() {
   // Ignore render() call if hidden 
   if (!isHidden) {
      // Define center offsets/position and draw current frame to
      // screen using LPD3DXSPRITE device.
      D3DXVECTOR3 center(float(xCenter),float(yCenter),0.0f);
      D3DXVECTOR3 position(float(x),float(y),0.0f);
      pD3DSprite->Draw(allFrames.at(frame),
                       NULL,
                       &center,
                       &position,
                       D3DCOLOR_XRGB(255,255,255));
   }
}


// ///////////////////////////////////////////////////////////////////////////
// PUBLIC METHODS
// ///////////////////////////////////////////////////////////////////////////
void CSprite::AddImage(char* filename) {
   // Find texture
   std::map<std::string,LPDIRECT3DTEXTURE9>::iterator i = mapTextures.find(filename);

   // If texture found, append to sprite's frame vector 
   if (i != mapTextures.end()) allFrames.push_back(i->second);
}

void CSprite::AddImage(char* prefix, int start, int end, char* suffix) {
   char filename[100];

   // Loop through [start,end] file iteration and add each image individually
   for (int i=start; i<=end; i++) {
      sprintf_s(filename, sizeof(filename), "%s%i%s", prefix, i, suffix);
      AddImage(filename);
   }
}

// Position control
void CSprite::Move(int xVal, int yVal) {
   x = xVal;
   y = yVal;
}

// Visibility control
void CSprite::Hide() { isHidden = true; }
void CSprite::Unhide() { isHidden = false; }
bool CSprite::IsHidden() { return isHidden; }

// Frame control
int  CSprite::GetFrame() { return frame; }
void CSprite::SetFrame(int f) { frame = f; }
void CSprite::SetFrameDelay(int fd) { frameDelay = fd; }
bool CSprite::LastFrame() { return (frame == (allFrames.size() - 1)); }

// Play control
void CSprite::Pause() { isPlaying = false; }
void CSprite::Play()  { isPlaying = true; }
void CSprite::Reset() { frame = 0; }

bool CSprite::IsMouseOver() {
   // Check if mouse distance from center is within center offset values
   int dx = abs(CInput::MouseX() - x);
   int dy = abs(CInput::MouseY() - y);
   return ((dx <= abs(xCenter)) && (dy <= abs(yCenter)));
}

// ///////////////////////////////////////////////////////////////////////////
// STATIC METHODS
// ///////////////////////////////////////////////////////////////////////////
void CSprite::Init(LPDIRECT3D9 d3d, LPDIRECT3DDEVICE9 d3ddev) {
   Log("Initializing CSprite...\n");
   pD3D       = d3d;
   pD3DDevice = d3ddev;

   // Create sprite device
   D3DXCreateSprite(d3ddev,&pD3DSprite);

   // Load all images in resource directory
   preloadAllTextures();
}

void CSprite::Release() {
   Log("Releasing CSprite...\n");

   // Loop through each preloaded texture and release
   std::vector<LPDIRECT3DTEXTURE9>::iterator t;
   for(t = allTextures.begin(); t != allTextures.end(); t++) {
      (*t)->Release();
   }

   // Clear vectors
   allTextures.clear();
   mapTextures.clear();

   // Release sprite device
   pD3DSprite->Release();
}

void CSprite::RenderAll() {
   // Begin sprite rendering
   pD3DSprite->Begin(D3DXSPRITE_ALPHABLEND);

   // Loop through each sprite in allSprites
   std::vector<CSprite*>::iterator s;
   for (s = allSprites.begin(); s != allSprites.end(); s++) {
      // Update frame animation, if necessary
      (*s)->update();

      // Render current frame
      (*s)->render();
   }

   // End sprite rendering
   pD3DSprite->End();
}

void CSprite::RenderMouse() {
   // Easy way to force drawing of mouse atop of all other sprites and text.
   // The alternative would be to universally define a z-value for each
   // CSprite and CText, then render each sprite with an individual Begin()
   // and End().  This is necessary because text doesn't seem to get rendered
   // if DrawText() is called between the D3DXSPRITE Begin() and End().
   if (pMouse != NULL) {
      pD3DSprite->Begin(D3DXSPRITE_ALPHABLEND);
      pMouse->render();
      pD3DSprite->End();
   }
}

void CSprite::PauseAll() { pauseAll = true; }
void CSprite::UnpauseAll() { pauseAll = false; }

void CSprite::ReacquireDevice() {
   // When application loses focus and main DX device is lost, sub-devices
   // must be reacquired before the main device can be reset.
   Log("CSprite()  Lost D3DXSPRITE device.  Reacquiring...\n");
   pD3DSprite->OnLostDevice();
}
void CSprite::ResetDevice() {
   // When application loses focus and main DX device is lost, sub-devices
   // must be reset after the main device is reset.
   Log("CSprite()  Lost D3DXSPRITE device.  Reseting...\n");
   pD3DSprite->OnResetDevice();
}

void CSprite::preloadTexture(char* filename) {
   // Create full pathname for specified image file
   char pathname[MAX_PATH];
   sprintf_s(pathname,MAX_PATH,"%s%s",URL_IMAGES,filename);

   // Load texture
   LPDIRECT3DTEXTURE9 pTexture;
   D3DXCreateTextureFromFileExA(pD3DDevice,    // the device pointer
                               pathname,      // the file name
                               D3DX_DEFAULT,    // default width
                               D3DX_DEFAULT,    // default height
                               D3DX_DEFAULT,    // no mip mapping
                               NULL,    // regular usage
                               D3DFMT_A8R8G8B8,    // 32-bit pixels with alpha
                               D3DPOOL_MANAGED,    // typical memory handling
                               D3DX_DEFAULT,    // no filtering
                               D3DX_DEFAULT,    // no mip filtering
                               D3DCOLOR_XRGB(255, 0, 255),    // the hot-pink color key
                               NULL,    // no image info struct
                               NULL,    // not using 256 colors
                               &pTexture);    // load to sprite

   // Append image to sprite frame vector
   allTextures.push_back(pTexture);
   mapTextures[filename] = pTexture;
   Log("CSprite()  Loaded Texture %i:  '%s'\n", (int)allTextures.size()-1, filename);
}


void CSprite::preloadAllTextures() {
   DWORD dwError=0;

   // Prepare string for use with FindFile functions.  First, copy the
   // string to a buffer, then append '\*.png' to the directory name.
   size_t i;
   char filename[MAX_PATH];
   TCHAR pathname[MAX_PATH];
   StringCchCopy(pathname,MAX_PATH,TEXT(URL_IMAGES));
   StringCchCat(pathname,MAX_PATH,L"\\*.png");

   // Find the first file in the directory.
   WIN32_FIND_DATA ffd;
   HANDLE hFind = FindFirstFile(pathname, &ffd);
   // Check if any files exist
   if (hFind == INVALID_HANDLE_VALUE) {
      dwError = GetLastError();
      Log("CSprite()  Error(%u): No files were found in the resource directory '%s'.", dwError, URL_IMAGES);
   } else {
      // Preload first image
      wcstombs_s(&i,filename,MAX_PATH,ffd.cFileName,MAX_PATH);
//Log("Filename 0:  '%s'\n", filename);
      preloadTexture(filename);

      // List and preload remaining image files in the directory.
      while (FindNextFile(hFind,&ffd) != 0) {
         wcstombs_s(&i,filename,MAX_PATH,ffd.cFileName,MAX_PATH);
//Log("Filename Next:  '%s'\n", filename);
         preloadTexture(filename);
      }
    
      // Check for errors
      dwError = GetLastError();
      if (dwError != ERROR_NO_MORE_FILES) {
         Log("CSound()  Error(%u): Problem reading images from '%s'.", dwError, URL_SOUNDS);
      }

      // Close file handle
      FindClose(hFind);
   }

   return;
}

// ///////////////////////////////////////////////////////////////////////////
// END OF CODE
// ///////////////////////////////////////////////////////////////////////////
