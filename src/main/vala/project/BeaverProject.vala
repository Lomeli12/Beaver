namespace Beaver.Project {
    public class BeaverProject {
        BeaverInfo info;
        string[] dependencies;

        public BeaverProject(BeaverInfo info) {
            this.info = info;
            this.dependencies = {};
        }

        public BeaverInfo getAppInfo() {
            return this.info;
        }

        public string[] getDependencies() {
            return dependencies;
        }

        public void addDependency(string dep) {
            this.dependencies += dep;
        }

        public string toString() {
            var builder = new StringBuilder();
            builder.append(this.getAppInfo().toString());

            if (this.getDependencies().length > 0) {
                builder.append("Dependencies: \n");
                foreach (string dep in this.getDependencies()) {
                    builder.append("- " + dep + "\n");
                }
            }
            return builder.str;
        }
    }
}