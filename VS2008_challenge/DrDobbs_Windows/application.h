// /////////////////////////////////////////////////////////////////////////////
// DR DOBB'S CHALLENGES
//
// Filename       : application.cpp
// Date           : February 2008
//
// Description    : This file defines the CApplication class creates the main
//                  application.  It is responsible for creating the window,
//                  initializing the core (input, sound, textures, etc),
//                  and releasing the core at the end.  During the main game
//                  loop, it is responsible for updating and rendering the
//                  active GUI.
//
//                  Init() must be called at the beginning of the main program
//                  to all static members from the application core are
//                  initialized.  Release() must also be called at the end of
//                  the main program to release the same static members.
//
// ///////////////////////////////////////////////////////////////////////////
#pragma once

// ///////////////////////////////////////////////////////////////////////////
// HEADERS (#include)
// ///////////////////////////////////////////////////////////////////////////
#include <windows.h>
#include <windowsx.h>
#include <d3d9.h>
#include <d3dx9.h>
#include <time.h>

#include "sprite.h"
#include "input.h"
#include "sound.h"

#include "game.h"
#include "mainmenu.h"
#include "intro.h"

#pragma comment(lib,"d3d9.lib")
//#pragma comment(lib,"d3dx9d.lib")   // Debug build
#pragma comment(lib,"d3dx9.lib")    // Release build
#pragma comment(lib,"dsound.lib")

#pragma comment(lib,"winmm.lib")


// ///////////////////////////////////////////////////////////////////////////
// CLASS DEFINITION
// ///////////////////////////////////////////////////////////////////////////
class CApplication {

   // ////////////////////////////////////////////////////////////////////////
   // PROTECTED/PRIVATE METHODS
   // ////////////////////////////////////////////////////////////////////////
   protected:
      // /////////////////////////////////////////////////////////////////////
      // VARIABLES
      HWND hWnd;  // Window handle

      D3DPRESENT_PARAMETERS   d3dParam;   // Direct3D parameters
      LPDIRECT3D9             pD3D;       // Direct3D interface
      LPDIRECT3DDEVICE9       pD3DDevice; // Direct3D device

      bool  isRunning;        // Running flag
      int   gui;              // GUI state

      CIntro*     pGuiIntro;  // Pointer to Introduction GUI
      CMainMenu*  pGuiMenu;   // Pointer to Main Menu GUI
      CGame*      pGuiGame;   // Pointer to Game GUI

   // ////////////////////////////////////////////////////////////////////////
   // PUBLIC METHODS
   // ////////////////////////////////////////////////////////////////////////
   public:
      // /////////////////////////////////////////////////////////////////////
      // CONSTRUCTORS/DESTRUCTORS
      CApplication();
      ~CApplication();

      // /////////////////////////////////////////////////////////////////////
      // METHODS
      void Init();      // Initialize static members
      void Release();   // Release static members

      void Update();    // Update active GUI
      void Render();    // Render active GUI

      void Destroy();   // Destroy window (callback for WindowProc)
      void Activate();  // Activate window (callback for WindowProc)

      bool IsRunning(); // Check if application is still running
};

LRESULT CALLBACK WindowProc(HWND hWnd,UINT msg,WPARAM wParam,LPARAM lParam);

// ///////////////////////////////////////////////////////////////////////////
// END OF CODE
// ///////////////////////////////////////////////////////////////////////////
