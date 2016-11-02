namespace OpenHack.Controls
{
	using System;
	using System.Data;
	using System.Drawing;
	using System.Web;
	using System.Web.Security;
	using System.Web.UI.WebControls;
	using System.Web.UI.HtmlControls;

	/// <summary>
	///		Summary description for UserBanner.
	/// </summary>
	public abstract class UserBanner : System.Web.UI.UserControl
	{
		protected System.Web.UI.WebControls.Label UserLabel;
		protected System.Web.UI.WebControls.Label IdLabel;


		private void Page_Load(object sender, System.EventArgs e)
		{
			// stuff containing this may not output cache since it has the
			// risk of getting the wrong presentation for a given uers
			Response.Cache.SetCacheability(HttpCacheability.NoCache);
			
			// hide by default
			this.Visible = false;

			if(Request.IsAuthenticated) 
			{
				FormsIdentity id = Context.User.Identity as FormsIdentity;
				if( null != id ) 
				{
					this.Visible = true;

					string userId = Context.User.Identity.Name;
					string userName = id.Ticket.UserData;

					CleanString.SetLabel(IdLabel, userId);
					// if someone has an old (but still valid) ticket from an earlier
					// version of this app, do the DB lookup
					if( userName == null || userName == String.Empty ) 
					{
						userId = CleanString.SqlText(userId, 10);
						DataSet ds = UserInfo.GetUserInfo(userId);
						// we don't need to encode since it's encrypted and encoded
						// however we do need to encode whenever echoing back
						userName = String.Empty;
						if (ds.Tables[0].Rows.Count == 1)
						{
							//pre-fill the page with data
							DataRow dr = ds.Tables[0].Rows[0];
							userName = dr["USERNAME"].ToString();
						}
						if( userName != null && userName != String.Empty ) 
						{
							CleanString.SetLabel(UserLabel, userName);
						}

					}
					// good, we have a username, use it
					else 
					{
						CleanString.SetLabel(UserLabel, id.Ticket.UserData);
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
