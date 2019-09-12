
namespace Beaver.Project {
    public abstract class ProjectInfo {
        string name;
        string output;
        string version;

        public ProjectInfo(string name, string output, string version) {
            this.name = name;
            this.output = output;
            this.version = version;
        }
        
        public string getName() {
            return this.name;
        }

        public string getOutput() {
            return this.output;
        }

        public string getVersion() {
            return this.version;
        }

        public abstract string toString();
    }
}