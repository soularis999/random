// /////////////////////////////////////////////////////////////////////////////
// DR DOBB'S CHALLENGES
//
// Filename       : sprite.h
// Date           : February 2008
//
// Description    : This file defines the CSprite class used for manipulating
//                  and rendering 2D images.
//
//                  Init() must be called at the beginning of the main program
//                  to ensure all texture data is preloaded before any images
//                  are used for sprites.
//
// ///////////////////////////////////////////////////////////////////////////
#pragma once


// ///////////////////////////////////////////////////////////////////////////
// HEADERS (#include)
// ///////////////////////////////////////////////////////////////////////////
#include <map>
#include <vector>
#include <d3d9.h>
#include <d3dx9.h>
#include "global.h"


// ///////////////////////////////////////////////////////////////////////////
// CONSTANTS (#define)
// ///////////////////////////////////////////////////////////////////////////
#define SPRITE_TYPE_BACKGROUND   100
#define SPRITE_TYPE_TERRAIN      200
#define SPRITE_TYPE_TOKEN        300
#define SPRITE_TYPE_DOBB         400
#define SPRITE_TYPE_AI           500
#define SPRITE_TYPE_BUTTON       600
#define SPRITE_TYPE_DIMMER       700
#define SPRITE_TYPE_MOUSE        800

// ///////////////////////////////////////////////////////////////////////////
// CLASS DEFINITION
// ///////////////////////////////////////////////////////////////////////////
class CSprite {

   // ////////////////////////////////////////////////////////////////////////
   // PROTECTED/PRIVATE METHODS
   // ////////////////////////////////////////////////////////////////////////
   protected:
      // /////////////////////////////////////////////////////////////////////
      // STATIC VARIABLES
      static LPDIRECT3D9         pD3D;
      static LPDIRECT3DDEVICE9   pD3DDevice;
      static LPD3DXSPRITE        pD3DSprite;

      static std::vector<LPDIRECT3DTEXTURE9>          allTextures;
      static std::map<std::string,LPDIRECT3DTEXTURE9> mapTextures;
      static std::vector<CSprite*>                    allSprites;

      static CSprite*   pMouse;
      static bool       pauseAll;

      // /////////////////////////////////////////////////////////////////////
      // VARIABLES
      int x;
      int y;
      int z;

      int xCenter;
      int yCenter;
      int frameDelay;
      int frame;
      int delay;

      bool isHidden;
      bool isPlaying;

      std::vector<LPDIRECT3DTEXTURE9> allFrames;

      // /////////////////////////////////////////////////////////////////////
      // METHODS
      static void preloadTexture(char* filename);
      static void preloadAllTextures();

      void addSprite();
      void update();
      void render();



   // ////////////////////////////////////////////////////////////////////////
   // PUBLIC METHODS
   // ////////////////////////////////////////////////////////////////////////
   public:
      // /////////////////////////////////////////////////////////////////////
      // CONSTRUCTORS/DESTRUCTORS
      CSprite(int xCenterOff=0, int yCenterOff=0, int zType=0, int fd=0);
      ~CSprite();

      // /////////////////////////////////////////////////////////////////////
      // METHODS
      void AddImage(char* filename);
      void AddImage(char* prefix, int start, int end, char* suffix);

      void Move(int x, int y);
      int  GetFrame();
      void SetFrame(int f);
      void SetFrameDelay(int fd);
      bool LastFrame();

      void Hide();
      void Unhide();
      bool IsHidden();

      void Pause();
      void Play();
      void Reset();

      bool IsMouseOver();

      // /////////////////////////////////////////////////////////////////////
      // STATIC METHODS
      static void Init(LPDIRECT3D9 d3d, LPDIRECT3DDEVICE9 d3ddev);
      static void Release();
      static void RenderAll();
      static void RenderMouse();
      static void PauseAll();
      static void UnpauseAll();

      static void ReacquireDevice();
      static void ResetDevice();

};


// ///////////////////////////////////////////////////////////////////////////
// END OF CODE
// ///////////////////////////////////////////////////////////////////////////
