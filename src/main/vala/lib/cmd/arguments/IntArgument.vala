namespace Beaver.CMD.Arguments { 
    public class IntArgument : Argument < int > {
        public IntArgument(string arg) {
            base(arg);
        }

        public override int parseValue(string arg) {
            return int.parse(arg);
        }
    }    
}