using Beaver.Project;
using Beaver.Util;
using Beaver.Logging;

namespace Beaver {
    public class Beaver {
        public static Logger log;

        public static int main(string[] args) {
            log = new Logger.empty();
            var startTime = get_monotonic_time();
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
                    case "tasks":
                        retValue = listArguments();
                        break;
                    case "help":
                        retValue = noArgDisplay();
                        break;
                }
            }
            var finishTime = get_monotonic_time();
            var timeSpent = (finishTime - startTime) / 1000000f;
            if (retValue == 0) {
                log.logNoStamp(@"\033[1;32m%s\033[0m in %f(s)", "BUILD SUCCESSFUL", timeSpent);
            } else {
                log.logNoStamp("\033[1;31m%s\033[0m in %f(s)", "BUILD FAILED", timeSpent);
            }
            return retValue;
        }

        static int validate() {
            var beaverProject = Parser.getBuildFile();
            if (beaverProject != null) {
                var project = beaverProject.toString();
                log.logNoStamp(project.substring(0, project.length - 2));
            } else {
                log.logNoStamp("Invalid build.beaver.");
                return 1;
            }
            return 0;
        }

        static int build() {
            var beaverProject = Parser.getBuildFile();
            if (beaverProject != null) {
                log.logNoStamp("Starting Build");
                if (!BuildEnvironment.buildProject(beaverProject)) {
                    return 1;
                }
            } else {
                log.logNoStamp("Invalid build.beaver.");
                return 1;
            }
            return 0;
        }

        static int noArgDisplay() {
            log.logNoStamp("\033[1;32m%s\033[0m\n", "Welcome to Beaver 0.0.1");
            log.logNoStamp("To run a build, run \033[1m%s\033[0m\n", "beaver build");
            log.logNoStamp("To see a list of command-line options, run \033[1m%s\033[0m\n", "beaver tasks");
            log.logNoStamp("For submitting an issue, visit \033[1m%s\033[0m\n", "https://github.com/Lomeli12/Beaver");
            return 0;
        }

        static int listArguments() {
            log.logNoStamp("\033[1;32m%s\033[0m", @"Welcome to Beaver 0.0.1\n");
            log.logNoStamp("\033[32m%s\033[33m - %s\033[0m", "build", "Compiles the project.");
            log.logNoStamp("\033[32m%s\033[33m - %s\033[0m", "clean", "Deletes the build directory.");
            log.logNoStamp("\033[32m%s\033[33m - %s\033[0m", "validate", "Reads out and prints information from the project's build.beaver for manual inspection.");
            log.logNoStamp("");
            return 0;
        }
    }
}