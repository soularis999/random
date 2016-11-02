using System;

namespace OpenHack
{
	/// <summary>
	/// Summary description for entryformsample.
	/// </summary>
	public class EntryFormSample : System.Web.UI.Page
	{
		protected System.Web.UI.HtmlControls.HtmlGenericControl divHeaderUserUnknown;
		protected System.Web.UI.HtmlControls.HtmlGenericControl divHeaderUserKnownWithPastCompany;
		protected System.Web.UI.HtmlControls.HtmlGenericControl divHeaderUserKnownNoPastCompany;

		private void Page_Load(object sender, System.EventArgs e)
		{
			string userId = CleanString.SqlText(Context.User.Identity.Name, 10);

            //dynamic content
			if(Context.User.Identity.IsAuthenticated)
			{
				divHeaderUserUnknown.Visible = false;

				//check if user has registered a company before
				if (CompanyInfo.GetNumCompaniesRegistered(CleanString.SqlText(userId, 10)) > 0)
					divHeaderUserKnownNoPastCompany.Visible = false;
				else
					divHeaderUserKnownWithPastCompany.Visible = false;
			}
			else
			{
				divHeaderUserKnownNoPastCompany.Visible = false;
				divHeaderUserKnownWithPastCompany.Visible = false;
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
