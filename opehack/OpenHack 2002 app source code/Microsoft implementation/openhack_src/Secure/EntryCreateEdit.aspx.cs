using System;
using System.Data;
using System.Web.Security;
using System.Configuration;
using System.Web.Mail;
using System.Text;

namespace OpenHack
{
	/// <summary>
	/// Summary description for entrycreateedit.
	/// </summary>
	public class EntryCreateEdit : System.Web.UI.Page
	{
		string companyId = String.Empty;
		string productId = String.Empty;
		protected System.Web.UI.WebControls.TextBox txtProductName;
		protected System.Web.UI.WebControls.TextBox txtVersion;
		protected System.Web.UI.WebControls.TextBox txtAnnouncementDate;
		protected System.Web.UI.WebControls.TextBox txtShipDate;
		protected System.Web.UI.WebControls.TextBox txtDescription;
		protected System.Web.UI.WebControls.TextBox txtBusinessProblem;
		protected System.Web.UI.WebControls.TextBox txtCompetitors;
		protected System.Web.UI.WebControls.TextBox txtKeyFeatures;
		protected System.Web.UI.WebControls.TextBox txtPrice;
		protected System.Web.UI.WebControls.TextBox txtCustomerReferences;
		protected System.Web.UI.WebControls.TextBox txtTargetAudience;
		protected System.Web.UI.WebControls.RadioButtonList rblNda;
		protected System.Web.UI.WebControls.TextBox txtUrl;
		protected System.Web.UI.WebControls.Label lblCompanyName;
		protected System.Web.UI.WebControls.Button btnSubmit;
		protected System.Web.UI.WebControls.RequiredFieldValidator rfvProductName;
		protected System.Web.UI.WebControls.RegularExpressionValidator revProductName;
		protected System.Web.UI.WebControls.RequiredFieldValidator rfvVersion;
		protected System.Web.UI.WebControls.RegularExpressionValidator revVersion;
		protected System.Web.UI.WebControls.RequiredFieldValidator rfvAnnouncementDate;
		protected System.Web.UI.WebControls.RegularExpressionValidator revAnnouncementDate;
		protected System.Web.UI.WebControls.RequiredFieldValidator rfvShipDate;
		protected System.Web.UI.WebControls.RegularExpressionValidator revShipDate;
		protected System.Web.UI.WebControls.RegularExpressionValidator revUrl;
		protected System.Web.UI.WebControls.RequiredFieldValidator rfvTargetAudience;
		protected System.Web.UI.WebControls.RegularExpressionValidator revTargetAudience;
		protected System.Web.UI.WebControls.RequiredFieldValidator rfvDescription;
		protected System.Web.UI.WebControls.RegularExpressionValidator revDescription;
		protected System.Web.UI.WebControls.RequiredFieldValidator rfvBusinessProblem;
		protected System.Web.UI.WebControls.RegularExpressionValidator revBusinessProblem;
		protected System.Web.UI.WebControls.RequiredFieldValidator rfvCompetitors;
		protected System.Web.UI.WebControls.RegularExpressionValidator revCompetitors;
		protected System.Web.UI.WebControls.RequiredFieldValidator rfvKeyFeatures;
		protected System.Web.UI.WebControls.RegularExpressionValidator revKeyFeatures;
		protected System.Web.UI.WebControls.RequiredFieldValidator rfvPrice;
		protected System.Web.UI.WebControls.RegularExpressionValidator revPrice;
		protected System.Web.UI.WebControls.RequiredFieldValidator rfvCustomerReferences;
		protected System.Web.UI.WebControls.RegularExpressionValidator revCustomerReferences;
		protected System.Web.UI.HtmlControls.HtmlInputHidden hfCompanyId;
		protected System.Web.UI.HtmlControls.HtmlInputHidden hfProductId;
	
		private void Page_Load(object sender, System.EventArgs e)
		{
			string userId = CleanString.SqlText(Context.User.Identity.Name, 10);
			
			// determine if entry deadline has passed
			if (DateTime.Now > DateTime.Parse(ConfigurationSettings.AppSettings[Global.ContestEndDate]))
			{
				//set msg and redirect to home page
				Session.Add(Global.Session_PageMessage,PageMessage.Product_DeadLinePassed);
				Response.Redirect(UrlHelper.CreatePath(Context, "Default.aspx"));
				return;
			}

			//this page has a time out
			if (Session.IsNewSession)
			{
				//if the user has let the page sit for 12 hours
				//sign them out
				FormsAuthentication.SignOut();

				//set msg and redirect to home page
				Session.Add(Global.Session_PageMessage,PageMessage.Session_Timeout);
				Response.Redirect(UrlHelper.CreatePath(Context, "Default.aspx"));
				return;
			}
			else
			{
				Session.Timeout = 720; //12 hour time out
			}

			companyId = CleanString.FetchInputDigit(Request, Global.CompanyId, 10);
			productId = CleanString.FetchInputDigit(Request, Global.ProductId, 10);

			if (companyId != String.Empty  )
			{
				//verify the company id
				if (!CompanyInfo.IsUserCompany(userId, companyId))
				{
					//nothing found user is cheating
					//set msg and redirect to home page
					Session.Add(Global.Session_PageMessage, PageMessage.Company_NotAuthorized);
					Response.Redirect(UrlHelper.CreatePath(Context, "Default.aspx"));
					return;
				}
			}

			if (productId != String.Empty )
			{
				//verify the user can edit product id
				object objReturn = ProductInfo.GetCompanyId(userId, productId);

				if (objReturn == null)
				{
					//nothing found user is cheating
					//set msg and redirect to home page
					Session.Add(Global.Session_PageMessage, PageMessage.Product_NotAuthorized);
					Response.Redirect(UrlHelper.CreatePath(Context, "Default.aspx"));
					return;
				}
				else
				{
					companyId = objReturn.ToString();
				}
			}

			//if nothing is passed in
			if ((companyId == String.Empty) && (productId == String.Empty))
			{
				//get the the last company id
				DataSet dsUserCompanies = CompanyInfo.GetAllUserCompanies(userId);

				foreach (DataRow drRow in dsUserCompanies.Tables[0].Rows)
				{
					companyId = drRow["COMPANYID"].ToString();
				}

				if (companyId == String.Empty)
				{
					//nothing found user must register a company first
					//set msg and redirect to home page
					Session.Add(Global.Session_PageMessage, PageMessage.Product_NotAuthorized);
					Response.Redirect(UrlHelper.CreatePath(Context, "Default.aspx"));
					return;
				}
			}

			if (!Page.IsPostBack)
			{
				//hide the ids
				hfProductId.Value = productId;
				hfCompanyId.Value = companyId;

				//if this is an edit
				if (productId != String.Empty)
				{					
					//get the product info
					DataSet dsProductInfo = ProductInfo.GetProductInfo(productId);

					//if the product is found
					if (dsProductInfo.Tables[0].Rows.Count > 0)
					{
						DataRow dr = dsProductInfo.Tables[0].Rows[0];

						// SECREVIEW: Data coming from dataset
						// multiline text boxes are HtmlEncoded, single line
						// are attribute values and are attribute encoded
						txtProductName.Text = dr["PRODUCTNAME"].ToString();
						txtVersion.Text = dr["VERSION"].ToString();
						txtAnnouncementDate.Text = dr["ANNOUNCEMENTDATE"].ToString();
						txtShipDate.Text = dr["SHIPDATE"].ToString();
						txtUrl.Text = dr["URL"].ToString();
						txtTargetAudience.Text = dr["TARGETAUDIENCE"].ToString();
						txtDescription.Text = dr["DESCRIPTION"].ToString();
						txtBusinessProblem.Text = dr["BUSINESSPROBLEM"].ToString();
						txtCompetitors.Text = dr["COMPETITORS"].ToString();
						txtKeyFeatures.Text = dr["KEYFEATURES"].ToString();
						txtPrice.Text = dr["PRICE"].ToString();
						txtCustomerReferences.Text = dr["CUSTOMERREFERENCES"].ToString();

						if (dr["NDA"].ToString() == "Y")
						{
							rblNda.SelectedIndex = 1;
						}

						// SECREVIEW: Company Name string: coming from DB and HtmlEncoded
						//fill the company name
						CleanString.SetLabel(lblCompanyName, CompanyInfo.GetCompanyName(companyId));
					}
				}
				else if (companyId != String.Empty)
				{
					// SECREVIEW: Company Name string: coming from DB and HtmlEncoded
					//this is a new entry
					//fill the company name
					CleanString.SetLabel(lblCompanyName, CompanyInfo.GetCompanyName(companyId));
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
			string productName = CleanString.SqlText(txtProductName.Text, 100);
			string version = CleanString.SqlText(txtVersion.Text, 30);
			string announcementDate = CleanString.SqlText(txtAnnouncementDate.Text, 30);
			string shipDate = CleanString.SqlText(txtShipDate.Text, 30);
			string productUrl = CleanString.SqlText(txtUrl.Text, 100);
			string productNda = CleanString.SqlText(rblNda.SelectedItem.Value.ToUpper(), 1);
			string targetAudience = CleanString.SqlText(txtTargetAudience.Text, 2200);
			string description = CleanString.SqlText(txtDescription.Text, 5500);
			string businessProblem = CleanString.SqlText(txtBusinessProblem.Text, 2200);
			string competitors = CleanString.SqlText(txtCompetitors.Text, 2200);
			string keyFeatures = CleanString.SqlText(txtKeyFeatures.Text, 5500);
			string price = CleanString.SqlText(txtPrice.Text, 2200);
			string customerReferences = CleanString.SqlText(txtCustomerReferences.Text, 5500);

			//post back
			if (productId == String.Empty)
			{
				//add new entry
				ProductInfo.AddNewProduct(companyId, productName, version, announcementDate, shipDate, productUrl, productNda, targetAudience, description, businessProblem, competitors, keyFeatures, price, customerReferences);

				// SECREVIEW: this is an email of content type text
				// should it be HTML encoded?
				StringBuilder messageText = new StringBuilder();
				messageText.AppendFormat("Dear {0}, \n\n" +
					"This e-mail is to confirm that following product or service has been submitted to eWEEK's eXcellence Awards program:\n\n" +
					"Company Name: {1}\n" +
					"Product or Service Name: {2}\n" +
					"Version: {3}\n" +
					"Announcement Date: {4}\n" +
					"Scheduled Ship Date: {5}\n",
					Server.HtmlEncode(userId),
					Server.HtmlEncode(lblCompanyName.Text),
					Server.HtmlEncode(productName),
					Server.HtmlEncode(version),
					Server.HtmlEncode(announcementDate),
					Server.HtmlEncode(shipDate));				

				if (txtUrl.Text.Trim() == String.Empty)
				{
					messageText.Append("Product or Service's Web page: (none provided)\n");
				}
				else 
				{
					if (txtUrl.Text.ToLower().IndexOf("http://") > 0)
					{
						messageText.AppendFormat("Product or Service's Web page: {0}\n", Server.HtmlEncode(txtUrl.Text));
					}
					else
					{
						messageText.AppendFormat("Product or Service's Web page: http://{0}\n", Server.HtmlEncode(txtUrl.Text));
					}
				}

				messageText.AppendFormat("NDA or Embargo Required? {0}\n\n" +
					"Target audience for product or service:\n\n" +
					"{1}\n\nDescription of product or service:\n\n" +
					"{2}\n\nBusiness problem that the product or service proposes to solve:\n\n" +
					"{3}\n\nNames of competing products or services:\n\n" +
					"{4}\n\nKey features that differentiate this product or service from its competition:\n\n" +
					"{5}\n\nPricing:\n\n" +
					"{6}\n\nCustomer references:\n\n" +
					"{7}\n\nRegards,\n" +
					"eWEEK\nhttp://www.excellenceawardsonline.com",
					Server.HtmlEncode(productNda),
					Server.HtmlEncode(targetAudience),
					Server.HtmlEncode(description),
					Server.HtmlEncode(businessProblem),
					Server.HtmlEncode(competitors),
					Server.HtmlEncode(keyFeatures),
					Server.HtmlEncode(price),
					Server.HtmlEncode(customerReferences));

				//create email
				MailMessage mm = new MailMessage();					
				mm.Body = messageText.ToString();
				mm.To = UserInfo.GetUserEmail(userId);
				mm.From = ConfigurationSettings.AppSettings[Global.EmailFrom];
				mm.Headers.Add("Reply-To", mm.From);
				mm.Subject = "eWEEK eXcellence Awards entry confirmation";

				try
				{
					SmtpHelper.SendMail(mm);
				}
				catch
				{
					//mail failed, ignore
				}

				//redirect to thank page
				Response.Redirect("ThankYou.aspx");
				return;
			}
			else
			{
				//update entry
				ProductInfo.UpdateProduct(productId, productName, version, announcementDate, shipDate, productUrl, productNda, targetAudience, description, businessProblem, competitors, keyFeatures, price, customerReferences);

				//set msg and redirect to home page
				Session.Add(Global.Session_PageMessage, PageMessage.Product_Updated);
				Response.Redirect(UrlHelper.CreatePath(Context, "Default.aspx"));
				return;
			}
		}
	}
}
