using Beaver.Util;
namespace Beaver.Logging {
	public class Logger {
		string name;

		public Logger(string name){
			this.name = name;
		}

		public Logger.empty() {
			this("");
		}

		private void log(string type, string message, ...) {
			if (StringUtil.isNullOrWhitespace(message)) {
				return;
			}
			var builder = new StringBuilder();
			builder.append_printf("[%s]", type);
			builder.append_printf("[%s]", getFormattedTime());
			if (!StringUtil.isNullOrWhitespace(this.name)) {
				builder.append_printf("[%s]", this.name);
			}
			builder.append(": ");
			builder.append(formatString(message, va_list()) + "\n");
			var msg = builder.str;
			stdout.printf(msg);
			//TODO: Save to log file
		}

		public void info(string message, ...) {
			log("INFO", message, va_list());
		}

		public void warn(string message, ...) {
			log("WARN", message, va_list());
		}

		public void debug(string message, ...) {
			log("DEBUG", message, va_list());
		}

		public void error(string message, ...) {
			log("ERROR", message, va_list());
		}

		public void logNoStamp(string message, ...) {
			var msg = formatString(message, va_list());
			stdout.printf(msg);
			//TODO: Save to log file
		}

		private string formatString(string message, ...) {
			var varargs = va_list();
			string str;
			while ((str = varargs.arg()) != null) {
				if (!message.contains("{}")) {
					break;
				}
				var index = message.index_of("{}");
				var newMsg = message.splice(index, index + 1, str);
				message = newMsg;
			}
			return message;
		}

		public string createFormat(int[] formatCodes) {
			if (formatCodes == null || formatCodes.length == 0) {
                return "";
            }
            var builder = new StringBuilder();
            builder.append("\033[");

            for (int i = 0; i < formatCodes.length; i++) {
                builder.append_printf("%d", formatCodes[i]);
                if (formatCodes.length > 1 && i < (formatCodes.length - 1)) {
                    builder.append(";");
                }
            }
            var format = builder.str;
            return format.substring(0, format.length) + "m";
		}

		private string getFormattedTime() {
			return new DateTime.now().format("%H:%M:%S");
		}
	}
}