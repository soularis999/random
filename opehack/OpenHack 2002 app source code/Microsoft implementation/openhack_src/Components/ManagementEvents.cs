using System;
using System.Management;
using System.ComponentModel;
using System.Management.Instrumentation;
using System.Configuration.Install;
using System.Diagnostics;

#if USE_MGMT_EVENTS
[assembly:Instrumented("root\\CIMV2\\Applications\\OpenHackApp")]
#endif

namespace OpenHack {

#if USE_MGMT_EVENTS
	[System.ComponentModel.RunInstaller(true)]
	public class OpenHackProjectInstaller:DefaultManagementProjectInstaller {
	}
#endif

	[RunInstaller(true)]
	public class OpenHackPCInstaller: Installer {
		public OpenHackPCInstaller() {
			try {
				
				// create installer
				PerformanceCounterInstaller pcInst =
					new PerformanceCounterInstaller();

				// add counters
				string catName = "OpenHackApplication";
				pcInst.CategoryName = catName;
				
				// db queries
				CounterCreationData pcCreation = new CounterCreationData();
				pcCreation.CounterName = "DBQueries Succeeded";
				pcCreation.CounterHelp = "Number of successful SQL Queries Executed";				
				pcInst.Counters.Add(pcCreation);

				CounterCreationData dbFailed = new CounterCreationData();
				dbFailed.CounterName = "DBQueries Failed";
				dbFailed.CounterHelp = "Number of failed SQL Queries Executed";				
				pcInst.Counters.Add(dbFailed);
				
				// logons
				CounterCreationData pcLogons = new CounterCreationData();
				pcLogons.CounterName = "Logons";
				pcLogons.CounterHelp = "Number of successful logons";				
				pcInst.Counters.Add(pcLogons);

				CounterCreationData pcLogonFailures = new CounterCreationData();
				pcLogonFailures.CounterName = "Logon Failures";
				pcLogonFailures.CounterHelp = "Number of successful logons";				
				pcInst.Counters.Add(pcLogonFailures);

				// event log installer
				EventLogInstaller myEventLogInstaller = new EventLogInstaller();
				// Set the 'Source' of the event log, to be created.
				myEventLogInstaller.Source = "OpenHack";
				// Set the 'Log' that the source is created in.
				myEventLogInstaller.Log = "Application";


				Installers.Add(myEventLogInstaller);   
				Installers.Add(pcInst);

			}
			catch(Exception e) {
				Console.WriteLine("Error occured installing perf counters: {0}" + e.Message);
			}
		}

	}

	//public class OpenHackErrorEvent : BaseEvent {
	//	public string ExceptionText;
	//}

	//public class OpenHackAppEvent : BaseEvent {}

	//public class OpenHackAppStartEvent : BaseEvent {}

	internal class MgmtEvent {
#if USE_MGMT_EVENTS
		private static bool _inited = false;
		private static bool _fireEvents = false;
#endif
		private const string _catName = "OpenHackApplication";

		private static PerformanceCounter _dbQueries = null;
		private static PerformanceCounter _dbFailed = null;
		private static PerformanceCounter _logons = null;
		private static PerformanceCounter _logonFailures = null;
		private static string _lockme = "*lockmePC*";

		internal static PerformanceCounter DBQueries {
			get {
				if( null == _dbQueries ) {
					lock(_lockme ) {
						if( null == _dbQueries ) {
							_dbQueries = new PerformanceCounter(_catName, "DBQueries Succeeded", false);
						}
					}
				}

				return _dbQueries;
			}
		}

		internal static PerformanceCounter DBQueriesFailed {
			get {
				if( null == _dbFailed ) {
					lock(_lockme ) {
						if( null == _dbFailed ) {
							_dbFailed = new PerformanceCounter(_catName, "DBQueries Failed", false);
						}
					}
				}

				return _dbFailed;
			}
		}

		internal static PerformanceCounter Logons {
			get {
				if( null == _logons ) {
					lock(_lockme ) {
						if( null == _logons ) {
							_logons = new PerformanceCounter(_catName, "Logons", false);
						}
					}
				}
				return _logons;
			}
		}
		internal static PerformanceCounter LogonFailures {
			get {
				if( null == _logonFailures ) {
					lock(_lockme ) {
						if( null == _logonFailures ) {
							_logonFailures = new PerformanceCounter(_catName, "Logon Failures", false);
						}
					}
				}

				return _logonFailures;
			}
		}

		public static void IncrementCounter(PerformanceCounter c) {
			c.Increment();
		}
#if USE_MGMT_EVENTS
		public static void FireEvent(BaseEvent ev) {

			if( !_inited ) {
				_fireEvents = ConfigHelper.GetConfigBool("ManagementEvents");
				_inited = true;
			}

			if( _fireEvents ) {
				ev.Fire();
			}
		}
#endif
	}
}

