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
                    default:
                        log.warn(@"\033[31mUnknown command: %s\033[0m", args[1]);
                        retValue = noArgDisplay();
                        break;
                }
            }
            var finishTime = get_monotonic_time();
            var timeSpent = (int) Math.rintf((finishTime - startTime) / 1000000f);
            if (retValue == 0) {
                log.info(@"\033[1;32m%s\033[0m in %ds", "BUILD SUCCESSFUL", timeSpent);
            } else {
                log.info(@"\033[1;31m%s\033[0m in %ds", "BUILD FAILED", timeSpent);
            }
            return retValue;
        }

        static int validate() {
            var beaverProject = Parser.getBuildFile();
            if (beaverProject != null) {
                var project = beaverProject.toString();
                log.info(project.substring(0, project.length - 2));
            } else {
                log.info(@"Invalid build.beaver.");
                return 1;
            }
            return 0;
        }

        static int build() {
            var beaverProject = Parser.getBuildFile();
            if (beaverProject != null) {
                log.info(@"Starting Build");
                if (!BuildEnvironment.buildProject(beaverProject)) {
                    return 1;
                }
            } else {
                log.info(@"Invalid build.beaver.");
                return 1;
            }
            return 0;
        }

        static int noArgDisplay() {
            log.info(@"\033[1;32m%s\033[0m\n", "Welcome to Beaver 0.0.1");
            log.info(@"To run a build, run \033[1m%s\033[0m\n", "beaver build");
            log.info(@"To see a list of command-line options, run \033[1m%s\033[0m\n", "beaver tasks");
            log.info(@"For submitting an issue, visit \033[1m%s\033[0m\n", "https://github.com/Lomeli12/Beaver");
            return 0;
        }

        static int listArguments() {
            log.info(@"\033[1;32m%s\033[0m", @"Welcome to Beaver 0.0.1\n");
            log.info(@"\033[32m%s\033[33m - %s\033[0m", "build", "Compiles the project.");
            log.info(@"\033[32m%s\033[33m - %s\033[0m", "clean", "Deletes the build directory.");
            log.info(@"\033[32m%s\033[33m - %s\033[0m", "validate", "Reads out and prints information from the project's build.beaver for manual inspection.\n");
            return 0;
        }
    }
}