namespace Beaver.CMD.Arguments { 
    public class StringArgument : Argument < string > {
        public StringArgument(string arg) {
            base(arg);
        }

        public override string parseValue(string arg) {
            return arg;
        }
    }
}