using System;

namespace OpenHack
{
	using System.Text;

	/// <summary>
	///		Summary description for Header.
	/// </summary>
	public abstract class Header : System.Web.UI.UserControl
	{
		protected System.Web.UI.WebControls.HyperLink hlHome;
		protected System.Web.UI.WebControls.HyperLink hlOverview;
		protected System.Web.UI.WebControls.HyperLink hlInstructions;
		protected System.Web.UI.WebControls.HyperLink hlRules;
		protected System.Web.UI.WebControls.HyperLink hlFaq;
		protected System.Web.UI.WebControls.HyperLink hlNews;


		private void Page_Load(object sender, System.EventArgs e)
		{
			hlHome.NavigateUrl = UrlHelper.CreatePath(Context, "Default.aspx");
			hlOverview.NavigateUrl = UrlHelper.CreatePath(Context, "Overview.aspx");
			hlInstructions.NavigateUrl = UrlHelper.CreatePath(Context, "Instructions.aspx");
			hlRules.NavigateUrl = UrlHelper.CreatePath(Context, "Rules.aspx");
			hlFaq.NavigateUrl = UrlHelper.CreatePath(Context, "Faq.aspx");
			hlNews.NavigateUrl = UrlHelper.CreatePath(Context, "News.aspx");
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
