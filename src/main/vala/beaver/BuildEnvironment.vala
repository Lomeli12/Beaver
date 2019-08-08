public class BuildEnvironment {
    public static const string BEAVER_FOLDER = ".beaver";
    public static const string BUILD_FILE = "build.beaver";
    public static const string BUILD_FOLDER = "build/";
    public static const string SOURCE_FOLDER = "src/";
    public static const string MAIN_FOLDER = SOURCE_FOLDER + "main/";
    public static const string CODE_FOLDER = MAIN_FOLDER + "vala/";

    public static bool buildProject(BeaverProject project) {
        stdout.printf(@"Verifying project structure.\n");
        if (!validateFolderStruct()) {
            stdout.printf(@"Missing source folder. Ensure your code is located in \"src/main/vala\" of this directory.\n");
            return false;
        }
        var mainFilePath = CODE_FOLDER + project.getAppInfo().getMainFile();
        var mainFile = File.new_for_path(mainFilePath);
        if (!mainFile.query_exists()) {
            stdout.printf(@"\033[31mCould not find main file: %s\033[0m\n", project.getAppInfo().getMainFile());
            return false;
        }
        stdout.printf(@"Locating source files...\n");
        var sourceFiles = locateSourceFiles(CODE_FOLDER, mainFilePath, true);
        var sources = new StringBuilder();
        foreach (string file in sourceFiles) {
            sources.append(file + " ");
        }

        stdout.printf(@"Creating preparing build...\n");
        makeBuildFolder();
        var output = "-o " + BUILD_FOLDER;
        if (!StringUtil.isNullOrWhitespace(project.getAppInfo().getExecutableName())) {
            output = output + project.getAppInfo().getExecutableName() + " ";
        }

        var deps = new StringBuilder();
        foreach (string dep in project.getDependencies()) {
            deps.append("--pkg " + dep + " ");
        }

        stdout.printf(@"Running Valac\n");
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
        stdout.printf("Cleaning build folder\n");
        return DirUtils.remove(BUILD_FOLDER);
    }
}