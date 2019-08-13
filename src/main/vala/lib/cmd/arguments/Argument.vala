namespace Beaver.CMD.Arguments {
    public abstract class Argument < T > { 
        string arg;
        T argValue;

        public Argument(string arg) {
            this.arg = arg;
        }

        public string getArgument() {
            return this.arg;
        }

        public T setValue(T argValue) {
            this.argValue = argValue;
            return argValue;
        }

        public T getValue() {
            return this.argValue;
        }

        public abstract T parseValue(string arg);
    }
}