using System;

namespace OpenHack
{
	/// <summary>
	///		Summary description for Footer.
	/// </summary>
	public abstract class Footer : System.Web.UI.UserControl
	{
		protected System.Web.UI.WebControls.HyperLink hlContactInfo;

		private void Page_Load(object sender, System.EventArgs e)
		{		
			hlContactInfo.NavigateUrl = UrlHelper.CreatePath(Context, "eWeekContacts.aspx");
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
		
		///		Required method for Designer support - do not modify
		///		the contents of this method with the code editor.
		/// </summary>
		private void InitializeComponent()
		{
			this.Load += new System.EventHandler(this.Page_Load);

		}
		#endregion
	}
}
