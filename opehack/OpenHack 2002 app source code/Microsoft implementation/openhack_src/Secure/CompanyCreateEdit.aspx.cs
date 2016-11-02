using System;
using System.Data;
using System.Configuration;
using System.Web.Mail;
using System.Text;

namespace OpenHack
{
	/// <summary>
	/// Summary description for companycreateedit.
	/// </summary>
	public class CompanyCreateEdit : System.Web.UI.Page
	{
		string companyId = String.Empty;
		protected System.Web.UI.HtmlControls.HtmlGenericControl divPaidHeader;
		protected System.Web.UI.HtmlControls.HtmlGenericControl divNotPaidHeader;
		protected System.Web.UI.HtmlControls.HtmlGenericControl divNotPaidHeaderNoCompany;
		protected System.Web.UI.WebControls.TextBox txtCompanyName;
		protected System.Web.UI.WebControls.TextBox txtAddress1;
		protected System.Web.UI.WebControls.TextBox txtAddress2;
		protected System.Web.UI.WebControls.TextBox txtCity;
		protected System.Web.UI.WebControls.TextBox txtZip;
		protected System.Web.UI.WebControls.TextBox txtCountry;
		protected System.Web.UI.WebControls.TextBox txtUrl;
		protected System.Web.UI.WebControls.TextBox txtCreditCard;
		protected System.Web.UI.WebControls.TextBox txtCreditCardExpiry;
		protected System.Web.UI.WebControls.TextBox txtBillingName;
		protected System.Web.UI.WebControls.TextBox txtBillingAddress1;
		protected System.Web.UI.WebControls.TextBox txtBillingAddress2;
		protected System.Web.UI.WebControls.TextBox txtBillingCity;
		protected System.Web.UI.WebControls.TextBox txtBillingZip;
		protected System.Web.UI.WebControls.TextBox txtBillingCountry;
		protected System.Web.UI.WebControls.TextBox txtBillingPhone;
		protected System.Web.UI.WebControls.Button btnSubmit;
		protected System.Web.UI.WebControls.RadioButtonList rblCheckPayment;
		protected System.Web.UI.WebControls.DropDownList ddlState;
		protected System.Web.UI.WebControls.DropDownList ddlBillingState;
		protected System.Web.UI.WebControls.DropDownList ddlCreditCardBrand;
		protected System.Web.UI.HtmlControls.HtmlGenericControl divNotPaidHeaderWithCompany;
		protected System.Web.UI.WebControls.RequiredFieldValidator rfvCreditCardBrand;
		protected System.Web.UI.WebControls.RequiredFieldValidator rfvCreditCard;
		protected System.Web.UI.WebControls.RegularExpressionValidator revCreditCard;
		protected System.Web.UI.WebControls.RequiredFieldValidator rfvCreditCardExpiry;
		protected System.Web.UI.WebControls.RequiredFieldValidator rfvBillingName;
		protected System.Web.UI.WebControls.RegularExpressionValidator revBillingName;
		protected System.Web.UI.WebControls.RequiredFieldValidator rfvBillingAddress1;
		protected System.Web.UI.WebControls.RegularExpressionValidator revBillingAddress1;
		protected System.Web.UI.WebControls.RegularExpressionValidator revBillingAddress2;
		protected System.Web.UI.WebControls.RequiredFieldValidator rfvBillingCity;
		protected System.Web.UI.WebControls.RegularExpressionValidator revBillingCity;
		protected System.Web.UI.WebControls.RegularExpressionValidator revBillingState;
		protected System.Web.UI.WebControls.RequiredFieldValidator rfvBillingZip;
		protected System.Web.UI.WebControls.RegularExpressionValidator revBillingZip;
		protected System.Web.UI.WebControls.RequiredFieldValidator rfvBillingCountry;
		protected System.Web.UI.WebControls.RegularExpressionValidator revBillingCountry;
		protected System.Web.UI.WebControls.RequiredFieldValidator rfvBillingPhone;
		protected System.Web.UI.WebControls.RegularExpressionValidator revBillingPhone;
		protected System.Web.UI.WebControls.RegularExpressionValidator revCreditCardExpiry;
		protected System.Web.UI.WebControls.RequiredFieldValidator rfvCompanyName;
		protected System.Web.UI.WebControls.RegularExpressionValidator revCompanyName;
		protected System.Web.UI.WebControls.RequiredFieldValidator rfvAddress1;
		protected System.Web.UI.WebControls.RegularExpressionValidator revAddress1;
		protected System.Web.UI.WebControls.RegularExpressionValidator revAddress2;
		protected System.Web.UI.WebControls.RequiredFieldValidator rfvCity;
		protected System.Web.UI.WebControls.RegularExpressionValidator revCity;
		protected System.Web.UI.WebControls.RegularExpressionValidator revState;
		protected System.Web.UI.WebControls.RequiredFieldValidator rfvZip;
		protected System.Web.UI.WebControls.RegularExpressionValidator revZip;
		protected System.Web.UI.WebControls.RequiredFieldValidator rfvCountry;
		protected System.Web.UI.WebControls.RegularExpressionValidator revCountry;
		protected System.Web.UI.WebControls.TextBox txtPhone;
		protected System.Web.UI.WebControls.RequiredFieldValidator rfvPhone;
		protected System.Web.UI.WebControls.RegularExpressionValidator revPhone;
		protected System.Web.UI.WebControls.TextBox txtFax;
		protected System.Web.UI.WebControls.RegularExpressionValidator revFax;
		protected System.Web.UI.WebControls.RequiredFieldValidator rfvUrl;
		protected System.Web.UI.WebControls.RegularExpressionValidator revUrl;		
		protected System.Web.UI.HtmlControls.HtmlInputHidden hfCompanyId;
		
		private void Page_Load(object sender, System.EventArgs e)
		{
			string userId = CleanString.SqlText(Context.User.Identity.Name, 10);
			bool paid = false;

			// determine if entry deadline has passed
			if (DateTime.Now > DateTime.Parse(ConfigurationSettings.AppSettings[Global.ContestEndDate]))
			{
				// set msg and redirect to home page
				Session.Add(Global.Session_PageMessage,PageMessage.Company_DeadLinePassed);
				Response.Redirect(UrlHelper.CreatePath(Context, "Default.aspx"));
				return;
			}

			// grab form & query values if they exist
			if (Request.Form[Global.CompanyId] != null)
				companyId = CleanString.SqlText(Request.Form.Get(Global.CompanyId), 10);
			else if (Request.QueryString[Global.CompanyId] != null)
				companyId = CleanString.SqlText(Request.QueryString.Get(Global.CompanyId), 10);

			if (companyId == String.Empty)
			{
				//get the the last company id
				DataSet dsUserCompanies = CompanyInfo.GetAllUserCompanies(userId);

				foreach (DataRow drRow in dsUserCompanies.Tables[0].Rows)
				{
					companyId = drRow["COMPANYID"].ToString();
					paid = true;
				}
			}
			else if (companyId != "new")
			{
				//verify the company id
				if (CompanyInfo.IsUserCompany(userId, companyId))
				{
					//user created this company
					paid = true;					
				}
				else
				{
					//nothing found user is cheating
					//set msg and redirect to home page
					Session.Add(Global.Session_PageMessage, PageMessage.Company_NotAuthorized);
					Response.Redirect(UrlHelper.CreatePath(Context, "Default.aspx"));
					return;	
				}
			}

			//if this is a new company submission and the user has never registered a company
			//use a little reverse logic to remove unwanted div messages
			if (!paid)
			{
				divPaidHeader.Visible = false;

				if (companyId == String.Empty)
				{			
					divNotPaidHeaderWithCompany.Visible = false;
				}
				else
				{
					divNotPaidHeaderNoCompany.Visible = false;
				}
			}
			else
			{
				//if it's not new than we verified companyid
				//and the user is allowed to edit it
				divNotPaidHeader.Visible = false;
				divNotPaidHeaderWithCompany.Visible = false;
				divNotPaidHeaderNoCompany.Visible = false;
			}

			//ok now that we have the companyid and know if the user is allowed to edit it
			//lets go through the main posting logic
            if (!Page.IsPostBack)
			{
				//first time page view
				
				//hide the companyid
				if (companyId == String.Empty)
					hfCompanyId.Value = "new";
				else
					hfCompanyId.Value = companyId;
				
				//get the states
				DataSet dsStates = StatesInfo.GetStates();

				//bind the states
				ddlState.DataSource = dsStates.Tables[0].DefaultView;
				ddlState.DataBind();

				ddlBillingState.DataSource = dsStates.Tables[0].DefaultView;
				ddlBillingState.DataBind();

				//get credit card brands
				DataSet dsCCB = CreditCardInfo.GetCreditCardBrands();

				//bind the cc brands
				ddlCreditCardBrand.DataSource = dsCCB.Tables[0].DefaultView;
				ddlCreditCardBrand.DataBind();

				//let's prefill the data if we have a verified companyid
				if ((companyId != "new") && (companyId != String.Empty))
				{
					//get the company info
					DataSet dsCompanyInfo = CompanyInfo.GetCompanyAndPaymentInfo(companyId);

					//if the company is found
					if (dsCompanyInfo.Tables[0].Rows.Count > 0)
					{
						DataRow dr = dsCompanyInfo.Tables[0].Rows[0];

						// decrypt credit card data
						// this can be NULL if one paid by check
						string ccRaw = String.Empty;
						string ccString = String.Empty;
						if( !dr.IsNull("CREDITCARD") ) {
							ccRaw = dr["CREDITCARD"].ToString();
							if( ccRaw != String.Empty )
								ccString = CryptUtil.DecryptString(ccRaw, true);
						}
						
						txtCompanyName.Text = dr["COMPANYNAME"].ToString();
						txtAddress1.Text = dr["ADDRESS1"].ToString();
						txtAddress2.Text = dr["ADDRESS2"].ToString();
						txtCity.Text = dr["CITY"].ToString();
						txtZip.Text = dr["ZIP"].ToString();
						txtCountry.Text = dr["COUNTRY"].ToString();
						txtPhone.Text = dr["PHONE"].ToString();
						txtFax.Text = dr["FAX"].ToString();
						txtUrl.Text = dr["URL"].ToString();
						txtCreditCard.Text = ccString;
						txtCreditCardExpiry.Text = dr["CREDITCARDEXPIRY"].ToString();
						txtBillingName.Text = dr["BILLINGNAME"].ToString();
						txtBillingAddress1.Text = dr["BILLINGADDRESS1"].ToString();
						txtBillingAddress2.Text = dr["BILLINGADDRESS2"].ToString();
						txtBillingCity.Text = dr["BILLINGCITY"].ToString();
						txtBillingZip.Text = dr["BILLINGZIP"].ToString();
						txtBillingCountry.Text = dr["BILLINGCOUNTRY"].ToString();
						txtBillingPhone.Text = dr["BILLINGPHONE"].ToString();
						
						//set the state
						for (int i=0; i<dsStates.Tables[0].Rows.Count; i++)
						{
							if (dsStates.Tables[0].Rows[i]["SHORTNAME"].ToString() == dr["STATE"].ToString())
							{
								ddlState.SelectedIndex = i;
								break;
							}
						}

						//set the billingstate
						for (int i=0; i<dsStates.Tables[0].Rows.Count; i++)
						{
							if (dsStates.Tables[0].Rows[i]["SHORTNAME"].ToString() == dr["BILLINGSTATE"].ToString())
							{
								ddlBillingState.SelectedIndex = i;
								break;
							}
						}

						//set the creditcard
						for (int i=0; i<dsCCB.Tables[0].Rows.Count; i++)
						{
							if (dsCCB.Tables[0].Rows[i]["SHORTNAME"].ToString() == dr["CREDITCARDBRAND"].ToString())
							{
								ddlCreditCardBrand.SelectedIndex = i;
								break;
							}
						}

						//set the payment form and check payment
						if (dr["CHECKPAYMENT"].ToString() == "Y")
						{
                            rblCheckPayment.SelectedIndex = 1;
							rblCheckPayment_SelectedIndexChanged(null, null);
						}
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
			this.rblCheckPayment.SelectedIndexChanged += new System.EventHandler(this.rblCheckPayment_SelectedIndexChanged);
			this.btnSubmit.Click += new System.EventHandler(this.btnSubmit_Click);
			this.Load += new System.EventHandler(this.Page_Load);

		}
		#endregion

		private void btnSubmit_Click(object sender, System.EventArgs e)
		{
			if (!Page.IsValid)
				return;

			//process post pack
			string userId = CleanString.SqlText(Context.User.Identity.Name, 10);
			string cleanUser = Server.HtmlEncode(userId);

			string companyName = CleanString.SqlText(txtCompanyName.Text, 100);
			string companyAddress1 = CleanString.SqlText(txtAddress1.Text, 50);
			string companyAddress2 = CleanString.SqlText(txtAddress2.Text, 50);
			string companyCity = CleanString.SqlText(txtCity.Text, 30);
			string companyState = CleanString.SqlText(ddlState.SelectedItem.Value, 2);
			string companyZip = CleanString.SqlText(txtZip.Text, 15);
			string companyCountry = CleanString.SqlText(txtCountry.Text, 30);
			string companyPhone = CleanString.SqlText(txtPhone.Text, 20);
			string companyFax = CleanString.SqlText(txtFax.Text, 20);
			string companyUrl = CleanString.SqlText(txtUrl.Text, 100);
			string creditCardBrand = CleanString.SqlText(ddlCreditCardBrand.SelectedItem.Value, 10);
			// length of creditCard in DB  has been updated for encryption, but validation should stay at 20
			string creditCard = CleanString.SqlText(txtCreditCard.Text, 20);
			string creditCardExpiry = CleanString.SqlText(txtCreditCardExpiry.Text, 10);
			string billingName = CleanString.SqlText(txtBillingName.Text, 30);
			string billingAddress1 = CleanString.SqlText(txtBillingAddress1.Text, 30);
			string billingAddress2 = CleanString.SqlText(txtBillingAddress2.Text, 30);
			string billingCity = CleanString.SqlText(txtBillingCity.Text, 30);
			string billingState = CleanString.SqlText(ddlBillingState.SelectedItem.Value, 2);
			string billingZip = CleanString.SqlText(txtBillingZip.Text, 15);
			string billingCountry = CleanString.SqlText(txtBillingCountry.Text, 50);
			string billingPhone = CleanString.SqlText(txtBillingPhone.Text, 20);
			string checkPayment = CleanString.SqlText(rblCheckPayment.SelectedItem.Value.ToUpper(), 1);

			//if this is a new new company then add it
			if (companyId == "new")
			{
				//add the new company and get the company id
				companyId = CompanyInfo.AddNewCompany(userId, companyName, companyAddress1, companyAddress2, companyCity, companyState, companyZip, companyCountry, companyPhone, companyFax, companyUrl);

				//add the payment information
				if (checkPayment == "N")
				{
					CompanyInfo.AddCreditPayment(companyId, creditCardBrand, creditCard, creditCardExpiry, billingName, billingAddress1, billingAddress2, billingCity, billingState, billingZip, billingCountry, billingPhone);                    
				}
				else
				{
					CompanyInfo.AddCheckPayment(companyId);
				}

				// send confirmation e-mail
				string cleanCompName = Server.HtmlEncode(txtCompanyName.Text);
				StringBuilder messageText = new StringBuilder();				
				messageText.Append("Dear " + cleanUser + ", \n\n");
				messageText.Append("Thank you for providing company details and payment information. You are now ");
				messageText.Append("able to submit products and/or services created by ");
				messageText.Append(cleanCompName + " for consideration in this award ");
				messageText.Append("program.\n\nPlease note we do NOT judge entire companies. ");
				messageText.Append("You must still submit actual products and services that we will judge. ");
				messageText.Append("This is \"Step 3 of 3: Submit a new entry\" on the site hoomepage.\n\n");
				messageText.Append("Company registration information you submitted:\n\n" + cleanCompName + "\n" + Server.HtmlEncode(txtAddress1.Text) + "\n");

				if (txtAddress2.Text != String.Empty) 
				{
					messageText.Append(Server.HtmlEncode(txtAddress2.Text) + "\n");
				}

				messageText.Append(Server.HtmlEncode(txtCity.Text) + ", " + Server.HtmlEncode(ddlState.SelectedItem.Value)
						    + ", " + Server.HtmlEncode(txtZip.Text) + "\n" +
					txtCountry.Text + "\n\n" + "Payment Information:\n\n");

				if (checkPayment == "N")
				{
					messageText.Append("You have chosen to pay by credit card. $100.00 will be charged in the next few weeks to your credit card number ending with the four numbers " + txtCreditCard.Text.Substring((txtCreditCard.Text.Length-4)) + ".\n");
				}
				else 
				{
					messageText.Append("You have chosen to pay by check. Please mail a check for $100.00 to:\n\n" +
						"	eWEEK\n" +
						"	10 President's Landing\n" +
						"	Medford, MA\n" +
						"	02155\n" +
						"	USA\n" +
						"	ATTN: eXcellence Awards\n\n" +
						"Please make the check payable to eWEEK.\n\n" +
						"We must receive the check by Dec. 31, 2001 or your entry will invalid.");
				}
				messageText.Append("\n" +
					"Regards,\n" +
					"eWEEK\n" +
					"http://www.excellenceawardsonline.com");

				//create email
				MailMessage mm = new MailMessage();					
				mm.Body = messageText.ToString();
				mm.To = UserInfo.GetUserEmail(userId);
				mm.From = ConfigurationSettings.AppSettings[Global.EmailFrom];
				mm.Headers.Add("Reply-To", mm.From);
				mm.Subject = "eWEEK eXcellence company registration and payment confirmation";

				try
				{
					SmtpHelper.SendMail(mm);
				}
				catch
				{
					//mail failed, ignore
				}

				//set msg and redirect
				Session.Add(Global.Session_PageMessage, PageMessage.Company_Created);
				Response.Redirect(UrlHelper.CreatePath(Context, "Default.aspx"));
			}
			else
			{
				//this is an update
				//the user did not trip bAuthorized so they may update this record 
				CompanyInfo.UpdateCompany(companyId, companyName, companyAddress1, companyAddress2, companyCity, companyState, companyZip, companyCountry, companyPhone, companyFax, companyUrl);

				//update the payment information
				if (checkPayment == "N")
				{
					CompanyInfo.UpdatePaymentAsCredit(companyId, creditCardBrand, creditCard, creditCardExpiry, billingName, billingAddress1, billingAddress2, billingCity, billingState, billingZip, billingCountry, billingPhone);                    
				}
				else
				{
					CompanyInfo.UpdatePaymentAsCheck(companyId);
				}

				//set msg and redirect
				Session.Add(Global.Session_PageMessage, PageMessage.Company_Updated);
				Response.Redirect(UrlHelper.CreatePath(Context, "Default.aspx"));
			}
		}

		private void rblCheckPayment_SelectedIndexChanged(object sender, System.EventArgs e)
		{			
			if (rblCheckPayment.SelectedItem.Value.ToLower() == "yes")
			{
				//disable the input fields
				ddlCreditCardBrand.Enabled = false;
				txtCreditCard.Enabled = false;
				txtCreditCardExpiry.Enabled = false;
				txtBillingName.Enabled = false;
				txtBillingAddress1.Enabled = false;
				txtBillingAddress2.Enabled = false;
				txtBillingCity.Enabled = false;
				ddlBillingState.Enabled = false;
				txtBillingZip.Enabled = false;
				txtBillingCountry.Enabled = false;
				txtBillingPhone.Enabled = false;

				//blank the textbox fields
				txtCreditCard.Text = String.Empty;
				txtCreditCardExpiry.Text = String.Empty;
				txtBillingName.Text = String.Empty;
				txtBillingAddress1.Text = String.Empty;
				txtBillingAddress2.Text = String.Empty;
				txtBillingCity.Text = String.Empty;
				txtBillingZip.Text = String.Empty;
				txtBillingCountry.Text = String.Empty;
				txtBillingPhone.Text = String.Empty;

				//disable the validators
				rfvCreditCardBrand.Enabled = false;
				rfvCreditCard.Enabled = false;
				revCreditCard.Enabled = false;
				rfvCreditCardExpiry.Enabled = false;
				revCreditCardExpiry.Enabled = false;
				revBillingName.Enabled = false;
				rfvBillingName.Enabled = false;
				revBillingAddress1.Enabled = false;
				rfvBillingAddress1.Enabled = false;
				revBillingAddress2.Enabled = false;
				revBillingCity.Enabled = false;
				rfvBillingCity.Enabled = false;
				revBillingState.Enabled = false;
				revBillingZip.Enabled = false;
				rfvBillingZip.Enabled = false;
				revBillingCountry.Enabled = false;
				rfvBillingCountry.Enabled = false;
				revBillingPhone.Enabled = false;
				rfvBillingPhone.Enabled = false;
			}
			else
			{
				ddlCreditCardBrand.Enabled = true;
				txtCreditCard.Enabled = true;
				txtCreditCardExpiry.Enabled = true;
				txtBillingName.Enabled = true;
				txtBillingAddress1.Enabled = true;
				txtBillingAddress2.Enabled = true;
				txtBillingCity.Enabled = true;
				ddlBillingState.Enabled = true;
				txtBillingZip.Enabled = true;
				txtBillingCountry.Enabled = true;
				txtBillingPhone.Enabled = true;

				//enable the validators
				rfvCreditCardBrand.Enabled = true;
				rfvCreditCard.Enabled = true;
				revCreditCard.Enabled = true;
				rfvCreditCardExpiry.Enabled = true;
				revCreditCardExpiry.Enabled = true;
				revBillingName.Enabled = true;
				rfvBillingName.Enabled = true;
				revBillingAddress1.Enabled = true;
				rfvBillingAddress1.Enabled = true;
				revBillingAddress2.Enabled = true;
				revBillingCity.Enabled = true;
				rfvBillingCity.Enabled = true;
				revBillingState.Enabled = true;
				revBillingZip.Enabled = true;
				rfvBillingZip.Enabled = true;
				revBillingCountry.Enabled = true;
				rfvBillingCountry.Enabled = true;
				revBillingPhone.Enabled = true;
				rfvBillingPhone.Enabled = true;
			}
		}
	}
}
