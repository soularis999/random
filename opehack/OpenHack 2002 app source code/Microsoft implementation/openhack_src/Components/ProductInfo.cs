using System;
using System.Data;
using System.Data.SqlClient;

namespace OpenHack
{
	/// <summary>
	/// Summary description for Product.
	/// </summary>
	public sealed class ProductInfo
	{
		public static int GetNumEntriesSubmitted(string userId)
		{
			SqlParameter[] dbParams = new SqlParameter[]
				{
					DbHelper.MakeParam("@USERID", SqlDbType.VarChar, 10, userId)
				};

			//int cast doesn't work with oracle, must convert
			return Convert.ToInt32(DbHelper.ExecuteScalar("GetNumEntriesSubmitted", dbParams));
		}

		public static bool IsUserProduct(string userId, string productId)
		{
			SqlParameter[] dbParams = new SqlParameter[]
				{
					DbHelper.MakeParam("@USERID", SqlDbType.VarChar, 10, userId),
					DbHelper.MakeParam("@PRODUCTID", SqlDbType.Int, 0, productId)
				};

			//int cast doesn't work with oracle, must convert
			if (Convert.ToInt32(DbHelper.ExecuteScalar("IsUserProduct", dbParams)) == 1)
				return true;
			else
				return false;
		}

		public static object GetCompanyId(string userId, string productId)
		{
			SqlParameter[] dbParams = new SqlParameter[]
				{
					DbHelper.MakeParam("@USERID", SqlDbType.VarChar, 10, userId),
					DbHelper.MakeParam("@PRODUCTID", SqlDbType.Int, 0, productId)
				};

			return DbHelper.ExecuteScalar("GetCompanyId", dbParams);
		}

		public static DataSet GetProductInfo(string productId)
		{
			SqlParameter[] dbParams = new SqlParameter[]
				{
					DbHelper.MakeParam("@PRODUCTID", SqlDbType.Int, 0, productId)
				};

			return DbHelper.ExecuteDataSet("GetProductInfo", dbParams);
		}

		public static DataSet GetProductList(string userId)
		{
			SqlParameter[] dbParams = new SqlParameter[]
				{
					DbHelper.MakeParam("@USERID", SqlDbType.VarChar, 10, userId)
				};

			return DbHelper.ExecuteDataSet("GetProductList", dbParams);
		}

		public static void DeleteProduct(string productId)
		{
			SqlParameter[] dbParams = new SqlParameter[]
				{
					DbHelper.MakeParam("@PRODUCTID", SqlDbType.Int, 0, productId)
				};

            DbHelper.ExecuteNonQuery("DeleteProduct", dbParams);
		}

		public static void AddNewProduct(string companyId, string productName, string version, string announcementDate, string shipDate, string productUrl, string productNda, string targetAudience, string description, string businessProblem, string competitors, string keyFeatures, string price, string customerReferences)
		{
			SqlParameter[] dbParams = new SqlParameter[]
				{
					DbHelper.MakeParam("@COMPANYID", SqlDbType.Int, 0, companyId),
					DbHelper.MakeParam("@PRODUCTNAME", SqlDbType.VarChar, 100, productName),
					DbHelper.MakeParam("@VERSION", SqlDbType.VarChar, 30, version),
					DbHelper.MakeParam("@ANNOUNCEMENTDATE", SqlDbType.VarChar, 30, announcementDate),
					DbHelper.MakeParam("@SHIPDATE", SqlDbType.VarChar, 30, shipDate),
					DbHelper.MakeParam("@PRODUCTURL", SqlDbType.VarChar, 100, productUrl),
					DbHelper.MakeParam("@PRODUCTNDA", SqlDbType.Char, 1, productNda[0]),
					DbHelper.MakeParam("@TARGETAUDIENCE", SqlDbType.Text, 0, targetAudience),
					DbHelper.MakeParam("@DESCRIPTION", SqlDbType.Text, 0, description),
					DbHelper.MakeParam("@BUSINESSPROBLEM", SqlDbType.Text, 0, businessProblem),
					DbHelper.MakeParam("@COMPETITORS", SqlDbType.Text, 0, competitors),
					DbHelper.MakeParam("@KEYFEATURES", SqlDbType.Text, 0, keyFeatures),
					DbHelper.MakeParam("@PRICE", SqlDbType.Text, 0, price),
					DbHelper.MakeParam("@CUSTOMERREFERENCES", SqlDbType.Text, 0, customerReferences),
				};

			DbHelper.ExecuteNonQuery("AddNewProduct", dbParams);
		}

		public static void UpdateProduct(string productId, string productName, string version, string announcementDate, string shipDate, string productUrl, string productNda, string targetAudience, string description, string businessProblem, string competitors, string keyFeatures, string price, string customerReferences)
		{
			SqlParameter[] dbParams = new SqlParameter[]
				{
					DbHelper.MakeParam("@PRODUCTID", SqlDbType.Int, 0, productId),
					DbHelper.MakeParam("@PRODUCTNAME", SqlDbType.VarChar, 100, productName),
					DbHelper.MakeParam("@VERSION", SqlDbType.VarChar, 30, version),
					DbHelper.MakeParam("@ANNOUNCEMENTDATE", SqlDbType.VarChar, 30, announcementDate),
					DbHelper.MakeParam("@SHIPDATE", SqlDbType.VarChar, 30, shipDate),
					DbHelper.MakeParam("@PRODUCTURL", SqlDbType.VarChar, 100, productUrl),
					DbHelper.MakeParam("@PRODUCTNDA", SqlDbType.Char, 1, productNda[0]),
					DbHelper.MakeParam("@TARGETAUDIENCE", SqlDbType.Text, 0, targetAudience),
					DbHelper.MakeParam("@DESCRIPTION", SqlDbType.Text, 0, description),
					DbHelper.MakeParam("@BUSINESSPROBLEM", SqlDbType.Text, 0, businessProblem),
					DbHelper.MakeParam("@COMPETITIORS", SqlDbType.Text, 0, competitors),
					DbHelper.MakeParam("@KEYFEATURES", SqlDbType.Text, 0, keyFeatures),
					DbHelper.MakeParam("@PRICE", SqlDbType.Text, 0, price),
					DbHelper.MakeParam("@CUSTOMERREFERENCES", SqlDbType.Text, 0, customerReferences),
			};

			DbHelper.ExecuteNonQuery("UpdateProduct", dbParams);
		}
	}
}
