public class Beaver {
    public static int main(string[] args) {
        var retValue = 0;
        if (args.length == 1) {
            retValue = listArguments();
        } else if (args.length >= 2) {
            switch (args[1].down()) {
                case "validate":
                    retValue = validate();
                    break;
                case "build":
                    retValue = build();
                    break;
                default:
                    retValue = listArguments();
                    break;
            }
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
            if (BuildEnvironment.buildProject(beaverProject)) {
                stdout.printf(@"\033[1;32m%s\033[0m %s", "BUILD SUCCESSFUL", "in IDK how many seconds.\n");
            } else {
                stdout.printf(@"\033[1;31m%s\033[0m %s", "BUILD FAILED", "in IDK how many seconds.\n");
                return 1;
            }
        } else {
            stderr.printf(@"Invalid build.beaver.\n");
            return 1;
        }
        return 0;
    }

    static int listArguments() {
        var builder = new StringBuilder();
        builder.append_printf("\033[1;32m%s\033[0m", @"Welcome to Beaver 0.0.1\n");

        //stdout.printf(@"TODO: List possible arguements!\n");
        stdout.printf(builder.str);
        return 0;
    }
}