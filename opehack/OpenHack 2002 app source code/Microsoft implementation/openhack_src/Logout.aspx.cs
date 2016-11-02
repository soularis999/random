using System;
using System.Web.Security;

namespace OpenHack
{
	/// <summary>
	/// Summary description for logout.
	/// </summary>
	public class Logout : System.Web.UI.Page
	{
		private void Page_Load(object sender, System.EventArgs e)
		{
			// logout user and redirect with msg
			FormsAuthentication.SignOut();
			Session.Add(Global.Session_PageMessage, PageMessage.Logged_Out);
			Response.Redirect("Default.aspx");
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
