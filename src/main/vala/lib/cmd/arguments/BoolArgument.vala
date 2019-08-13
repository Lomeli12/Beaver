namespace Beaver.CMD.Arguments { 
    public class BoolArgument : Argument < bool >{
        public BoolArgument(string arg) {
            base(arg);
        }

        public override bool parseValue(string arg) {
            return bool.parse(arg);
        }
    }
}