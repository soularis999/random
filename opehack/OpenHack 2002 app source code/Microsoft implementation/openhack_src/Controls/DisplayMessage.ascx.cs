using System;

namespace OpenHack
{
	public enum PageMessage
	{
		Logged_Out,
		Logged_In,
		Account_Updated,
		Account_Created,
		Password_Updated,
		Lost_Password_Mailed,
		Company_Created,
		Company_Updated,
		Company_NotAuthorized,
		Company_DeadLinePassed,
		Product_NotAuthorized,
		Product_DeadLinePassed,
		Product_Updated,
		Product_Deleted,
		Product_ActionCancelled,
		Product_ParamMissing,
		Session_Timeout
	}

	/// <summary>
	///		Summary description for displaymessage.
	/// </summary>
	public abstract class DisplayMessage : System.Web.UI.UserControl
	{
		protected System.Web.UI.WebControls.Label Message;

		private void Page_Load(object sender, System.EventArgs e)
		{
			//check for a message to display
			if (Session[Global.Session_PageMessage] != null)
			{
				//display and remove msg
				Message.Text = GetMessageText((PageMessage) Session[Global.Session_PageMessage]);

				if (((PageMessage) Session[Global.Session_PageMessage]) == PageMessage.Logged_Out)
					Session.Clear();
				else
					Session.Remove(Global.Session_PageMessage);
			}
		}

		private string GetMessageText(PageMessage pm)
		{
			switch(pm)
			{
				case PageMessage.Logged_Out:
					return "You are logged out.";
				case PageMessage.Logged_In:
					return "Log in successful.";
				case PageMessage.Account_Updated:
					return "User account details have been updated.";
				case PageMessage.Account_Created:
					return "Your user account has been created and you have been sent a confirmation e-mail with your account details. Please read the following few pages of information to get started.";
				case PageMessage.Password_Updated:
					return "Your password has been changed.";
				case PageMessage.Lost_Password_Mailed:
					return "Your account details have been mailed to you.";
				case PageMessage.Company_Created:
					return "Thank you for your company registration and payment! A confirmation e-mail has been sent to your e-mail address. You may now proceed to step 3, submitting a new entry for judging. You must still complete this last step before the entry deadline to be in the competition.";
				case PageMessage.Company_Updated:
					return "Company and/or payment details have been updated.";
				case PageMessage.Company_NotAuthorized:
					return "Company not found or not registered by you. Please contact eWEEK for assistance.";
				case PageMessage.Company_DeadLinePassed:
					return "We're sorry, the deadline for new company registrations for the eWEEK eXcellence Awards program has passed. Thank you for you interest, and we invite you to participate next year.";
				case PageMessage.Product_NotAuthorized:					
					return "Product not found or not registered by you. Please contact eWEEK for assistance.";
				case PageMessage.Product_DeadLinePassed:
					return "We're sorry, the deadline for new submissions or submission changes for the eWEEK eXcellence Awards program has passed. Thank you for you interest, and we invite you to participate next year.";
				case PageMessage.Product_Updated:
					return "Your entry has been updated.";
				case PageMessage.Product_Deleted:
					return "Entry deleted.";
				case PageMessage.Product_ActionCancelled:
					return "Action cancelled.";
				case PageMessage.Product_ParamMissing:
					return "Required parameter missing. Please contact eWEEK for assistance.";
				case PageMessage.Session_Timeout:
					return "Your login session has timed out. Please log in again.";
				default:
					return String.Empty;
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
