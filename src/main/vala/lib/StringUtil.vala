namespace Beaver.Util {
    public class StringUtil {
        public static bool isNullOrWhitespace(string str) {
            return str == null || str.strip().length == 0;
        }

        public static string readAllLines(File file) {
            if (!file.query_exists()) {
                return "";
            }
            string fileData = "";
            try {
                var dis = new DataInputStream(file.read());
                string line;
                while ((line = dis.read_line(null)) != null) {
                    line = line.strip();
                    if (!line.has_prefix("#")) {
                        fileData += line + "\n";
                    }
                }
            } catch (Error e) {
                error("%s", e.message);
            }
            return fileData;
        }
    }
}