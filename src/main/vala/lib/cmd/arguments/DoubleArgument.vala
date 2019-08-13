namespace Beaver.CMD.Arguments { 
    public class DoubleArgument : Argument < double > {
        public DoubleArgument(string arg) {
            base(arg);
        }

        public override double parseValue(string arg) {
            return double.parse(arg);
        }
    }
}