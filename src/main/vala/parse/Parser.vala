using Beaver.Project;
using Beaver.Util;

namespace Beaver {
    public class Parser {
        public static BeaverProject getBuildFile() {
            var file = File.new_for_path(Constants.BUILD_FILE);
            if (!file.query_exists()) {
                stdout.printf(@"Could not find build.beaver!\n");
                return null;
            }
            var fileData = StringUtil.readAllLines(file);
            if (StringUtil.isNullOrWhitespace(fileData)) {
                stdout.printf(@"build.beaver is empty!\n");
                return null;
            }
            return parseBuildFile(fileData);
        }

        static BeaverProject parseBuildFile(string data) {
            try {
                var parser = new Json.Parser();
                parser.load_from_data(data, -1);

                var root = parser.get_root().get_object();
                var appInfo = getAppInfo(root);
                if (appInfo == null) {
                    stderr.printf(@"Could not get \"appinfo\"");
                    return null;
                }
                var beaverProject = new BeaverProject(appInfo);

                if (root.has_member("dependencies")) {
                    parseDependencies(root, beaverProject);
                }
                return beaverProject;
            } catch (Error e) {
                stderr.printf("Failed to parse build.beaver!\n%s\n", e.message);
            }
            return null;
        }

        static BeaverInfo getAppInfo(Json.Object root) {
            if (!root.has_member("appinfo")) {
                stderr.printf(@"Missing \"appinfo\" block. \"appinfo\" is required!\n");
                return null;
            }
            var infoObj = root.get_object_member("appinfo");
            var values = new string[4];
            //Required Info (name and main file path)
            if (!infoObj.has_member("name")) {
                stderr.printf(@"Appinfo missing \"name\". \"name\" is required!\n");
                return null;
            }
            values[0] = infoObj.get_string_member("name");
            if (!infoObj.has_member("mainFile")) {
                stderr.printf(@"Appinfo missing \"mainFile\". \"mainFile\" is required!\n");
                return null;
            }
            values[1] = infoObj.get_string_member("mainFile");

            // Optional Info
            if (infoObj.has_member("exeName")) {
                values[2] = infoObj.get_string_member("exeName");
            }
            if (infoObj.has_member("version")) {
                values[3] = infoObj.get_string_member("version");
            }
            return new BeaverInfo(values[0], values[1], values[2], values[3]);
        }

        static void parseDependencies(Json.Object root, BeaverProject beaverProject) {
            var jsonDep = root.get_array_member("dependencies");
            for (int i = 0; i < jsonDep.get_length(); i++) {
                beaverProject.addDependency(jsonDep.get_string_element(i));
            }
        }
    }
}