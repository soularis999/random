using System;

namespace OpenHack
{
	/// <summary>
	/// Summary description for passwordchange.
	/// </summary>
	public class PasswordChange : System.Web.UI.Page
	{
		protected System.Web.UI.WebControls.TextBox txtCurrentPassword;
		protected System.Web.UI.WebControls.TextBox txtNewPassword1;
		protected System.Web.UI.WebControls.TextBox txtNewPassword2;
		protected System.Web.UI.WebControls.Label lblMessage;
		protected System.Web.UI.WebControls.RequiredFieldValidator rfvCurrentPassword;
		protected System.Web.UI.WebControls.RegularExpressionValidator revCurrentPassword;
		protected System.Web.UI.WebControls.RequiredFieldValidator rfvNewPassword1;
		protected System.Web.UI.WebControls.RegularExpressionValidator revNewPassword1;
		protected System.Web.UI.WebControls.RequiredFieldValidator rfvNewPassword2;
		protected System.Web.UI.WebControls.CompareValidator cvNewPassword2;
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

			string userId = CleanString.SqlText(Context.User.Identity.Name, 10);
			string password = CleanString.SqlText(txtCurrentPassword.Text, 16);
			string newPassword = CleanString.SqlText(txtNewPassword1.Text, 16);

			//check the password
			if (UserInfo.CheckPassword(userId, password))
			{
				//change the password
				UserInfo.UpdatePassword(userId, password, newPassword);				

				//set msg and redirect
				Session.Add(Global.Session_PageMessage,PageMessage.Password_Updated);
				Response.Redirect(UrlHelper.CreatePath(Context, "Default.aspx"));
			}
			else
			{
				//password not found or something wrong
                lblMessage.Text = "The current password was not correct. Please try again or contact us for assistance.";
			}		
		}
	}
}
