public class StringUtil {
    public static bool isNullOrWhitespace(string str) {
        return str == null || str.strip().length == 0;
    }

    public static string readAllLines(File file) {
        if (!file.query_exists()) {
            return null;
        }
        string fileData = null;
        try {
            var dis = new DataInputStream(file.read());
            string line;
            while ((line = dis.read_line(null)) != null) {
                if (fileData == null) {
                    fileData = "";
                }
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