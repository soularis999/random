using System;
using System.Web;
using System.Web.Security;
using System.Diagnostics;
using System.Configuration;
using System.Text;
using System.Security.Principal;
using Microsoft.Win32;

namespace OpenHack {
	/// <summary>
	/// Summary description for Global.
	/// </summary>
	public class Global : System.Web.HttpApplication {
		public const string Session_PageMessage = "PageMessage";
		public const string ConnectionString = "connString";
		public const string OracleConnString = "OracleConnString";
		public const string SqlConnString = "SqlConnString";
		public const string DbType = "DbType";
		public const string ContestEndDate = "ContestEndDate";
		public const string EmailFrom = "EmailFrom";
		public const string EmailServer = "EmailServer";
		public const string ProductId = "hfProductId";
		public const string CompanyId = "hfCompanyId";
		public const string EmailEnabled = "EmailEnabled";
		public const string LoggingEnabled = "LoggingEnabled";
		private const string EventLog_Source = "OpenHack";
		private const string RegKeyPath = @"Software\Microsoft\OpenHack";

		internal static string DbConnectionString = null;
		private static string _lockMe = "*lockme*";
		private const string sessionCookie = "ASP.NET_SessionId";

		protected void Application_EndRequest(Object sender, EventArgs e) {
			
			// if the site is in SSL mode, set the RFC 2109 SECURE bit on outbound cookies
			if( ConfigHelper.GetConfigBool("RequireSSL") ) {
				string formsTicket = FormsAuthentication.FormsCookieName;
				
				foreach(string nm in Response.Cookies) {
					if(nm == formsTicket || nm == sessionCookie) {
						Response.Cookies[nm].Secure = true;
					}
				}
			}
		}
		
		protected void Application_Start(Object sender, EventArgs e) {
			RegistryKey regKey = null;
#if USE_MGMT_EVENTS
			OpenHackAppStartEvent ev = new OpenHackAppStartEvent();
			MgmtEvent.FireEvent(ev);
#endif

			try {
				regKey = Registry.LocalMachine.OpenSubKey(RegKeyPath);
			}
			catch {
				throw new ApplicationException(@"Registry key not found. [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\OpenHack]");
			}
			try {

				if (ConfigurationSettings.AppSettings[Global.DbType].ToLower() == "oracle") {
					if (regKey.GetValue("OracleConnString") != null)
						HttpContext.Current.Cache.Add(Global.ConnectionString, regKey.GetValue("OracleConnString"), null, DateTime.MaxValue, TimeSpan.Zero, System.Web.Caching.CacheItemPriority.Default, null);
					else
						throw new ApplicationException("Registry Setting 'OracleConnString' does not exist.");
				}
				else if (ConfigurationSettings.AppSettings[Global.DbType].ToLower() == "sql") {
					if (regKey.GetValue("SqlConnString") != null) {
						if( null == DbConnectionString  ) {
							lock(_lockMe) {
								if( null == DbConnectionString ) {
									string val = regKey.GetValue("SqlConnString") as string;
									if( null != val ) {
										DbConnectionString = DataProtection.UnprotectData(val);
									}
								}
							}
						}
					}
					else
						throw new ApplicationException("Registery Setting 'SqlConnString' does not exist.");
				}
				else
					throw new ApplicationException("Application Setting 'DbType' must be equal to 'Oracle' or 'Sql'.");

				if( null == DbConnectionString) {
					throw new ApplicationException("Failed to retrieve connection string: Application is not correctly installed");
				}
			}
			finally {
				if(null != regKey ) {
					regKey.Close();
				}
			}

		}
		
		/// <summary>
		/// Global application level error handling. This method is invoked 
		/// anytime an exception is thrown. 
		/// </summary>
		/// <param name="sender">Sender.</param>
		/// <param name="e">Event arguments.</param>
		protected void Application_Error(Object sender, EventArgs e) {
			if( ConfigHelper.GetConfigBool(LoggingEnabled) ) {			
				string nl = "\n\n";
				StringBuilder errMessage = new StringBuilder(1024);
				errMessage.Append("OpenHack Application Error");
				errMessage.Append(nl);
				errMessage.Append("Request: ");
				errMessage.Append(Request.Url.ToString());
				errMessage.Append(nl);
				errMessage.Append("Stack Trace: \n");
				errMessage.Append(Server.GetLastError().ToString());
				errMessage.Append("\n");
				errMessage.Append("Principal: ");
				errMessage.Append(WindowsIdentity.GetCurrent().Name);
												
			
				// make sure we have an event log
				if (EventLog.SourceExists(EventLog_Source)) {
					EventLog m_eventLog = null;
					m_eventLog = new EventLog("Application");
					m_eventLog.Source = EventLog_Source;
	
					// log the message
					string msg = errMessage.ToString();
					m_eventLog.WriteEntry(msg, System.Diagnostics.EventLogEntryType.Error);

#if USE_MGMT_EVENTS
					// fire a WMI event if configured
					OpenHackErrorEvent ev = new OpenHackErrorEvent();
					ev.ExceptionText = msg;
					MgmtEvent.FireEvent(ev);
#endif
				}
				else {
					// The event source doesn't exist, it needs to be created
					// by a user who has administrator privllages.
				}
			}
		}
	}
}

