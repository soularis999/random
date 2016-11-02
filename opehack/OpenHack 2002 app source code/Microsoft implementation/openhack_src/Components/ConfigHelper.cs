using System;
using System.Configuration;


namespace OpenHack
{
	/// <summary>
	/// Summary description for CreditCardInfo.
	/// </summary>
	public sealed class ConfigHelper
	{
		public static string GetConfig(string key) {
			return ConfigurationSettings.AppSettings[key];
		}

		internal static bool GetConfigBoolWithDefault(string key, bool defaultVal) {
			bool result = defaultVal;
			string cfgVal = GetConfig(key);
			if(null != cfgVal && String.Empty != cfgVal ) {
				try {
					result = Boolean.Parse(cfgVal);
				}
				catch(FormatException) {
					result = defaultVal;
				}
			}

			return result;
		}

		public static bool GetConfigBool(string key) {
			return GetConfigBoolWithDefault(key, false);
		}
	}
}
