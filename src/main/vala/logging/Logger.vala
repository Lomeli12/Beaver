using Beaver.Util;

namespace Beaver.Logging {
        public class Logger {
        string name;
        bool verbose;

        public Logger(string name){
            this.name = name;
        }

        public Logger.empty() {
            this("");
        }

        private void log(string type, string message) {
            if (StringUtil.isNullOrWhitespace(message)) {
                return;
            }
            var builder = new StringBuilder();
            if (verbose) {
                builder.append_printf("[%s]", type);
                builder.append_printf("[%s]", getFormattedTime());
                if (!StringUtil.isNullOrWhitespace(this.name)) {
                    builder.append_printf("[%s]", this.name);
                }
                builder.append(": ");
            }
            builder.append_printf("%s\n", message);
            var msg = builder.str;
            stdout.printf(msg);
            //TODO: Save to log file
        }

        public void info(string message, ...) {
            var list = va_list();
            log("INFO", message.vprintf(list));
        }

        public void warn(string message, ...) {
            var list = va_list();
            log("WARN", message.vprintf(list));
        }

        public void debug(string message, ...) {
            var list = va_list();
            log("DEBUG", message.vprintf(list));
        }

        public void error(string message, ...) {
            var list = va_list();
            log("ERROR", message.vprintf(list));
        }

        public Logger setVerbose(bool val) {
            this.verbose = val;
            return this;
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
            return new DateTime.now_local().format("%H:%M:%S");
        }
    }
}