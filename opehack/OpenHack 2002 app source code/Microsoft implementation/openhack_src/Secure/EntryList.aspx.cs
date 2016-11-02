using System;
using System.Data;

namespace OpenHack
{
	/// <summary>
	/// Summary description for entrylist.
	/// </summary>
	public class Entrylist : System.Web.UI.Page
	{
		protected System.Web.UI.WebControls.DataGrid dgList;
		protected System.Web.UI.HtmlControls.HtmlGenericControl divMessage;
	
		private void Page_Load(object sender, System.EventArgs e)
		{
			string userId = CleanString.SqlText(Context.User.Identity.Name, 10);

			//get the list
			DataSet ds = ProductInfo.GetProductList(userId);

			if (ds.Tables[0].Rows.Count > 0)
			{
				// SECREVIEW: we should do per column binding so we can encode here
				dgList.CellPadding = 5;
				dgList.DataSource = ds.Tables[0].DefaultView;
				dgList.DataBind();

				//disable the no-products link
				divMessage.Visible = false;
			}
		}

		#region Web Form Designer generated code
		override protected void OnInit(EventArgs e)
		{
			//
			// CODEGEN: This call is required by the ASP.NET Web Form Designer.
			//
			InitializeComponent();
			base.OnInit(e);
		}
		
		/// <summary>
		/// Required method for Designer support - do not modify
		/// the contents of this method with the code editor.
		/// </summary>
		private void InitializeComponent()
		{    
			this.Load += new System.EventHandler(this.Page_Load);

		}
		#endregion
	}
}
