using System;
using System.Data;

namespace OpenHack
{
	/// <summary>
	/// Summary description for CreditCardInfo.
	/// </summary>
	public sealed class CreditCardInfo
	{
		public static DataSet GetCreditCardBrands()
		{
			return DbHelper.ExecuteDataSet("GetCreditCardBrands", null);
		}
	}
}
