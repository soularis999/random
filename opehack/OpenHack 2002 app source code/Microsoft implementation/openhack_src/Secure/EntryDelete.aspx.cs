using System;
using System.Data;
using System.Configuration;

namespace OpenHack
{
	/// <summary>
	/// Summary description for entrydelete.
	/// </summary>
	public class EntryDelete : System.Web.UI.Page
	{
		string productId = String.Empty;
		protected System.Web.UI.WebControls.Button btnDelete;
		protected System.Web.UI.WebControls.Button btnCancel;
		protected System.Web.UI.WebControls.Label lblCompanyName;
		protected System.Web.UI.WebControls.Label lblProductName;
		protected System.Web.UI.WebControls.Label lblVersion;
		protected System.Web.UI.HtmlControls.HtmlInputHidden hfProductId;
		protected System.Web.UI.WebControls.Label lblRecordCreationTimeStamp;
	
		private void Page_Load(object sender, System.EventArgs e)
		{
			string userId = CleanString.SqlText(Context.User.Identity.Name, 10);

			// determine if entry deadline has passed
			if (DateTime.Now > DateTime.Parse(ConfigurationSettings.AppSettings[Global.ContestEndDate]))
			{
				//set msg and redirect
				Session.Add(Global.Session_PageMessage,PageMessage.Product_DeadLinePassed);
				Response.Redirect(UrlHelper.CreatePath(Context, "Default.aspx"));
				return;
			}

			//grab form & query values if they exist
			productId = CleanString.FetchInputDigit(Request, Global.ProductId, 10);
			
			if (productId == String.Empty)
			{
				//missing productid
				//set msg and redirect
				Session.Add(Global.Session_PageMessage, PageMessage.Product_ParamMissing);
				Response.Redirect(UrlHelper.CreatePath(Context, "Default.aspx"));
				return;
			}
			else
			{
				//verify the product id
				if (!ProductInfo.IsUserProduct(userId, productId))
				{
					//nothing found user is cheating
					//set msg and redirect to home page
					Session.Add(Global.Session_PageMessage, PageMessage.Product_NotAuthorized);
					Response.Redirect(UrlHelper.CreatePath(Context, "Default.aspx"));
					return;
				}
			}

			if(!Page.IsPostBack)
			{
				//set the hidden field
				hfProductId.Value = productId;

				//get productinfo
				DataSet dsProductInfo = ProductInfo.GetProductInfo(productId);

				if (dsProductInfo.Tables[0].Rows.Count == 1)
				{
					DataRow dr = dsProductInfo.Tables[0].Rows[0];

					// SECREVIEW: HTML encode all data coming from the DB
					CleanString.SetLabel(lblCompanyName, dr["COMPANYNAME"]);
					CleanString.SetLabel(lblProductName, dr["PRODUCTNAME"]);
					CleanString.SetLabel(lblVersion, dr["VERSION"]);
					CleanString.SetLabel(lblRecordCreationTimeStamp, dr["RECORDCREATIONTIMESTAMP"]);
				}
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
			this.btnDelete.Click += new System.EventHandler(this.btnDelete_Click);
			this.btnCancel.Click += new System.EventHandler(this.btnCancel_Click);
			this.Load += new System.EventHandler(this.Page_Load);
		}
		#endregion

		private void btnCancel_Click(object sender, System.EventArgs e)
		{
			//cancel

			//set msg and redirect
			Session.Add(Global.Session_PageMessage, PageMessage.Product_ActionCancelled);
			Response.Redirect("EntryList.aspx");
			return;
		}

		private void btnDelete_Click(object sender, System.EventArgs e)
		{
			//user passed page load check

			//delete the entry
			ProductInfo.DeleteProduct(productId);

			//set msg and redirect
			Session.Add(Global.Session_PageMessage, PageMessage.Product_Deleted);
			Response.Redirect("EntryList.aspx");
			return;
		}
	}
}
