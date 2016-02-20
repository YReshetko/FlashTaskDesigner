package source.EnvKonstraktion.AddidtionTools {
	public class Numbers extends SelectMenu{
		
		private var nSet:NumSetToolBut = new NumSetToolBut();
		private var nZero:NumZeroToolBut = new NumZeroToolBut();
		private var nOne:NumOneToolBut = new NumOneToolBut();
		private var nTwo:NumTwoToolBut = new NumTwoToolBut();
		private var nThree:NumThreeToolBut = new NumThreeToolBut();
		private var nFour:NumFourToolBut = new NumFourToolBut();
		private var nFive:NumFiveToolBut = new NumFiveToolBut();
		private var nSix:NumSixToolBut = new NumSixToolBut();
		private var nSeven:NumSevenToolBut = new NumSevenToolBut();
		private var nEight:NumEightToolBut = new NumEightToolBut();
		private var nNine:NumNineToolBut = new NumNineToolBut();
		private var sPlus:SymbolPlusToolBut = new SymbolPlusToolBut();
		private var sMinus:SymbolMinusToolBut = new SymbolMinusToolBut();
		private var sEqual:SymbolEqualToolBut = new SymbolEqualToolBut();
		public function Numbers() {
			super();
			
			super.toolArray = this.currentTools;
		}
		
		private function get currentTools():Array{
			var outArr:Array = new Array();
			outArr.push([nSet, 'NumberSet']);
			outArr.push([nZero, 'NumberZero']);
			outArr.push([nOne, 'NumberOne']);
			outArr.push([nTwo, 'NumberTwo']);
			outArr.push([nThree, 'NumberThree']);
			outArr.push([nFour, 'NumberFour']);
			outArr.push([nFive, 'NumberFive']);
			outArr.push([nSix, 'NumberSix']);
			outArr.push([nSeven, 'NumberSeven']);
			outArr.push([nEight, 'NumberEight']);
			outArr.push([nNine, 'NumberNine']);
			outArr.push([sPlus, 'SymbolPlus']);
			outArr.push([sMinus, 'SymbolMinus']);
			outArr.push([sEqual, 'SymbolEqual']);
			return outArr;
		}

	}
	
}
