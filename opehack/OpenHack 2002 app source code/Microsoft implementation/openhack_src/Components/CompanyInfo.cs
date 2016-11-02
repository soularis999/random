using System;
using System.Data;
using System.Data.SqlClient;
using System.Text;

namespace OpenHack
{
	/// <summary>
	/// Summary description for Company.
	/// </summary>
	public sealed class CompanyInfo
	{
		public static int GetNumCompaniesRegistered(string userId)
		{
			SqlParameter[] dbParams = new SqlParameter[]
				{
					DbHelper.MakeParam("@USERID", SqlDbType.VarChar, 10, userId)
				};

			//int cast doesn't work with oracle, must convert
			return Convert.ToInt32(DbHelper.ExecuteScalar("GetNumCompaniesRegistered", dbParams));
		}

		public static DataSet GetCompanyList(string userId)
		{
			SqlParameter[] dbParams = new SqlParameter[]
				{
					DbHelper.MakeParam("@USERID", SqlDbType.VarChar, 10, userId)
				};

			return DbHelper.ExecuteDataSet("GetCompanyList", dbParams);
		}

		public static DataSet GetAllUserCompanies(string userId)
		{
			SqlParameter[] dbParams = new SqlParameter[]
				{
					DbHelper.MakeParam("@USERID", SqlDbType.VarChar, 10, userId)
				};

			return DbHelper.ExecuteDataSet("GetAllUserCompanies", dbParams);
		}

		public static string GetCompanyName(string companyId)
		{
			SqlParameter[] dbParams = new SqlParameter[]
				{
					DbHelper.MakeParam("@COMPANYID", SqlDbType.Int, 0, Int32.Parse(companyId))
				};

			return DbHelper.ExecuteScalar("GetCompanyName", dbParams).ToString();
		}

		public static bool IsUserCompany(string userId, string companyId)
		{
			SqlParameter[] dbParams = new SqlParameter[]
				{
					DbHelper.MakeParam("@USERID", SqlDbType.VarChar, 10, userId),
					DbHelper.MakeParam("@COMPANYID", SqlDbType.Int, 0, Int32.Parse(companyId))
				};

			//int cast doesn't work with oracle, must convert
			if (Convert.ToInt32(DbHelper.ExecuteScalar("IsUserCompany", dbParams)) == 1)
				return true;
			else
				return false;
		}

		public static DataSet GetCompanyAndPaymentInfo(string companyId)
		{
			SqlParameter[] dbParams = new SqlParameter[]
				{
					DbHelper.MakeParam("@COMPANYID", SqlDbType.Int, 0, Int32.Parse(companyId))
				};

			return DbHelper.ExecuteDataSet("GetCompanyAndPaymentInfo", dbParams);
		}

		public static string AddNewCompany(string userId, string companyName, string companyAddress1, string companyAddress2, string companyCity, string companyState, string companyZip, string companyCountry, string companyPhone, string companyFax, string companyUrl)
		{
			SqlParameter[] dbParams = new SqlParameter[]
				{
					DbHelper.MakeParam("@USERID", SqlDbType.VarChar, 10, userId),
					DbHelper.MakeParam("@COMPANYNAME", SqlDbType.VarChar, 100, companyName),
					DbHelper.MakeParam("@COMPANYADDRESS1", SqlDbType.VarChar, 50, companyAddress1),
					DbHelper.MakeParam("@COMPANYADDRESS2", SqlDbType.VarChar, 50, companyAddress2),
					DbHelper.MakeParam("@COMPANYCITY", SqlDbType.VarChar, 30, companyCity),
					DbHelper.MakeParam("@COMPANYSTATE", SqlDbType.VarChar, 2, companyState),
					DbHelper.MakeParam("@COMPANYZIP", SqlDbType.VarChar, 15, companyZip),
					DbHelper.MakeParam("@COMPANYCOUNTRY", SqlDbType.VarChar, 30, companyCountry),
					DbHelper.MakeParam("@COMPANYPHONE", SqlDbType.VarChar, 20, companyPhone),
					DbHelper.MakeParam("@COMPANYFAX", SqlDbType.VarChar, 20, companyFax),
					DbHelper.MakeParam("@COMPANYURL", SqlDbType.VarChar, 100, companyUrl)
				};

			//add company to company table and to user_companies table
			return DbHelper.ExecuteScalar("AddNewCompany", dbParams).ToString();
		}

		public static void UpdateCompany(string companyId, string companyName, string companyAddress1, string companyAddress2, string companyCity, string companyState, string companyZip, string companyCountry, string companyPhone, string companyFax, string companyUrl)
		{
			SqlParameter[] dbParams = new SqlParameter[]
				{
					DbHelper.MakeParam("@COMPANYID", SqlDbType.Int, 0, int.Parse(companyId)),
					DbHelper.MakeParam("@COMPANYNAME", SqlDbType.VarChar, 100, companyName),
					DbHelper.MakeParam("@COMPANYADDRESS1", SqlDbType.VarChar, 50, companyAddress1),
					DbHelper.MakeParam("@COMPANYADDRESS2", SqlDbType.VarChar, 50, companyAddress2),
					DbHelper.MakeParam("@COMPANYCITY", SqlDbType.VarChar, 30, companyCity),
					DbHelper.MakeParam("@COMPANYSTATE", SqlDbType.VarChar, 2, companyState),
					DbHelper.MakeParam("@COMPANYZIP", SqlDbType.VarChar, 15, companyZip),
					DbHelper.MakeParam("@COMPANYCOUNTRY", SqlDbType.VarChar, 30, companyCountry),
					DbHelper.MakeParam("@COMPANYPHONE", SqlDbType.VarChar, 20, companyPhone),
					DbHelper.MakeParam("@COMPANYFAX", SqlDbType.VarChar, 20, companyFax),
					DbHelper.MakeParam("@COMPANYURL", SqlDbType.VarChar, 100, companyUrl)
				};

			DbHelper.ExecuteNonQuery("UpdateCompany", dbParams);
		}

		public static void AddCheckPayment(string companyId)
		{
			SqlParameter[] dbParams = new SqlParameter[]
				{
					DbHelper.MakeParam("@COMPANYID", SqlDbType.Int, 0, Int32.Parse(companyId))
				};

			DbHelper.ExecuteNonQuery("AddCheckPayment", dbParams);
		}


		public static void AddCreditPayment(string companyId, string creditCardBrand, string creditCard, string creditCardExpiry, string billingName, string billingAddress1, string billingAddress2, string billingCity, string billingState, string billingZip, string billingCountry, string billingPhone)
		{
			string creditCardCipher = CryptUtil.EncryptString(creditCard, true);
			
			SqlParameter[] dbParams = new SqlParameter[]
				{
					DbHelper.MakeParam("@COMPANYID", SqlDbType.Int, 0, int.Parse(companyId)),
					DbHelper.MakeParam("@CREDITCARDBRAND", SqlDbType.VarChar, 10, creditCardBrand),
					DbHelper.MakeParam("@CREDITCARD", SqlDbType.VarChar, 100, creditCardCipher),
					DbHelper.MakeParam("@CREDITCARDEXPIRY", SqlDbType.VarChar, 10, creditCardExpiry),
					DbHelper.MakeParam("@BILLINGNAME", SqlDbType.VarChar, 30, billingName),
					DbHelper.MakeParam("@BILLINGADDRESS1", SqlDbType.VarChar, 30, billingAddress1),
					DbHelper.MakeParam("@BILLINGADDRESS2", SqlDbType.VarChar, 30, billingAddress2),
					DbHelper.MakeParam("@BILLINGCITY", SqlDbType.VarChar, 30, billingCity),
					DbHelper.MakeParam("@BILLINGSTATE", SqlDbType.VarChar, 2, billingState),
					DbHelper.MakeParam("@BILLINGZIP", SqlDbType.VarChar, 15, billingZip),
					DbHelper.MakeParam("@BILLINGCOUNTRY", SqlDbType.VarChar, 50, billingCountry),
					DbHelper.MakeParam("@BILLINGPHONE", SqlDbType.VarChar, 20, billingPhone)
				};

			DbHelper.ExecuteNonQuery("AddCreditPayment", dbParams);
		}

		public static void UpdatePaymentAsCheck(string companyId)
		{
			SqlParameter[] dbParams = new SqlParameter[]
				{
					DbHelper.MakeParam("@COMPANYID", SqlDbType.Int, 0, Int32.Parse(companyId))
				};

			DbHelper.ExecuteNonQuery("UpdatePaymentAsCheck", dbParams);
		}

		public static void UpdatePaymentAsCredit(string companyId, string creditCardBrand, string creditCard, string creditCardExpiry, string billingName, string billingAddress1, string billingAddress2, string billingCity, string billingState, string billingZip, string billingCountry, string billingPhone)
		{
			string creditCardCipher = CryptUtil.EncryptString(creditCard, true);

			SqlParameter[] dbParams = new SqlParameter[]
				{
					DbHelper.MakeParam("@COMPANYID", SqlDbType.Int, 0, Int32.Parse(companyId)),
					DbHelper.MakeParam("@CREDITCARDBRAND", SqlDbType.VarChar, 10, creditCardBrand),
					DbHelper.MakeParam("@CREDITCARD", SqlDbType.VarChar, 100, creditCardCipher),
					DbHelper.MakeParam("@CREDITCARDEXPIRY", SqlDbType.VarChar, 10, creditCardExpiry),
					DbHelper.MakeParam("@BILLINGNAME", SqlDbType.VarChar, 30, billingName),
					DbHelper.MakeParam("@BILLINGADDRESS1", SqlDbType.VarChar, 30, billingAddress1),
					DbHelper.MakeParam("@BILLINGADDRESS2", SqlDbType.VarChar, 30, billingAddress2),
					DbHelper.MakeParam("@BILLINGCITY", SqlDbType.VarChar, 30, billingCity),
					DbHelper.MakeParam("@BILLINGSTATE", SqlDbType.VarChar, 2, billingState),
					DbHelper.MakeParam("@BILLINGZIP", SqlDbType.VarChar, 15, billingZip),
					DbHelper.MakeParam("@BILLINGCOUNTRY", SqlDbType.VarChar, 50, billingCountry),
					DbHelper.MakeParam("@BILLINGPHONE", SqlDbType.VarChar, 20, billingPhone)
				};

			DbHelper.ExecuteNonQuery("UpdatePaymentAsCredit", dbParams);
		}
	}
}
