using System;
using System.Data;
using System.Data.SqlClient;
using System.Data.OleDb;
using System.Web;
using System.Security.Principal;


namespace OpenHack {
	/// <summary>
	/// Summary description for DbHelper.
	/// </summary>
	public sealed class DbHelper {
		private static bool _inited = false;
		private static bool _useImpersonation = false;

		private static bool UseImpersonation {
			get {
				// no need to lock here, cost of double init is miniscule
				if( _inited == false ) {
					_useImpersonation = ConfigHelper.GetConfigBool("SqlImpersonate");
					_inited = true;
				}

				return _useImpersonation;
			}
		}

		private static WindowsImpersonationContext ImpersonateRequestUser() {
			WindowsImpersonationContext ctx = null;

			// grab the request token from ASP.NET
			// and use the WindowsIdentity class to impersonate on the current thread
			// we'll impersonate only for the duration of the DB call and then restore
			// the previous (process) context.
			IntPtr token = 
				((HttpWorkerRequest)((IServiceProvider)HttpContext.Current).GetService(
				typeof(HttpWorkerRequest))).GetUserToken();

			if(IntPtr.Zero != token ) {
				ctx = WindowsIdentity.Impersonate(token);
			}

			return ctx;
		}


		public static DataSet ExecuteDataSet(string sqlSpName, SqlParameter[] dbParams) {
			WindowsImpersonationContext ctx = null;
			DataSet ds = null;

			if( UseImpersonation ) {
				ctx = ImpersonateRequestUser();
			}			
			try {
				ds = new DataSet();

				SqlConnection cn = new SqlConnection(Global.DbConnectionString);
				SqlCommand cmd = new SqlCommand(sqlSpName, cn);
				cmd.CommandType = CommandType.StoredProcedure;
				SqlDataAdapter da = new SqlDataAdapter(cmd);

				if (dbParams != null) {
					foreach (SqlParameter dbParam in dbParams) {
						da.SelectCommand.Parameters.Add(dbParam);
					}
				}

				da.Fill(ds);
				MgmtEvent.IncrementCounter(MgmtEvent.DBQueries);
			}
			catch(Exception) {
				MgmtEvent.IncrementCounter(MgmtEvent.DBQueriesFailed);
				throw;
			}
			finally {
				if( null != ctx )
					ctx.Undo();
			}
			return ds;
		}
	
		public static void ExecuteNonQuery(string sqlSpName, SqlParameter[] dbParams) {			
			WindowsImpersonationContext ctx = null;
			if( UseImpersonation ) {
				ctx = ImpersonateRequestUser();
			}

			SqlConnection cn = new SqlConnection(Global.DbConnectionString);
			SqlCommand cmd = new SqlCommand(sqlSpName, cn);
			cmd.CommandType = CommandType.StoredProcedure;

			if (dbParams != null) {
				foreach (SqlParameter dbParam in dbParams) {
					cmd.Parameters.Add(dbParam);
				}
			}
			
			cn.Open();

			try {
				cmd.ExecuteNonQuery();
				MgmtEvent.IncrementCounter(MgmtEvent.DBQueries);
			}
			catch(Exception) {
				MgmtEvent.IncrementCounter(MgmtEvent.DBQueriesFailed);
				throw;
			}
			finally {
				try {
					if( null != cn )
						cn.Close();
				}
				finally {
					if( null != ctx ) 
						ctx.Undo();
				}
			}
		}

		public static object ExecuteScalar(string sqlSpName, SqlParameter[] dbParams) {
			WindowsImpersonationContext ctx = null;
			if( UseImpersonation ) {
				ctx = ImpersonateRequestUser();
			}

			object retVal = null;
			SqlConnection cn = new SqlConnection(Global.DbConnectionString);
			SqlCommand cmd = new SqlCommand(sqlSpName, cn);
			cmd.CommandType = CommandType.StoredProcedure;

			if (dbParams != null) {
				foreach (SqlParameter dbParam in dbParams) {
					cmd.Parameters.Add(dbParam);
				}
			}
			
			cn.Open();

			try {			
				retVal = cmd.ExecuteScalar();
				MgmtEvent.IncrementCounter(MgmtEvent.DBQueries);
			}
			catch(Exception) {
				MgmtEvent.IncrementCounter(MgmtEvent.DBQueriesFailed);
				throw;			
			}
			finally {
				try {
					if( null != cn )
						cn.Close();
				}
				finally {
					if( null != ctx )
						ctx.Undo();
				}
			}

			return retVal;
		}

		public static SqlParameter MakeParam(string paramName, SqlDbType dbType, int size, object objValue) {
			SqlParameter param;

			if (size > 0)
				param = new SqlParameter(paramName, dbType, size);
			else
				param = new SqlParameter(paramName, dbType);

			param.Value = objValue;

			return param;
		}

	}
	
}
