using System;
using System.Data;
using System.Web.Security;
using System.Web;
using System.Web.Mail;
using System.Configuration;
using System.Text;

namespace OpenHack
{
	/// <summary>
	/// Summary description for accountcreateedit.
	/// </summary>
	public class AccountCreateEdit : System.Web.UI.Page
	{
		protected System.Web.UI.HtmlControls.HtmlGenericControl divHeaderNew;
		protected System.Web.UI.HtmlControls.HtmlGenericControl divHeaderEdit;
		protected System.Web.UI.HtmlControls.HtmlGenericControl spanFormNew;
		protected System.Web.UI.HtmlControls.HtmlGenericControl spanFormEdit;
		protected System.Web.UI.HtmlControls.HtmlGenericControl spanPasswordNew;
		protected System.Web.UI.HtmlControls.HtmlGenericControl spanPasswordEdit;
		protected System.Web.UI.WebControls.TextBox txtUserId;
		protected System.Web.UI.WebControls.TextBox txtPassword;
		protected System.Web.UI.WebControls.TextBox txtPassword2;
		protected System.Web.UI.WebControls.TextBox txtUserName;
		protected System.Web.UI.WebControls.TextBox txtTitle;
		protected System.Web.UI.WebControls.TextBox txtCompanyName;
		protected System.Web.UI.WebControls.TextBox txtUserPhone;
		protected System.Web.UI.WebControls.TextBox txtEmail;
		protected System.Web.UI.WebControls.Button btnSubmit;
		protected System.Web.UI.WebControls.RadioButtonList rblContact;
		protected System.Web.UI.WebControls.RequiredFieldValidator rfvUserId;
		protected System.Web.UI.WebControls.RegularExpressionValidator revUserId;
		protected System.Web.UI.WebControls.RequiredFieldValidator rfvUserName;
		protected System.Web.UI.WebControls.RegularExpressionValidator revUserName;
		protected System.Web.UI.WebControls.RequiredFieldValidator rfvPassword;
		protected System.Web.UI.WebControls.RegularExpressionValidator revPassword;
		protected System.Web.UI.WebControls.RequiredFieldValidator rfvPassword2;
		protected System.Web.UI.WebControls.CompareValidator cvPassword2;
		protected System.Web.UI.WebControls.RegularExpressionValidator revTitle;
		protected System.Web.UI.WebControls.RequiredFieldValidator rfvCompanyName;
		protected System.Web.UI.WebControls.RegularExpressionValidator revCompanyName;
		protected System.Web.UI.WebControls.RequiredFieldValidator rfvUserPhone;
		protected System.Web.UI.WebControls.RegularExpressionValidator revUserPhone;
		protected System.Web.UI.WebControls.RegularExpressionValidator revEmail;
		protected System.Web.UI.WebControls.RequiredFieldValidator rfvEmail;		
		protected System.Web.UI.WebControls.Label lblMessage;

		private void Page_Load(object sender, System.EventArgs e)
		{
			if (!Page.IsPostBack)
			{
				string userId = CleanString.SqlText(Context.User.Identity.Name, 10);

				if (Context.User.Identity.IsAuthenticated)
				{
					//disable span tags for new users
					divHeaderNew.Visible = false;
					spanFormNew.Visible = false;
					spanPasswordNew.Visible = false;

					//disable form elements for new users
					txtUserId.ReadOnly = true;
					txtPassword.Visible = false;
					txtPassword2.Visible = false;
					rfvPassword.Enabled = false;
					rfvPassword2.Enabled = false;
					revPassword.Enabled = false;
					cvPassword2.Enabled = false;

					//get user info
					DataSet ds = UserInfo.GetUserInfo(userId);

					//check for valid row
					if (ds.Tables[0].Rows.Count == 1)
					{
						//pre-fill the page with data
						DataRow dr = ds.Tables[0].Rows[0];

						// SECREVIEW: data from database to outside
						// must be validated and encoded
						// text boxes are attribute encoded and are OK
						txtUserId.Text = userId;
						txtUserName.Text = dr["USERNAME"].ToString();
						txtTitle.Text = dr["TITLE"].ToString();
						txtCompanyName.Text = dr["COMPANYNAME"].ToString();
						txtUserPhone.Text = dr["PHONE"].ToString();
						txtEmail.Text = dr["EMAIL"].ToString();
						txtUserId.Text = userId;

						if(dr["NOTIFYNEXTYEAR"].ToString() == "N")
							rblContact.SelectedIndex = 1;
					}
					else
					{
						//user not found or multiple rows for some reason--something strange is going on
						FormsAuthentication.SignOut();
						UrlHelper.DefaultRedirect(Context);
					}              
				}
				else
				{
					//new user
					//disable edit span tags
					divHeaderEdit.Visible = false;
					spanFormEdit.Visible = false;
					spanPasswordEdit.Visible = false;
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
			this.btnSubmit.Click += new System.EventHandler(this.btnSubmit_Click);
			this.Load += new System.EventHandler(this.Page_Load);

		}
		#endregion

		private void btnSubmit_Click(object sender, System.EventArgs e)
		{
			if (!Page.IsValid)
				return;

			string userId = CleanString.SqlText(Context.User.Identity.Name, 10);
			string userPassword = CleanString.SqlText(txtPassword.Text, 16);
			string userEmail = CleanString.SqlText(txtEmail.Text, 50);
			string userName = CleanString.SqlText(txtUserName.Text, 30);
			string userTitle = CleanString.SqlText(txtTitle.Text, 50);
			string companyName = CleanString.SqlText(txtCompanyName.Text, 50);
			string userPhone = CleanString.SqlText(txtUserPhone.Text, 20);
			string notifyNextyear = CleanString.SqlText(rblContact.SelectedItem.Value.ToUpper(), 1);

			//if the user is logged in then update account
			if (Context.User.Identity.IsAuthenticated)
			{
                //check for dup email
				if (UserInfo.IsEmailTaken(userId, userEmail))
				{
					//unique key error
					lblMessage.Text = "Email address is already registered.";
					return;
				}

				//update account
				UserInfo.UpdateUserInfo(userId, userName, userTitle, companyName, userPhone, userEmail, notifyNextyear);

				// we now need to also update the authentication ticket with a new name potentially
				FormsIdentity id = Context.User.Identity as FormsIdentity;
				if( null != id ) 
				{
					// if not a direct match, update ticket
					// this will also refresh the ticket with a new expiration, which is OK
					if(userName != id.Ticket.UserData ) 
					{
						HttpCookie ck = UserInfo.CreateTicket(userId, userName);
						if( null != ck )
							Response.Cookies.Add(ck);
					}
				}

				//set msg and redirect
				Session.Add(Global.Session_PageMessage,PageMessage.Account_Updated);
				UrlHelper.DefaultRedirect(Context);
			}
			else
			{
				//this is a new user
				userId = CleanString.SqlText(txtUserId.Text, 10);

				//check dup user id
				if (UserInfo.IsUserIdTaken(userId))
				{
					//primary key error
					lblMessage.Text = "User ID is already registered.";
					return;
				}

				//check for dup email
				if (UserInfo.IsEmailTaken(userId, userEmail))
				{
					//unique key error
					lblMessage.Text = "Email address is already registered.";
					return;
				}

				//create user account
				UserInfo.AddNewUser(userId, userPassword, userName, userTitle, companyName, userPhone, userEmail, notifyNextyear);


				StringBuilder messageText = new StringBuilder();
				// SECREVIEW: input data (SQL scrubbed) used for
				// email message details
				messageText.AppendFormat("Dear {0}, \n\n" +
					"Your account in eWEEK's eXcellence Awards program has been created.\n\n" +
					"Here are your account details for your reference:\n\n" +
					"User ID: {1}\n" +
					"Password: {2}\n\n",
					Server.HtmlEncode(userName),
					Server.HtmlEncode(userId),
					Server.HtmlEncode(userPassword));

				// determine if entry deadline has passed
				if (DateTime.Now > DateTime.Parse(ConfigHelper.GetConfig(Global.ContestEndDate)))
				{
					messageText.Append("We are not yet accepting entries for 2002 but if you chose " +
						"the \"notification e-mail\" option, we will send you an e-mail message when " +
						"we do start accepting entries.\n\n");
				}
				else 
				{
					messageText.Append("The next step is to register company details for the firm " +
						"creating the product or service eWEEK will be judging. Please log onto the " +
						"eXcellence Awards site and then choose the \"Step 2 of 3: Register a " +
						"company\" option.\n\n");
				}

				messageText.Append("Regards,\n" +
					"eWEEK\n" +
					"http://www.excellenceawardsonline.com\n");

				//create email
				MailMessage mm = new MailMessage();					
				mm.Body = messageText.ToString();
				mm.To = userEmail;
				mm.From = ConfigHelper.GetConfig(Global.EmailFrom);
				mm.Headers.Add("Reply-To", mm.From);
				mm.Subject = "eWEEK eXcellence Awards site account created";

				try
				{
					SmtpHelper.SendMail(mm);
				}
				catch
				{
					//mail failed, ignore
				}
				
				//set auth cookie
				//FormsAuthentication.SetAuthCookie(userId, false);
				HttpCookie ck = UserInfo.CreateTicket(userId, userName);
				if( null != ck ) 
				{
					Response.Cookies.Add(ck);	
					//set msg and redirect
					Session.Add(Global.Session_PageMessage,PageMessage.Account_Created);
					Response.Redirect("Overview.aspx", false);
				}
			}
		}
	}
}
