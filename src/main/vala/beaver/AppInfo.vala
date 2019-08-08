public class AppInfo {
    string name;
    string mainFile;
    string executeName;
    string version;

    public AppInfo(string name, string mainFile, string executeName, string version) {
        this.name = name;
        this.mainFile = mainFile;
        this.executeName = executeName;
        this.version = version;
    }

    public string getName() {
        return this.name;
    }

    public string getMainFile() {
        return this.mainFile;
    }

    public string getExecutableName() {
        return this.executeName;
    }

    public string getVersion() {
        return this.version;
    }

    public string toString() {
        var builder = new StringBuilder();
        builder.append("AppInfo: \n");
        builder.append("- Name: " + this.getName() + "\n");
        builder.append("- Main File: " + this.getMainFile() + "\n");
        if (!StringUtil.isNullOrWhitespace(this.getExecutableName())) {
            builder.append("- Executable Name: " + this.getExecutableName() + "\n");
        }
        if (!StringUtil.isNullOrWhitespace(this.getVersion())) {
            builder.append("- Version: " + this.getVersion() + "\n");
        }
        return builder.str;
    }
}