using System;
using System.Data;
using System.Web.Mail;
using System.Configuration;
using System.Text;

namespace OpenHack
{
	/// <summary>
	/// Summary description for accountdetailsmail.
	/// </summary>
	public class AccountDetailsMail : System.Web.UI.Page
	{
		protected System.Web.UI.WebControls.TextBox txtEmail;
		protected System.Web.UI.WebControls.RequiredFieldValidator rfvEmail;
		protected System.Web.UI.WebControls.RegularExpressionValidator revEmail;
		protected System.Web.UI.WebControls.Button btnSubmit;
		protected System.Web.UI.WebControls.Label lblMessage;
	
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

			string userEmail = CleanString.SqlText(txtEmail.Text, 50);

			//get user info
			DataSet ds = UserInfo.GetUserLostPassword(userEmail);

			//check for valid row
			if (ds.Tables[0].Rows.Count == 1)
			{
				DataRow dr = ds.Tables[0].Rows[0];

				string passwd = CryptUtil.DecryptString(dr["PASSWORD"].ToString(), false);
				StringBuilder messageText = new StringBuilder();
				messageText.AppendFormat("Dear {0}, \n\n" +
					"You requested the following eWEEK eXcellence Awards site account details associated with the e-mail address {1}.\n\n" +
					"You can now log into the site using the following information:\n\n" +
					"User ID: {2}\n" +
					"Password: {3}\n\n" +
					"Regards,\n" +
					"eWEEK\n" +
					"http://www.excellenceawardsonline.com",
					Server.HtmlEncode(dr["USERNAME"].ToString()),
					Server.HtmlEncode(userEmail),
					Server.HtmlEncode(dr["USERID"].ToString()),
					Server.HtmlEncode(passwd));

				//create email
				MailMessage mm = new MailMessage();
				mm.Body = messageText.ToString();
				mm.To = userEmail;
				mm.From = ConfigurationSettings.AppSettings[Global.EmailFrom];
				mm.Headers.Add("Reply-To", mm.From);
				mm.Subject = "requested eWEEK eXcellence Awards site account details";

				try
				{
					SmtpHelper.SendMail(mm);
						
					//set msg and redirect
					Session.Add(Global.Session_PageMessage,PageMessage.Lost_Password_Mailed);
					Response.Redirect("Default.aspx");
				}
				catch
				{
					//mail failed
					lblMessage.Text = "We could not send an email at this time. Please try again or contact us for assistance.";
				}
			}
			else
			{
				//email not found
				lblMessage.Text = "We do not have that e-mail address in our database. Please try again or contact us for assistance.";
			}		
		}
	}
}
