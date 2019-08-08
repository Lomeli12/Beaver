public class Beaver {
    public static int main(string[] args) {
        var startTime = TimeUtil.getCurrentTime();
        var retValue = 0;
        if (args.length == 1) {
            retValue = noArgDisplay();
        } else if (args.length >= 2) {
            switch (args[1].down()) {
                case "validate":
                    retValue = validate();
                    break;
                case "build":
                    retValue = build();
                    break;
                case "clean":
                    retValue = BuildEnvironment.cleanBuildFolder();
                    break;
                case "help":
                    retValue = listArguments();
                    break;
            }
        }
        var finishTime = TimeUtil.getCurrentTime();
        var timeSpent = (finishTime - startTime) / 1000000f;
        if (retValue == 0) {
            stdout.printf(@"\033[1;32m%s\033[0m in %f(s)\n", "BUILD SUCCESSFUL", timeSpent);
        } else {
            stdout.printf(@"\033[1;31m%s\033[0m in %f(s)\n", "BUILD FAILED", timeSpent);
        }
        return retValue;
    }

    static int validate() {
        var beaverProject = Parser.getBuildFile();
        if (beaverProject != null) {
            stdout.printf(beaverProject.toString());
        } else {
            stderr.printf(@"Invalid build.beaver.\n");
            return 1;
        }
        return 0;
    }

    static int build() {
        var beaverProject = Parser.getBuildFile();
        if (beaverProject != null) {
            stdout.printf(@"Starting Build\n");
            if (!BuildEnvironment.buildProject(beaverProject)) {
                return 1;
            }
        } else {
            stderr.printf(@"Invalid build.beaver.\n");
            return 1;
        }
        return 0;
    }

    static int noArgDisplay() {
        var builder = new StringBuilder();
        builder.append_printf("\033[1;32m%s\033[0m", @"Welcome to Beaver 0.0.1\n\n");
        builder.append_printf("To run a build, run \033[1mbeaver build\033[0m\n\n");
        builder.append_printf("To see a list of command-line options, run \033[1mbeaver help\033[0m\n\n");
        builder.append_printf("For submitting an issue, visit \033[1mhttps://github.com/Lomeli12/Beaver\033[0m\n\n");
        stdout.printf(builder.str);
        return 0;
    }

    static int listArguments() {
        var builder = new StringBuilder();
        builder.append_printf("\033[1;32m%s\033[0m", @"Welcome to Beaver 0.0.1\n");
        builder.append_printf("\033[32m%s\033[33m - %s\033[0m\n", "build", "Compiles the project.");
        builder.append_printf("\033[32m%s\033[33m - %s\033[0m\n", "clean", "Deletes the build directory.");
        builder.append_printf("\033[32m%s\033[33m - %s\033[0m\n", "validate", "Reads out and prints information from the project's build.beaver for manual inspection.");
        stdout.printf(builder.str);
        return 0;
    }
}