// /////////////////////////////////////////////////////////////////////////////
// DR DOBB'S CHALLENGES
//
// Filename       : sound.cpp
// Date           : February 2008
//
// Description    : Refer to description in corresponding header.
//
// ///////////////////////////////////////////////////////////////////////////


// ///////////////////////////////////////////////////////////////////////////
// HEADERS (#include)
// ///////////////////////////////////////////////////////////////////////////
#include "sound.h"
#include <string>
#include <strsafe.h>

// ///////////////////////////////////////////////////////////////////////////
// STATIC INITIALIZATION
// ///////////////////////////////////////////////////////////////////////////
LPDIRECTSOUND8                            CSound::pDSound = NULL;
std::vector<LPDIRECTSOUNDBUFFER>          CSound::allBuffers;
std::map<std::string,LPDIRECTSOUNDBUFFER> CSound::mapBuffers;


// ///////////////////////////////////////////////////////////////////////////
// CONSTRUCTORS AND DESTRUCTORS
// ///////////////////////////////////////////////////////////////////////////
CSound::CSound(char* filename) {
   // Check if specified sound filename has been preloaded
   if (mapBuffers[filename] != NULL) {
      // If exists, copy reference buffer into the local secondary buffer
      pDSound->DuplicateSoundBuffer(mapBuffers[filename],&pBuffer);
   } else {
      Log("CSound()  Sound '%s' does not exist.\n", filename);
      pBuffer = NULL;
   }
}


CSound::~CSound() {
   // Release secondary buffer
   if (pBuffer != NULL) pBuffer->Release();
}

// ///////////////////////////////////////////////////////////////////////////
// PUBLIC METHODS
// ///////////////////////////////////////////////////////////////////////////
void CSound::Play() {
   // Reset position and play
   if (pBuffer != NULL) {
      pBuffer->SetCurrentPosition(0);
      pBuffer->Play(0,0,0);
   }
}

void CSound::Stop() {
   if (pBuffer != NULL) pBuffer->Stop();
}

// ///////////////////////////////////////////////////////////////////////////
// STATIC METHODS
// ///////////////////////////////////////////////////////////////////////////
void CSound::Init(HWND hWnd) {
   Log("Initializing CSound...\n");

   // Create sound device
   DirectSoundCreate8(NULL,&pDSound,NULL);
   pDSound->SetCooperativeLevel(hWnd,DSSCL_PRIORITY);

   // Preload all wav files
   preloadAllSounds();
}

void CSound::Release() {
   Log("Releasing CSound...\n");

   // Loop through all reference buffers and release
   std::vector<LPDIRECTSOUNDBUFFER>::iterator b;
   for(b = allBuffers.begin(); b != allBuffers.end(); b++) {
      (*b)->Release();
   }

   // Release sound device
   pDSound->Release();
}

void CSound::preloadSound(char* filename) {
   // Create full pathname for specified wave file
   char pathname[MAX_PATH];
   sprintf_s(pathname,MAX_PATH,"%s%s",URL_SOUNDS,filename);

   WAVEFORMATEX wfx;
   HMMIO hFile;
   UCHAR*  waveBuffer = NULL;
   LPDIRECTSOUNDBUFFER dsBuffer;
   LPVOID  pLockedBuffer;
   DWORD   dwLockedBufferSize;
   DWORD   dwBufferSize;

   // Setup media file chunks for reading
   MMCKINFO primary;
   MMCKINFO secondary;
   primary.ckid         = (FOURCC)0;
   primary.cksize       = 0;
   primary.fccType      = (FOURCC)0;
   primary.dwDataOffset = 0;
   primary.dwFlags      = 0;
   secondary = primary;

   // Attempt to open sound file
   hFile = mmioOpenA(pathname,NULL,MMIO_READ|MMIO_ALLOCBUF);
   if (hFile == NULL) {
      Log("CSound()  Error(%s): Failed to open with mmioOpenA().", filename);
      return;
   }

   // Ensure valid WAV format
   primary.fccType = mmioFOURCC('W','A','V','E');
   if (mmioDescend(hFile,&primary,NULL,MMIO_FINDRIFF)) {
      mmioClose(hFile,0);
      Log("CSound()  Error(%s): Failed to find RIFF chunk with mmioDescend().", filename);
      return;
   }

   // Locate secondary "FMT " chunk
   secondary.ckid = mmioFOURCC('f','m','t',' ');
   if (mmioDescend(hFile,&secondary,&primary,MMIO_FINDCHUNK)) {
      mmioClose(hFile,0);
      Log("CSound()  Error(%s): Failed to find format chunk with mmioDescend().", filename);
      return;
   }

   // Ensure WAVEFORMATEX is valid
   if (mmioRead(hFile,(char*)&wfx,sizeof(wfx)) != sizeof(wfx)) {
      mmioClose(hFile,0);
      Log("CSound()  Error(%s): Invalid WAVEFORMATEX extracted with mmioRead().", filename);
      return;
   }

   // Check for PCM format   
   if (wfx.wFormatTag != WAVE_FORMAT_PCM) {
      mmioClose(hFile,0);
      Log("CSound()  Error(%s): WAV not in PCM format.", filename);
      return;
   }

   // Move file pointer to secondary chunk
   if (mmioAscend(hFile,&secondary,0)) {
      mmioClose(hFile,0);
      Log("CSound()  Error(%s): Failed to access secondary chunk with mmioAscend().", filename);
      return;
   }

   // Read data chunk
   secondary.ckid = mmioFOURCC('d','a','t','a');
   if (mmioDescend(hFile,&secondary,&primary,MMIO_FINDCHUNK)) {
      mmioClose(hFile,0);
      Log("CSound()  Error(%s): Failed to read data with mmioDescend().", filename);
      return;
   }

   // Obtain secondary chunk buffer size
   dwBufferSize = secondary.cksize;

   // Create sound buffer of same chunk size
   waveBuffer = new UCHAR[dwBufferSize];

   // Copy data from file to sound buffer
   long bytesRead = mmioRead(hFile,(char*)waveBuffer,secondary.cksize);

   // Ensure sound data is not empty
   if (bytesRead < 0) {
      mmioClose(hFile,0);
      Log("CSound()  Error(%s): No data found with mmioRead().", filename);
      return;
   }

   // Close sound file
   mmioClose(hFile,0);

   // Create secondary (static) buffer (for reference)
   DSBUFFERDESC         dsbd;
   ZeroMemory(&dsbd, sizeof(DSBUFFERDESC));    // clear out the struct for use
   dsbd.dwSize = sizeof(DSBUFFERDESC);
   dsbd.dwFlags = DSBCAPS_CTRLVOLUME | DSBCAPS_STATIC;
   dsbd.dwBufferBytes = dwBufferSize;
   dsbd.guid3DAlgorithm = GUID_NULL;
   dsbd.lpwfxFormat = &wfx;
   pDSound->CreateSoundBuffer(&dsbd,&dsBuffer,NULL);
   dsBuffer->SetVolume(-3000);

   // Lock buffer
   HRESULT hr = dsBuffer->Lock(0,          // Offset at which to start lock
                               0,          // Size of lock; ignored because of flag
                               &pLockedBuffer,  // Address of first part of lock
                               &dwLockedBufferSize,  // Size of first part of lock
                               NULL,       // Address of wraparound -- not needed
                               NULL,       // Size of wraparound -- not needed
                               DSBLOCK_ENTIREBUFFER);     // Flag

   // Load sound data into secondary buffer
   memcpy(pLockedBuffer,waveBuffer,dwLockedBufferSize);
   delete[] waveBuffer;

   // Unlock buffer
   dsBuffer->Unlock(pLockedBuffer,  // Address of lock start
                    dwLockedBufferSize,  // Size of lock
                    NULL,      // No wraparound portion
                    0);        // No wraparound size


   // Append image to sprite frame vector
   allBuffers.push_back(dsBuffer);
   mapBuffers[filename] = dsBuffer;
   Log("CSound()  Loaded Sound %i:  '%s'  (%i)\n", (int)allBuffers.size()-1, filename, dwBufferSize);
}

void CSound::preloadAllSounds() {
   DWORD dwError=0;

   // Prepare string for use with FindFile functions.  First, copy the
   // string to a buffer, then append '\*.wav' to the directory name.
   size_t i;
   char filename[MAX_PATH];
   TCHAR pathname[MAX_PATH];
   StringCchCopy(pathname,MAX_PATH,TEXT(URL_SOUNDS));
   StringCchCat(pathname,MAX_PATH,L"\\*.wav");

   // Find the first file in the directory.
   WIN32_FIND_DATA ffd;
   HANDLE hFind = FindFirstFile(pathname, &ffd);

   // Check if any files exist
   if (hFind == INVALID_HANDLE_VALUE) {
      dwError = GetLastError();
      Log("CSound()  Error(%u): No files were found in the resource directory '%s'.", dwError, URL_SOUNDS);
   } else {
      // Preload first sound
      wcstombs_s(&i,filename,MAX_PATH,ffd.cFileName,MAX_PATH);
      preloadSound(filename);

      // List and preload remaining sound files in the directory.
      while (FindNextFile(hFind,&ffd) != 0) {
         wcstombs_s(&i,filename,MAX_PATH,ffd.cFileName,MAX_PATH);
         preloadSound(filename);
      }
    
      // Check for errors
      dwError = GetLastError();
      if (dwError != ERROR_NO_MORE_FILES) {
         Log("CSound()  Error(%u): Problem reading sounds from '%s'.", dwError, URL_SOUNDS);
      }

      // Close file handle
      FindClose(hFind);
   }

   return;
}

// ///////////////////////////////////////////////////////////////////////////
// END OF CODE
// ///////////////////////////////////////////////////////////////////////////