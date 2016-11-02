using System;
using System.Data;

namespace OpenHack
{
	/// <summary>
	/// Summary description for entryview.
	/// </summary>
	public class EntryView : System.Web.UI.Page
	{
		protected System.Web.UI.WebControls.Label lblCompanyName;
		protected System.Web.UI.WebControls.Label lblProductName;
		protected System.Web.UI.WebControls.Label lblVersion;
		protected System.Web.UI.WebControls.Label lblAnnouncementDate;
		protected System.Web.UI.WebControls.Label lblShipDate;
		protected System.Web.UI.WebControls.Label lblUrl;
		protected System.Web.UI.WebControls.Label lblNda;
		protected System.Web.UI.WebControls.Label lblTargetAudience;
		protected System.Web.UI.WebControls.Label lblKeyFeatures;
		protected System.Web.UI.WebControls.Label lblPrice;
		protected System.Web.UI.WebControls.Label lblCustomerReferences;
		protected System.Web.UI.WebControls.Label lblCompetitors;
		protected System.Web.UI.WebControls.Label lblBusinessProblem;
		protected System.Web.UI.WebControls.Label lblDescription;
		protected System.Web.UI.WebControls.HyperLink hlTopEdit;
		protected System.Web.UI.WebControls.HyperLink hlBottomEdit;

		private void Page_Load(object sender, System.EventArgs e)
		{
			string userId = CleanString.SqlText(Context.User.Identity.Name, 10);
			string productId = String.Empty;

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
				hlTopEdit.NavigateUrl = "EntryCreateEdit.aspx?" + Global.ProductId + "=" + productId;
				hlBottomEdit.NavigateUrl = "EntryCreateEdit.aspx?" + Global.ProductId + "=" + productId;

				//verify the product id
				if (ProductInfo.IsUserProduct(userId, productId))
				{
					//get the product info
					DataSet dsProductInfo = ProductInfo.GetProductInfo(productId);

					if (dsProductInfo.Tables[0].Rows.Count == 1)
					{
						DataRow dr = dsProductInfo.Tables[0].Rows[0];

						CleanString.SetLabel(lblCompanyName, dr["COMPANYNAME"]);
						CleanString.SetLabel(lblProductName, dr["PRODUCTNAME"]);
						CleanString.SetLabel(lblVersion, dr["VERSION"]);
						CleanString.SetLabel(lblAnnouncementDate, dr["ANNOUNCEMENTDATE"]);
						CleanString.SetLabel(lblShipDate, dr["SHIPDATE"]);
						CleanString.SetLabel(lblUrl, dr["URL"]);
						CleanString.SetLabel(lblNda, dr["NDA"]);
						CleanString.SetLabel(lblTargetAudience, dr["TARGETAUDIENCE"]);
						CleanString.SetLabel(lblKeyFeatures, dr["KEYFEATURES"]);
						CleanString.SetLabel(lblPrice, dr["PRICE"]);
						CleanString.SetLabel(lblCustomerReferences, dr["CUSTOMERREFERENCES"]);
						CleanString.SetLabel(lblCompetitors, dr["COMPETITORS"]);
						CleanString.SetLabel(lblBusinessProblem, dr["BUSINESSPROBLEM"]);
						CleanString.SetLabel(lblDescription, dr["DESCRIPTION"]);
					}
				}
				else
				{
					//something not right, user is cheating
					//set msg and redirect
					Session.Add(Global.Session_PageMessage, PageMessage.Product_NotAuthorized);
					Response.Redirect(UrlHelper.CreatePath(Context, "Default.aspx"));
					return;
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
			this.Load += new System.EventHandler(this.Page_Load);
		}
		#endregion
	}
}
