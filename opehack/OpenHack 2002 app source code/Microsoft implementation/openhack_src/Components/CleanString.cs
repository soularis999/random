using System;
using System.Text;
using System.Text.RegularExpressions;
using System.Web;
using System.Web.UI.WebControls;

namespace OpenHack
{
	/// <summary>
	/// Summary description for CleanString.
	/// </summary>
	public sealed class CleanString
	{
		private static Regex _isNumber = new Regex("^[0-9]+$");

		// return a digit string based on input data
		// look first in the QueryString collection, then in Form
		// return String.Empty if not found or if non-digit
		public static string FetchInputDigit(HttpRequest req, string inputKey, int maxLen) 
		{
			string retVal = String.Empty;

			if( inputKey != null && inputKey != String.Empty ) 
			{
				retVal = req.QueryString[inputKey];
				if( null == retVal ) 
				{
					retVal = req.Form[inputKey];
				}

				if( null != retVal ) 
				{		
					retVal = CleanString.SqlText(retVal, maxLen);
					if( !IsNumber(retVal) )
						retVal = String.Empty;
				}
			}

			if( retVal == null )
				retVal = String.Empty;

			return retVal;
		}
	

		public static bool IsNumber(string inputData) 
		{
			Match m = _isNumber.Match(inputData);
			return m.Success;
		}

		public static string HtmlEncode(string inputData) 
		{
			return HttpUtility.HtmlEncode(inputData);
		}


		public static void SetLabel(Label lbl, string txtInput) 
		{
			lbl.Text = HtmlEncode(txtInput);
		}

		public static void SetLabel(Label lbl, Object inputObj) 
		{
			SetLabel(lbl, inputObj.ToString());
		}
		
#if ENTITY_ESCAPING
		// HtmlEncode for entitized data, first removes the entities
		// so that they don't get double encoded
		public static string HtmlEncodeEx(string inputData) 
		{
			return HttpUtility.HtmlEncode(UnEntitizeString(inputData));
		}


		// Even though we validate all input data,
		// we're treating data in the database as hostile so we want
		// to HTML encode output data anyway.  In order to avoid double
		// encoding we need to remove entities that were put in to 
		// mitigate SQL injection
		// This is only necessary if the EntitizeString code path below
		// is in use
		public static string UnEntitizeString(string input) 
		{
			string escaped = input;

			// fast path rejection: if there are no entities
			// just return the input string.
			int ndx = input.IndexOf("&#");
			// did we get a hit?
			if( -1 != ndx ) 
			{
				StringBuilder retVal = new StringBuilder();
				const int skipOffset = 5;
				for( int i = 0; i < input.Length; i++ ) 
				{
					switch(input[i]) 
					{
						case '&':
							if( (input[i+1] == '#') && (input[i+2] == '0') && (input[i+5] == ';'))
							{
								// it's an entity	
								// ones we know about are
								// 37, 39, 40, 41, 45, 59
								switch(input[i+3]) 
								{
									case '3':
									switch(input[i+4]) 
									{
										case '7':
											retVal.Append("%");
											i += skipOffset;
											break;

										case '9':
											retVal.Append("'");
											i += skipOffset;
											break;

										default:
											retVal.Append(input[i]);
											break;
									}
										break;

									case '4':
									switch(input[i+4]) 
									{
										case '0':
											retVal.Append("(");
											i += skipOffset;
											break;

										case '1':
											retVal.Append(")");
											i += skipOffset;
											break;

										case '5':
											retVal.Append("-");
											i += skipOffset;
											break;

										default:
											retVal.Append(input[i]);
											break;
									}
										break;

									case '5':
										if( input[i+4] == '9' ) 
										{
											retVal.Append(";");
											i += skipOffset;
										}
										else
											retVal.Append(input[i]);
										break;
								}
							}
							else 
							{
								retVal.Append(input[i]);
							}
							break;

						default:
							retVal.Append(input[i]);
							break;
					}
				}

				escaped = retVal.ToString();
#if DEBUG
				// do it the slow way and make sure the match
				string test = input.Replace("&#039;", "'");
				test = test.Replace("&#040;", "(");
				test = test.Replace("&#041;", ")");
				test = test.Replace("&#059;", ";");
				test = test.Replace("&#045;", "-");
				test = test.Replace("&#037;", "%");

				if( test != escaped ) {
					throw new ApplicationException("UnEntitize string is broken: debug mismatch");
				}
#endif
			}

			return escaped;
		}

		public static string EntitizeString(string sqlInput) 
		{

			StringBuilder retVal = new StringBuilder();

			// check incoming parameters for null or blank string
			if ((sqlInput != null) && (sqlInput != String.Empty))
			{
				sqlInput = sqlInput.Trim();


				//convert some harmful symbols incase the regular
				//expression validators are changed
				// note that this can increase the length...
				// we don't really expect this to be a problem
				// since we disallow containing all but apostrophes
				// and because we use parameterized sprocs
				for (int i = 0; i < sqlInput.Length; i++)
				{
					switch (sqlInput[i])
					{
						case '\'':
							retVal.Append("&#039;");
							break;

						case '(':
							retVal.Append("&#040;");
							break;

						case ')':
							retVal.Append("&#041;");
							break;

						case ';':
							retVal.Append("&#059;");
							break;

						case '-':
							retVal.Append("&#045;");
							break;

						case '%':
							retVal.Append("&#037;");
							break;

						// passthrough
						default:
							retVal.Append(sqlInput[i]);
							break;
					}
				}

			}

			return retVal.ToString();
		}

		public static string SqlTextEx(string sqlInput, int maxLength) 
		{
			return EntitizeString(SqlText(sqlInput, maxLength));
		}
#endif
		// This was doing HtmlEncoding going into the DB
		// we prefer to encode data appropriately where used, so
		// only the length validation logic is left
		public static string SqlText(string sqlInput, int maxLength)
		{
			// check incoming parameters for null or blank string
			if ((sqlInput != null) && (sqlInput != String.Empty))
			{
				sqlInput = sqlInput.Trim();

				//chop the string incase the client-side max length
				//fields are bypassed to prevent buffer over-runs
				if (sqlInput.Length > maxLength)
					sqlInput = sqlInput.Substring(0, maxLength);
			}

			return sqlInput;
		}
	}
}
