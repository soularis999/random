using System;
using System.Security.Cryptography;
using System.Collections;
using System.IO;
using Microsoft.Win32;
using System.Text;
	
namespace OpenHack {
	/// <summary>
	/// Summary description for CryptUtil.
	/// </summary>
	internal sealed class CryptUtil {
		// creating crypto objects is quite expensive so 
		// we want to amortize the cost by keeping them around
		// we want to use them in a thread safe way, as well
		// we'll keep up to _maxStackSize of them around, 
		// although we shouldn't ever create more than 100, given
		// ASP.NET application pool sizes
		private static Stack _encryptStack;
		private static Stack _decryptStack;
		private static RNGCryptoServiceProvider _rng;
		private static SymmetricAlgorithm _alg;
		private static bool _inited = false;
		private static object _lockMe = new Object();
		private const int _maxStackSize = 100;
		private const string _regKeyPath = @"Software\Microsoft\OpenHack";
		private const string _regKeyValue = "SessKey";
		private const string _regIvValue = "SessIV";

		internal static byte[] GetRegSecret(string regPath, string regValue, int secretSize) {
			RegistryKey regKey = null;
			byte[] secret = null;

			// this has an extra copy but we'll do it to validate data size and since
			// it's not perf critical
			using(regKey = Registry.LocalMachine.OpenSubKey(regPath)) {
				byte[] rawKey = regKey.GetValue(regValue) as byte[];
					byte[] clearKey = DataProtection.UnprotectData(rawKey);
				secret = new byte[secretSize];
				Array.Copy(clearKey,  0, secret, 0, secretSize);							
				ZeroByteArray(clearKey);
			}

			return secret;
		}

		internal static string EncryptString(string clearString, bool fRandBlock) {
			byte[] clearData = Encoding.Unicode.GetBytes(clearString);
			byte[] cipherText = CryptUtil.EncryptOrDecryptData(true, fRandBlock, clearData, 0, clearData.Length);
			return Convert.ToBase64String(cipherText);
		}

		internal static string DecryptString(string cipherString, bool fRandBlock) {
			byte[] cipherData = Convert.FromBase64String(cipherString);
			byte[] clearData = EncryptOrDecryptData(false, fRandBlock, cipherData, 0, cipherData.Length);
			return Encoding.Unicode.GetString(clearData);
		}


		private static void EnsureInited() {
			if( false == _inited ) {
				lock(_lockMe) {
					if(false == _inited) {
						_encryptStack = new Stack();
						_decryptStack = new Stack();
						try {
							_rng = new RNGCryptoServiceProvider();

							// pick whichever alg we want here
							_alg = TripleDES.Create();

							// set key and then zero
							byte[] ourKey = GetRegSecret(_regKeyPath, _regKeyValue,  _alg.KeySize / 8);
							if( null != ourKey ) {
								// we could fall back to zeros if it doesn't exist
								// since we're using a random first block already
								// but let's be paranoid and not
								byte[] ourIV = GetRegSecret(_regKeyPath, _regIvValue, _alg.BlockSize /8);
								if( null == ourIV )
									throw new ApplicationException("Can't acquire symmetric IV: please configure one");

								_alg.IV = (byte[])ourIV.Clone();
								_alg.Key = (byte[])ourKey.Clone();

								// cleanup
								ZeroByteArray(ourKey);
								ZeroByteArray(ourIV);
							}
						}
						catch(Exception ex) {
							throw new ApplicationException("Can't create TripleDES object or acquire key", ex);
						}
						_inited = true;
					}
				}
			}
		}

		private static void ZeroByteArray(byte [] buf) {
			if (buf == null || buf.Length < 1)
				return;
			for(int iter=0; iter<buf.Length; iter++)
				buf[iter] = (byte)0;
		}

		private static ICryptoTransform GetTransform(bool fEncrypt) {	
			// if the stack has available [en|de]cryptors, return them
			if( fEncrypt ) {
				lock(_encryptStack) {
					if( _encryptStack.Count > 0 )
						return (ICryptoTransform) _encryptStack.Pop();
				}
			}
			else {
				lock(_decryptStack) {
					if( _decryptStack.Count > 0 )
						return (ICryptoTransform) _decryptStack.Pop();
				}
			}

			// else createa a new one of the type we need
			lock(_alg) {
				return (fEncrypt) ? _alg.CreateEncryptor() : _alg.CreateDecryptor();
			}
		}

		private static void CacheTransform(bool fEncrypt, ICryptoTransform trans) {
			if( fEncrypt ) {
				lock(_encryptStack) {
					if(_encryptStack.Count < _maxStackSize ) {
						_encryptStack.Push(trans);
					}
				}
			}
			else {
				lock(_decryptStack) {
					if(_decryptStack.Count < _maxStackSize ) {
						_decryptStack.Push(trans);
					}
				}
			}
		}

		

		internal static byte [] EncryptOrDecryptData(bool fEncrypt, bool fRandBlock, byte [] buf, int start, int length) {
			EnsureInited();
			byte[] data = null;
			byte[] inputData = buf;


			// use a random first block to make data less predictable in the event
			// of a DB compromise.  We'll do this in addition to the IV
			int bsize = _alg.BlockSize / 8;
			
			if( start < 0 )
				throw new ArgumentException("Start index must be >= 0", "start");

			if( !fEncrypt && (length < bsize))
				throw new ArgumentException("Length must be greater than blocksize", "length");

			if( fEncrypt && fRandBlock ) {
				byte[] randStuff = new byte[ bsize ];
				// get entropy				
				lock(_rng) {
					_rng.GetBytes(randStuff);
				}

				// copy data in
				inputData = new byte[ bsize + length ];
				Buffer.BlockCopy(randStuff, 0, inputData, 0, randStuff.Length);
				Buffer.BlockCopy(buf, 0, inputData, bsize-1, length);
				ZeroByteArray(randStuff);
			}

			using(MemoryStream ms = new MemoryStream()) {
				ICryptoTransform trans = GetTransform(fEncrypt);
				using(CryptoStream cs = new CryptoStream(ms, trans, CryptoStreamMode.Write)) {
					cs.Write(inputData, start, inputData.Length);                
					cs.FlushFinalBlock();            
					data = ms.ToArray();
					CacheTransform(fEncrypt, trans);
				}
			}

			// if decrypting, discard first block
			if( !fEncrypt && fRandBlock && data.Length > bsize ) {
				int len = data.Length-bsize;
				byte[] cleartext = new byte[len];
				Buffer.BlockCopy(data, bsize-1, cleartext, 0, len);
				// zero our old copy of the cleartest
				ZeroByteArray(data);
				data = cleartext;
			}

			return data;
		}
	}
}
