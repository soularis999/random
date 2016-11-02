using System;
using System.Text;
using System.Runtime.InteropServices;

namespace OpenHack {
	/// <summary>
	/// Platform invoke declarations and associated constants
	/// </summary>
	internal sealed class NativeMethods {
		private const string crypt32 = "crypt32";
		private const string kernel32 = "kernel32";

		// p/invoke decls for DPAPI functionality
		[DllImport(crypt32, CharSet=System.Runtime.InteropServices.CharSet.Auto, SetLastError=true)]
		public static extern bool CryptProtectData(ref DATA_BLOB dataIn, string szDataDescr, ref DATA_BLOB optionalEntropy, 
			IntPtr pvReserved, IntPtr pPromptStruct,
			int dwFlags, ref DATA_BLOB pDataOut);

		[DllImport(crypt32, CharSet=System.Runtime.InteropServices.CharSet.Auto, SetLastError=true)]
		public static extern bool CryptUnprotectData(ref DATA_BLOB dataIn, StringBuilder ppszDataDescr,
			ref DATA_BLOB optionalEntropy, IntPtr pvReserved,
			IntPtr pPromptStruct, int dwFlags,
			ref DATA_BLOB pDataOut);

		// used to free native buffer returned from DPAPI calls
		[DllImport(kernel32)]
		public static extern IntPtr LocalFree(IntPtr hMem);
        
		// input/output to DPAPI calls
		[StructLayout(LayoutKind.Sequential, CharSet=CharSet.Unicode)]
			public struct DATA_BLOB {
			public int cbData;
			public IntPtr pbData;
		}

		// various DPAPI flags
		// we'll use LocalMachine and UIForbidden
		public const int PromptOnProtect = 0x2;
		public const int PromptOnUnprotect = 0x1;
		public const int UIForbidden = 0x1;
		public const int PromptStrong = 0x08;
		public const int LocalMachine = 0x4;
		public const int CredSync = 0x8;
		public const int Audit = 0x10;
		public const int NoRecovery = 0x20;
		public const int VerifyProtection = 0x40;

		// Unused currently but in case we want it later
		[StructLayout(LayoutKind.Sequential, CharSet=CharSet.Unicode)]
			public class CRYPTPROTECT_PROMPTSTRUCT {
			public int cbSize = Marshal.SizeOf(typeof(CRYPTPROTECT_PROMPTSTRUCT));
			public int dwPromptFlags = 0;
			public IntPtr hwndApp = IntPtr.Zero;
			public string szPrompt = null;
		}
	}
}
