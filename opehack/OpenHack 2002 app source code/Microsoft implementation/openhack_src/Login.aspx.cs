using System;
using System.Web;
using System.Web.Security;
using System.Data;

namespace OpenHack
{
	/// <summary>
	/// Summary description for login.
	/// </summary>
	public class Login : System.Web.UI.Page
	{
		protected System.Web.UI.WebControls.TextBox txtUserId;
		protected System.Web.UI.WebControls.TextBox txtPassword;
		protected System.Web.UI.WebControls.RequiredFieldValidator rfvUserId;
		protected System.Web.UI.WebControls.RequiredFieldValidator rfvPassword;
		protected System.Web.UI.WebControls.RegularExpressionValidator revUserId;
		protected System.Web.UI.WebControls.RegularExpressionValidator revPassword;
		protected System.Web.UI.WebControls.Label lblMessage;
		protected System.Web.UI.WebControls.Button btnSubmit;
	
		private void Page_Load(object sender, System.EventArgs e)
		{
			// Put user code to initialize the page here			
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
			this.btnSubmit.Click += new System.EventHandler(this.btnSubmit_Click);
			this.Load += new System.EventHandler(this.Page_Load);

		}
		#endregion

		private void btnSubmit_Click(object sender, System.EventArgs e)
		{
			if (!Page.IsValid)
				return;

			// SECREVIEW: input strings for credentials
			string userId = CleanString.SqlText(txtUserId.Text, 10);
			string password = CleanString.SqlText(txtPassword.Text, 16);

			//check the password
			if (UserInfo.CheckPassword(userId, password))
			{
				// password checks out, fetch username for cookie
				// for authentication banner
				DataSet ds = UserInfo.GetUserInfo(userId);
				// we don't need to encode since it's encrypted and encoded
				// however we do need to encode whenever echoing back
				string userName = String.Empty;
				if (ds.Tables[0].Rows.Count == 1)
				{
					//pre-fill the page with data
					DataRow dr = ds.Tables[0].Rows[0];
					userName = dr["USERNAME"].ToString();
				}

				//set auth cookie
				//FormsAuthentication.SetAuthCookie(userId, false);
				HttpCookie ck = UserInfo.CreateTicket(userId, userName);
				if( null != ck ) 
				{
					MgmtEvent.IncrementCounter(MgmtEvent.Logons);
						
					//set msg and redirect
					Response.Cookies.Add(ck);
					Session.Add(Global.Session_PageMessage, PageMessage.Logged_In);
					Response.Redirect("Default.aspx");
				}
				else 
				{
					//unexpected error
					lblMessage.Text = "The user ID or password was incorrect. Please try again.";
					MgmtEvent.IncrementCounter(MgmtEvent.LogonFailures);
				}
			}
			else
			{
				//invalid userid-password combo
				lblMessage.Text = "The user ID or password was incorrect. Please try again.";
				MgmtEvent.IncrementCounter(MgmtEvent.LogonFailures);
			}
		}
	}
}
