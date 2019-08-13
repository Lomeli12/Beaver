using Beaver.CMD.Arguments;

namespace Beaver.CMD {
    public class CommandContext {
        Argument[] arguments;
        public CommandContext() {
            this.arguments = {};
        }

        public CommandContext addArgument(Argument arg) {
            this.arguments += arg;
            return this;
        }

        public bool getBool(string name) {
            foreach (var arg in this.arguments) {
                if (arg.getArgument() == name && arg is BoolArgument) {
                    return ((BoolArgument) arg).getValue();
                }
            }
            return false;
        }

        public double getDouble(string name) {
            foreach (var arg in this.arguments) {
                if (arg.getArgument() == name && arg is DoubleArgument) {
                    // Broken: gpointer instead of gdouble. How???
                    //return ((DoubleArgument) arg).getValue();
                }
            }
            return 0d;
        }

        public float getFloat(string name) {
            foreach (var arg in this.arguments) {
                if (arg.getArgument() == name && arg is FloatArgument) {
                    // Broken: gpointer instead of gfloat. How???
                    //return ((FloatArgument) arg).getValue();
                }
            }
            return 0f;
        }

        public int getInt(string name) {
            foreach (var arg in this.arguments) {
                if (arg.getArgument() == name && arg is IntArgument) {
                    return ((IntArgument) arg).getValue();
                }
            }
            return 0;
        }

        public long getLong(string name) {
            foreach (var arg in this.arguments) {
                if (arg.getArgument() == name && arg is LongArgument) {
                    return ((LongArgument) arg).getValue();
                }
            }
            return 0l;
        }

        public string getString(string name) {
            foreach (var arg in this.arguments) {
                if (arg.getArgument() == name && arg is StringArgument) {
                    return ((StringArgument) arg).getValue();
                }
            }
            return "";
        }
    }
}