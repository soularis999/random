using System;
using System.Text;
using System.ComponentModel;
using System.Runtime.InteropServices;
using Microsoft.Win32;

namespace OpenHack {
	/// <summary>
	/// This class wraps functionality provided by the Windows
	/// Data Protection APIs (DPAPI) (native decls in NativeMethods.cs)
	/// For information on this facility, please see MSDN docs for
	/// CryptProtectData and CryptUnprotectData
	/// White Paper on DPAPI:
	/// http://msdn.microsoft.com/library/default.asp?url=/library/en-us/dnsecure/html/windataprotection-dpapi.asp?frame=true
	/// 
	/// Note that this is not exceptionally performant so the decrypted secret will
	/// generally be cached for the lifetime of the AppDomain
	/// </summary>
	internal sealed class DataProtection {
		// default for a server/service application:
		// no ui and use machine specific encryption, rather than
		// per account
		private const int _defaultFlags =
			NativeMethods.UIForbidden|NativeMethods.LocalMachine;

		private const string _regKeyPath = @"Software\Microsoft\OpenHack";
		private const string _regKeyValue = "Entropy";
		private static byte[] _optionalEntropy = null;
		private const int _maxBytesEntropy = 32;

		private static byte[] GetOptionalEntropy() {
			RegistryKey regKey = null;

			if( null == _optionalEntropy ) {
				lock(_regKeyPath) {
					if( null == _optionalEntropy ) {
						using(regKey = Registry.LocalMachine.OpenSubKey(_regKeyPath)) {
							byte[] rawKey = regKey.GetValue(_regKeyValue) as byte[];	
								if( null == rawKey ) {
									throw new ApplicationException("GetValue return NULL for entropy");
								}
								if( rawKey.Length > _maxBytesEntropy ) {
									byte[] secret = new byte[ _maxBytesEntropy ];
									Buffer.BlockCopy(rawKey, 0, secret, 0, _maxBytesEntropy);
									_optionalEntropy = secret;
								}
								else {
									_optionalEntropy = rawKey;
								}
						}
					}
				}
			}

			if(null == _optionalEntropy ) {
				throw new Exception("Can't acquire optional entropy: please re-run SetPassword utility");
			}

			return _optionalEntropy;			
		}

		// takes a string and returns a base64 encoded string containing
		// the protected data using the default flags
		internal static string ProtectData(string data, string secretName) {
			return ProtectData(data, secretName, _defaultFlags);
		}

		internal static string ProtectData(string data, string secretName, int flags) {
			byte[] dataIn = Encoding.Unicode.GetBytes(data);
			byte[] dataOut = ProtectData(dataIn, secretName, flags);
			string strOut = null;
			if ( null != dataOut )
				strOut = Convert.ToBase64String(dataOut);
			return strOut;
		}

		// takes a base64 encoded containing protected data and
		// returns the data as a string
		internal static string UnprotectData(string data) {
			byte[] dataIn = Convert.FromBase64String(data);
			byte[] dataOut = UnprotectData(dataIn);
			string strOut = null;

			if ( null != dataOut )
				strOut = Encoding.Unicode.GetString(dataOut);
			return strOut;
		}

		internal static byte[] ProtectData(byte[] data, string name) {
			return ProtectData(data, name, _defaultFlags);
		}

		internal static byte[] UnprotectData(byte[] data) {
			return UnprotectData(data, _defaultFlags);
		}

		internal static byte[] UnprotectData(byte[] data, int dwFlags) {
			byte[] clearText = null;

			// copy data into unmanaged memory
			NativeMethods.DATA_BLOB din = new NativeMethods.DATA_BLOB();
			din.cbData = data.Length;
			din.pbData = Marshal.AllocHGlobal(din.cbData);
			Marshal.Copy(data, 0, din.pbData, din.cbData);

			// set up optional entropy
			byte[] optEnt = GetOptionalEntropy();
			NativeMethods.DATA_BLOB entropy = new NativeMethods.DATA_BLOB();
			entropy.cbData = optEnt.Length;
			entropy.pbData = Marshal.AllocHGlobal(entropy.cbData);
			Marshal.Copy(optEnt, 0, entropy.pbData, entropy.cbData);

			NativeMethods.DATA_BLOB dout = new NativeMethods.DATA_BLOB();
			try {
				bool ret = NativeMethods.CryptUnprotectData(ref din, null, ref entropy, 
					IntPtr.Zero, IntPtr.Zero, dwFlags, ref dout);

				if ( ret ) {
					clearText = new byte[ dout.cbData ];
					Marshal.Copy(dout.pbData, clearText, 0, dout.cbData);
					NativeMethods.LocalFree(dout.pbData);
				}
				else {
					throw new Win32Exception(Marshal.GetLastWin32Error(), "CryptUnprotectData failed");
				}
			}

			finally {
				if ( din.pbData != IntPtr.Zero )
					Marshal.FreeHGlobal(din.pbData);
				if( entropy.pbData != IntPtr.Zero )
					Marshal.FreeHGlobal(entropy.pbData);
			}

			return clearText;
		}

		internal static byte[] ProtectData(byte[] data, string name, int dwFlags) {
			byte[] cipherText = null;

			// copy data into unmanaged memory
			NativeMethods.DATA_BLOB din = new NativeMethods.DATA_BLOB();
			din.cbData = data.Length;
			din.pbData = Marshal.AllocHGlobal(din.cbData);
			Marshal.Copy(data, 0, din.pbData, din.cbData);

			// set up optional entropy
			byte[] optEnt = GetOptionalEntropy();
			NativeMethods.DATA_BLOB entropy = new NativeMethods.DATA_BLOB();
			entropy.cbData = optEnt.Length;
			entropy.pbData = Marshal.AllocHGlobal(entropy.cbData);
			Marshal.Copy(optEnt, 0, entropy.pbData, entropy.cbData);

			NativeMethods.DATA_BLOB dout = new NativeMethods.DATA_BLOB();
			try {
				bool ret = NativeMethods.CryptProtectData(ref din, name, ref entropy, 
					IntPtr.Zero, IntPtr.Zero, dwFlags, ref dout);
				if ( ret ) {
					cipherText = new byte[dout.cbData];
					Marshal.Copy(dout.pbData, cipherText, 0, dout.cbData);
					NativeMethods.LocalFree(dout.pbData);
				}
				else {
					throw new Win32Exception(Marshal.GetLastWin32Error(), "CryptProtectData failed");
				}

			}
			finally {
				if ( din.pbData != IntPtr.Zero )
					Marshal.FreeHGlobal(din.pbData);

				if ( entropy.pbData != IntPtr.Zero )
					Marshal.FreeHGlobal(entropy.pbData);
			}

			return cipherText;
		}
	}
}
