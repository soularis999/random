using System;
using System.Web;
using System.Web.Mail;

namespace OpenHack
{
	/// <summary>
	/// Summary description for SmtpHelper.
	/// </summary>
	public class SmtpHelper
	{
		internal static void SendMail(MailMessage mm) {
			bool isEnabled = ConfigHelper.GetConfigBool(Global.EmailEnabled);
			if( isEnabled ) {
				SmtpMail.SmtpServer = ConfigHelper.GetConfig(Global.EmailServer);
				SmtpMail.Send(mm);
			}
		}
	}
}
