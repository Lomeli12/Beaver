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
        var buildFile = Parser.getBuildFile();
        if (buildFile != null) {
            stdout.printf(buildFile.toString());

        } else {
            stdout.printf(@"Invalid build.beaver.\n");
            return 1;
        }
        return 0;
    }

    static int build() {
        var buildFile = Parser.getBuildFile();
        if (buildFile != null) {
            var mainFile = File.new_for_path(buildFile.getAppInfo().getMainFile());
            if (!mainFile.query_exists()) {
                stdout.printf(@"\033[31mCould not find main file: %s\033[0m", buildFile.getAppInfo().getMainFile());
                return 0;
            }
            stdout.printf(@"Running valac\n");
        } else {
            stdout.printf(@"Invalid build.beaver.\n");
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