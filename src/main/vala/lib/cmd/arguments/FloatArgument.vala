namespace Beaver.CMD.Arguments { 
    public class FloatArgument : Argument < float > {
        public FloatArgument(string arg) {
            base(arg);
        }

        public override float parseValue(string arg) {
            return float.parse(arg);
        }
    }
}