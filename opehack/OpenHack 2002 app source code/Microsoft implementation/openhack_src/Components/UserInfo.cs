using System;
using System.Data;
using System.Data.SqlClient;
using System.Web;
using System.Web.Security;

namespace OpenHack
{
	/// <summary>
	/// Summary description for User.
	/// </summary>
	public sealed class UserInfo
	{
		public static HttpCookie CreateTicket(string userid, string username) 
		{
			HttpCookie ck = null;

			FormsAuthenticationTicket tick = new FormsAuthenticationTicket(0, userid, DateTime.Now, DateTime.Now.AddMinutes(30),
				false, username, FormsAuthentication.FormsCookiePath);
			string cipherText = FormsAuthentication.Encrypt(tick);
			if( null != cipherText ) 
			{
				ck = new HttpCookie(FormsAuthentication.FormsCookieName, cipherText);
				ck.Path = FormsAuthentication.FormsCookiePath;
				ck.Secure = ConfigHelper.GetConfigBool("RequireSSL");
			}
			return ck;
		}

		public static bool CheckPassword(string userId, string password)
		{
			string cipherPass = CryptUtil.EncryptString(password, false);
			SqlParameter[] dbParams = new SqlParameter[]
				{
					DbHelper.MakeParam("@USERID", SqlDbType.VarChar, 10, userId),
					DbHelper.MakeParam("@PASSWORD", SqlDbType.VarChar, 50, cipherPass)
				};

			//int cast doesn't work with oracle, must parse
			if (Convert.ToInt32(DbHelper.ExecuteScalar("CheckPassword", dbParams)) == 1)
				return true;
			else
				return false;
		}

		public static void UpdatePassword(string userId, string password, string newPassword)
		{
			string cipherPass = CryptUtil.EncryptString(password, false);
			string cipherNew = CryptUtil.EncryptString(newPassword, false);

			SqlParameter[] dbParams = new SqlParameter[]
				{
					DbHelper.MakeParam("@USERID", SqlDbType.VarChar, 10, userId),
					DbHelper.MakeParam("@PASSWORD", SqlDbType.VarChar, 50, cipherPass),
					DbHelper.MakeParam("@NEWPASSWORD", SqlDbType.VarChar, 50, cipherNew)
				};

			DbHelper.ExecuteNonQuery("UpdatePassword", dbParams);
		}

		public static string GetUserEmail(string userId)
		{
			SqlParameter[] dbParams = new SqlParameter[]
				{
					DbHelper.MakeParam("@USERID", SqlDbType.VarChar, 10, userId)
				};

			return DbHelper.ExecuteScalar("GetUserEmail", dbParams).ToString();
		}

		public static DataSet GetUserLostPassword(string userEmail)
		{
			SqlParameter[] dbParams = new SqlParameter[]
				{
					DbHelper.MakeParam("@USEREMAIL", SqlDbType.VarChar, 50, userEmail)
				};

			return DbHelper.ExecuteDataSet("GetUserLostPassword", dbParams);
		}

		public static DataSet GetUserInfo(string userId)
		{
			SqlParameter[] dbParams = new SqlParameter[]
				{
					DbHelper.MakeParam("@USERID", SqlDbType.VarChar, 10, userId)
				};

			return DbHelper.ExecuteDataSet("GetUserInfo", dbParams);
		}

		public static bool IsEmailTaken(string userId, string newEmail)
		{
			SqlParameter[] dbParams = new SqlParameter[]
				{
					DbHelper.MakeParam("@USERID", SqlDbType.VarChar, 10, userId),
					DbHelper.MakeParam("@NEWEMAIL", SqlDbType.VarChar, 50, newEmail)
				};

			//int cast doesn't work with oracle, must convert
			if (Convert.ToInt32(DbHelper.ExecuteScalar("IsEmailTaken", dbParams)) > 0)
				return true;
			else
				return false;
		}

		public static bool IsUserIdTaken(string userId)
		{
			SqlParameter[] dbParams = new SqlParameter[]
				{
					DbHelper.MakeParam("@USERID", SqlDbType.VarChar, 10, userId)
				};

			//int cast doesn't work with oracle, must convert
			if (Convert.ToInt32(DbHelper.ExecuteScalar("IsUserIdTaken", dbParams)) > 0)
				return true;
			else
				return false;
		}

		public static void UpdateUserInfo(string userId, string userName, string userTitle, string companyName, string userPhone, string userEmail, string notifyNextyear)
		{
			SqlParameter[] dbParams = new SqlParameter[]
				{
					DbHelper.MakeParam("@USERID", SqlDbType.VarChar, 10, userId),
					DbHelper.MakeParam("@USERNAME", SqlDbType.VarChar, 30, userName),
					DbHelper.MakeParam("@USERTITLE", SqlDbType.VarChar, 50, userTitle),
					DbHelper.MakeParam("@COMPANYNAME", SqlDbType.VarChar, 50, companyName),
					DbHelper.MakeParam("@USERPHONE", SqlDbType.VarChar, 20, userPhone),
					DbHelper.MakeParam("@USEREMAIL", SqlDbType.VarChar, 50, userEmail),
					DbHelper.MakeParam("@NOTIFYNEXTYEAR", SqlDbType.Char, 1, notifyNextyear[0])
				};

			DbHelper.ExecuteNonQuery("UpdateUserInfo", dbParams);
		}

		public static void AddNewUser(string userId, string userPassword, string userName, string userTitle, string companyName, string userPhone, string userEmail, string notifyNextyear)
		{
			string cipherPass = CryptUtil.EncryptString(userPassword, false);
			
			SqlParameter[] dbParams = new SqlParameter[]
				{
					DbHelper.MakeParam("@USERID", SqlDbType.VarChar, 10, userId),
					DbHelper.MakeParam("@USERPASSWORD", SqlDbType.VarChar, 50, cipherPass),
					DbHelper.MakeParam("@USERNAME", SqlDbType.VarChar, 30, userName),
					DbHelper.MakeParam("@USERTITLE", SqlDbType.VarChar, 50, userTitle),
					DbHelper.MakeParam("@COMPANYNAME", SqlDbType.VarChar, 50, companyName),
					DbHelper.MakeParam("@USERPHONE", SqlDbType.VarChar, 20, userPhone),
					DbHelper.MakeParam("@USEREMAIL", SqlDbType.VarChar, 50, userEmail),
					DbHelper.MakeParam("@NOTIFYNEXTYEAR", SqlDbType.Char, 1, notifyNextyear[0])
				};

			DbHelper.ExecuteNonQuery("AddNewUser", dbParams);
		}
	}
}
