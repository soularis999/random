using System;
using System.Data;

namespace OpenHack
{
	/// <summary>
	/// Summary description for StatesInfo.
	/// </summary>
	public sealed class StatesInfo
	{
		public static DataSet GetStates()
		{			
			return DbHelper.ExecuteDataSet("GetStates", null);
		}
	}
}
