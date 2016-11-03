// /////////////////////////////////////////////////////////////////////////////
// DR DOBB'S CHALLENGES
//
// Filename       : log.cpp
// Date           : February 2008
//
// Description    : Refer to description in corresponding header.
//
// ///////////////////////////////////////////////////////////////////////////


// ///////////////////////////////////////////////////////////////////////////
// HEADERS (#include)
// ///////////////////////////////////////////////////////////////////////////
#include <string>
#include <stdio.h>
#include <stdarg.h>
#include <time.h>
#include "log.h"


// ///////////////////////////////////////////////////////////////////////////
// CONSTANTS (#define)
// ///////////////////////////////////////////////////////////////////////////
#define LOG_FILE  "LOG.TXT"


// ///////////////////////////////////////////////////////////////////////////
// METHODS
// ///////////////////////////////////////////////////////////////////////////
void InitLog() {
   // Remove LOG.TXT if already exists
   remove(LOG_FILE);
   Log("Log Initialized.\n");
}

void Log(char *fmt, ...) {
   // Try to open log file
   FILE* fd;
   if (fopen_s(&fd,LOG_FILE,"a") != 0) return;
   
   // Write current timestamp to log
   char prefix[64];
   time_t currentTime;
   struct tm today;
   time(&currentTime);
   localtime_s(&today,&currentTime);
   strftime(prefix, sizeof(prefix)-1, "%d/%m/%y %H:%M:%S - ", &today);
   fwrite(prefix, 1, strlen(prefix), fd);
 
   // Write string (with variable arguments) to log
   va_list argp;
   va_start(argp, fmt);
   vfprintf(fd,fmt,argp);
   va_end(argp);

   // Close file
   fclose(fd);
}

// ///////////////////////////////////////////////////////////////////////////
// END OF CODE
// ///////////////////////////////////////////////////////////////////////////