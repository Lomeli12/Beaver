namespace Beaver.CMD.Arguments { 
    public class LongArgument : Argument < long > {
        public LongArgument(string arg) {
            base(arg);
        }

        public override long parseValue(string arg) {
            return long.parse(arg);
        }
    }    
}