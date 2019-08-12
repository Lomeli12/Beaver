using Beaver;
using Beaver.Util;

namespace Beaver.Project {
    public class BuildEnvironment {
        public static const string BEAVER_FOLDER = ".beaver";
        public static const string BUILD_FILE = "build.beaver";
        public static const string BUILD_FOLDER = "build/";
        public static const string SOURCE_FOLDER = "src/";
        public static const string MAIN_FOLDER = SOURCE_FOLDER + "main/";
        public static const string CODE_FOLDER = MAIN_FOLDER + "vala/";

        public static bool buildProject(BeaverProject project) {
            Beaver.log.logNoStamp(@"Verifying project structure.");
            if (!validateFolderStruct()) {
                Beaver.log.error(@"Missing source folder. Ensure your code is located in \"src/main/vala\" of this directory.");
                return false;
            }
            var mainFilePath = CODE_FOLDER + project.getAppInfo().getMainFile();
            var mainFile = File.new_for_path(mainFilePath);
            if (!mainFile.query_exists()) {
                Beaver.log.error(@"\033[31mCould not find main file: %s\033[0m", project.getAppInfo().getMainFile());
                return false;
            }
            Beaver.log.logNoStamp(@"Locating source files...");
            var sourceFiles = locateSourceFiles(CODE_FOLDER, mainFilePath, true);
            var sources = new StringBuilder();
            foreach (string file in sourceFiles) {
                sources.append(file + " ");
            }

            Beaver.log.logNoStamp(@"Preparing to build...");
            makeBuildFolder();
            var output = "-o " + BUILD_FOLDER;
            if (!StringUtil.isNullOrWhitespace(project.getAppInfo().getExecutableName())) {
                output = output + project.getAppInfo().getExecutableName() + " ";
            }

            var deps = new StringBuilder();
            foreach (string dep in project.getDependencies()) {
                deps.append("--pkg " + dep + " ");
            }

            Beaver.log.logNoStamp(@"Running Valac");
            var command = "valac " + output + deps.str + sources.str;
            var result = Posix.system(command);
            return result == 0;
        }

        static string[] locateSourceFiles(string path, string mainFile, bool includeMain) {
            string[] files = {};
            if (includeMain) {
                files += mainFile;
            }
            var sourceDir = Dir.open(path, 0);
            var name = "";
            var x = true; 
            while((name = sourceDir.read_name()) != null) {
                var filePath = Path.build_filename(path, name);
                if (filePath == mainFile)
                    continue;
                if (FileUtils.test(filePath, FileTest.IS_REGULAR) && filePath.has_suffix(".vala")) {
                    files += filePath;
                } else if (FileUtils.test(filePath, FileTest.IS_DIR)) {
                    var subDirFiles = locateSourceFiles(filePath, mainFile, false);
                    if (subDirFiles.length > 0) {
                        foreach (string file in subDirFiles) {
                            files += file;
                        }
                    }
                }
            }
            return files;
        }

        public static bool validateFolderStruct() {
            if (!FileUtils.test(SOURCE_FOLDER, FileTest.IS_DIR)) {
                return false;
            }
            if (!FileUtils.test(MAIN_FOLDER, FileTest.IS_DIR)) {
                return false;
            }
            if (!FileUtils.test(CODE_FOLDER, FileTest.IS_DIR)) {
                return false;
            }
            return true;
        }

        static bool makeBuildFolder() {
            return DirUtils.create_with_parents(BUILD_FOLDER, 0777) == 0;
        }

        public static int cleanBuildFolder() {
            Beaver.log.logNoStamp(@"Cleaing build folder");
            if (!FileUtils.test(BUILD_FOLDER, FileTest.IS_DIR) || rmDir(BUILD_FOLDER)) {
                return 0;
            }
            return 1;
        }

        static bool rmDir(string path, uint level = 0) {
            ++level;
            bool flag = false;
            
    		try {
    			var directory = GLib.File.new_for_path(path);

    			var enumerator = directory.enumerate_children(GLib.FileAttribute.STANDARD_NAME, 0);

    			GLib.FileInfo file_info;
    			while((file_info = enumerator.next_file()) != null) {

                    string file_name = file_info.get_name();
                    
    				if((file_info.get_file_type()) == GLib.FileType.DIRECTORY) {
    					rmDir(path + file_name + "/", level);
                    }
                    
    				var file = directory.get_child(file_name);
    				file.delete();
                }
                
    			if(level == 1) {
                    directory.delete();
                    flag = true;
    			}
    		} catch (Error e) {
    			Beaver.log.error(@"Failed to delete build folder:\n%s", e.message);
    		}
    		return flag;
        }
    }
}