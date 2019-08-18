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
        public static const string VAPI_FOLDER = MAIN_FOLDER + "vapi/";

        public static bool buildProject(BeaverProject project) {
            Beaver.log.info(@"Verifying project structure.");
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
            
            // Building command
            Beaver.log.info(@"Preparing to build...");
            makeBuildFolder();
            var commandBuilder = new StringBuilder();
            // Initial Valac command
            commandBuilder.append_printf("valac -X -w -q --disable-warnings -o %s", BUILD_FOLDER);

            // Adding output folder and executable name
            var exeFileName = project.getAppInfo().getName();
            if (!StringUtil.isNullOrWhitespace(project.getAppInfo().getExecutableName())) {
                exeFileName = project.getAppInfo().getExecutableName();
            }
            commandBuilder.append_printf("%s", exeFileName);

            // Adding dependencies, if any
            if (project.getDependencies().length > 0) {
                Beaver.log.info(@"Adding dependencies...");
                foreach (var dep in project.getDependencies()) {
                    commandBuilder.append_printf(" --pkg %s", dep);
                }
            }

            // Adding Vapi, if 
            if (!FileUtils.test(VAPI_FOLDER, FileTest.IS_DIR)) {
                Beaver.log.info(@"Adding VAPI files...");
                commandBuilder.append_printf(" --vapidir %s", VAPI_FOLDER);
            }

            // Locating and adding source files
            Beaver.log.info(@"Locating source files...");
            var sourceFiles = locateSourceFiles(CODE_FOLDER, mainFilePath, true);
            foreach (var source in sourceFiles) {
                commandBuilder.append_printf(" %s", source);
            }

            // Run valac
            Beaver.log.info(@"Running Valac...");
            var result = Posix.system(commandBuilder.str);
            return result == 0;
        }

        static string[] locateSourceFiles(string path, string mainFile, bool includeMain) {
            string[] files = {};
            if (includeMain) {
                files += mainFile;
            }
            try {
                var sourceDir = Dir.open(path, 0);
                var name = "";
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
            } catch (GLib.FileError e) {
                Beaver.log.error(@"Error while attempting to search source folder.\n%s", e.message);
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
            Beaver.log.info(@"Cleaing build folder");
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