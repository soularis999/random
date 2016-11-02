using System;
using System.Configuration;

namespace OpenHack
{
	/// <summary>
	/// Summary description for Default.
	/// </summary>
	public class Default : System.Web.UI.Page
	{
		protected System.Web.UI.WebControls.HyperLink hlEditCompany2;
		protected System.Web.UI.WebControls.HyperLink hlAddNewCompany2;
		protected System.Web.UI.WebControls.HyperLink hlEditAccountDetails;
		protected System.Web.UI.WebControls.HyperLink hlCreateAccount;
		protected System.Web.UI.WebControls.HyperLink hlLogout;
		protected System.Web.UI.WebControls.HyperLink hlLogin;
		protected System.Web.UI.WebControls.HyperLink hlChangePassword;
		protected System.Web.UI.WebControls.HyperLink hlForgotPassword;
		protected System.Web.UI.WebControls.HyperLink hlAddNewEntry;
		protected System.Web.UI.WebControls.HyperLink hlRegisterCompany;
		protected System.Web.UI.WebControls.HyperLink hlEditEntries;
		protected System.Web.UI.WebControls.HyperLink hlViewEntries;
		protected System.Web.UI.WebControls.Label lblStep1;
		protected System.Web.UI.WebControls.Label lblStep1or;
		protected System.Web.UI.WebControls.Label lblStep2;
		protected System.Web.UI.WebControls.Label lblStep3;
		protected System.Web.UI.WebControls.Label lblContestHeader;
		protected System.Web.UI.WebControls.Table tblTopMenu;
	
		private void Page_Load(object sender, System.EventArgs e)
		{
			string dirtyUserId = Context.User.Identity.Name;
			string htmlEncUserId = CleanString.HtmlEncode(dirtyUserId);
			int numCompaniesRegistered = 0;
			int numEntries = 0;
			bool pastEntryDeadline = false;

			//expire the page
			Response.Expires = -1;

			// determine if entry deadline has passed
			//and set the header top
			if (DateTime.Now > DateTime.Parse(ConfigHelper.GetConfig(Global.ContestEndDate)))
			{
				pastEntryDeadline = true;

				lblContestHeader.Text = "eWEEK Openhack 4 has finished.";
			}
			else
			{
				lblContestHeader.Text = "eWEEK Openhack 4 is currently in progress.";
			}

			//hide all links and show them programmatically with logic
			//logged-in related links
			hlEditAccountDetails.Visible = false;
			hlLogout.Visible = false;
			hlChangePassword.Visible = false;
			hlEditCompany2.Visible = false;
			hlAddNewCompany2.Visible = false;
			hlAddNewEntry.Visible = false;
			hlRegisterCompany.Visible = false;
			hlEditEntries.Visible = false;
			hlViewEntries.Visible = false;
			//logged-out related links
			hlCreateAccount.Visible = false;
			hlLogin.Visible = false;
			hlForgotPassword.Visible = false;

			//bottom menu
			if (!Context.User.Identity.IsAuthenticated)
			{
				//unknown user

				//top table menu
				tblTopMenu.Rows[4].Visible = false;
				tblTopMenu.Rows[5].Visible = false;
				tblTopMenu.Rows[6].Visible = false;
				tblTopMenu.Rows[8].Cells[0].Text = "Not logged in.";
				//end top tablemenu

				if (!pastEntryDeadline)
				{
					lblStep1.Text = "Step 1 of 3:";
				}

				hlCreateAccount.Visible = true;
				hlCreateAccount.NavigateUrl = "accountcreateedit.aspx";
				lblStep1or.Text = "or";
				hlLogin.Visible = true;
				hlLogin.NavigateUrl = "login.aspx";

				hlForgotPassword.Visible = true;
				hlForgotPassword.NavigateUrl = Request.ApplicationPath + "accountdetailsmail.aspx";
			}
			else
			{
				//get the user info from the db
				numCompaniesRegistered = CompanyInfo.GetNumCompaniesRegistered(CleanString.SqlText(dirtyUserId, 10));
				numEntries = ProductInfo.GetNumEntriesSubmitted(CleanString.SqlText(dirtyUserId, 10));

				//top table menu
				if (numCompaniesRegistered == 0)
					tblTopMenu.Rows[5].Cells[1].Text = "Not paid";
				else
					tblTopMenu.Rows[5].Cells[1].Text = "Paid";

				tblTopMenu.Rows[6].Cells[1].Text = numEntries.ToString();

				// SECREVIEW: output text is username (input) and hardcoded
				// username is HtmlEncoded
				tblTopMenu.Rows[8].Cells[0].Text = htmlEncUserId + " is logged in.";	

				//end top table menu


				//person is logged in
				if (!pastEntryDeadline)
				{					
					if (numCompaniesRegistered == 0)
					{
						lblStep2.Text = "Step 2 of 3:";
						hlRegisterCompany.Visible = true;
						hlRegisterCompany.NavigateUrl = "secure/companycreateedit.aspx";

					}
					else if (numCompaniesRegistered == 1)
					{
						lblStep3.Text = "Step 3 of 3:";
						hlAddNewEntry.Visible = true;
						hlAddNewEntry.NavigateUrl = "secure/entrycreateedit.aspx";
					}
					else
					{
						lblStep3.Text = "Step 3 of 3:";
						hlAddNewEntry.Visible = true;
						hlAddNewEntry.NavigateUrl = "secure/companylist.aspx";
					}

					if (numEntries > 0)
					{
						hlEditEntries.Visible = true;
						hlEditEntries.NavigateUrl = "secure/entrylist.aspx";
					}
				}
				else
				{
					if (numEntries > 0)
					{
						hlViewEntries.Visible = true;
						hlViewEntries.NavigateUrl = "secure/entrylist.aspx";
					}
				}

				hlEditAccountDetails.Visible = true;
				hlEditAccountDetails.NavigateUrl = "accountcreateedit.aspx";

				hlLogout.Visible = true;
				hlLogout.NavigateUrl = "logout.aspx";

				hlChangePassword.Visible = true;
				hlChangePassword.NavigateUrl = "secure/passwordchange.aspx";

				if (numCompaniesRegistered > 0)
				{
					if (numCompaniesRegistered == 1)
					{
						hlEditCompany2.Visible = true;
						hlEditCompany2.NavigateUrl = "secure/companycreateedit.aspx";
					}
					else
					{
						hlEditCompany2.Visible = true;
						hlEditCompany2.NavigateUrl = "secure/companylist.aspx";
					}

					if (!pastEntryDeadline)
					{
						hlAddNewCompany2.Visible = true;
						hlAddNewCompany2.NavigateUrl = "secure/companycreateedit.aspx?hfCompanyId=new";
					}
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
