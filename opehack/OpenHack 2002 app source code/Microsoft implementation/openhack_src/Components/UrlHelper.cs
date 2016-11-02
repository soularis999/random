using System;
using System.Text;
using System.Web;

namespace OpenHack {
	/// <summary>
	/// Misc methods for URL manipulation and redirection
	/// </summary>
	internal sealed class UrlHelper {
		internal static void DefaultRedirect(HttpContext ctx) {
			ctx.Response.Redirect("default.aspx", false);
		}

		internal static string CreatePath(HttpContext ctx, string inputPath) {
			StringBuilder sb = new StringBuilder(1024);
			sb.Append(ctx.Request.ApplicationPath);
			if( ctx.Request.ApplicationPath.EndsWith("/") )
				sb.Append(inputPath);
			else {
				sb.Append("/");
				sb.Append(inputPath);
			}

			return sb.ToString();
		}

	}
}
