package source.EnvKonstraktion.AddidtionTools {
	
	public class Primitive extends SelectMenu{
		
		private var pSet:PrimitivSetToolBut = new PrimitivSetToolBut();
		private var pKvadr:PrimitivKvadratToolBut = new PrimitivKvadratToolBut();
		private var pSmalTreug:PrimitivSmalTreugToolBut = new PrimitivSmalTreugToolBut();
		private var pRectangle:PrimitivRecgtangleToolBut = new PrimitivRecgtangleToolBut();
		private var pLargeTreug:PrimitivLargeTreugToolBut = new PrimitivLargeTreugToolBut();
		private var pRound:PrimitivRoundToolBut = new PrimitivRoundToolBut();
		private var pSixUgol:PrimitivSixUgolToolBut = new PrimitivSixUgolToolBut();
		private var pPalochka:PrimitivPalochkaToolBut = new PrimitivPalochkaToolBut();
		
		public function Primitive() {
			super();
			super.toolArray = this.currentTools;
		}
		private function get currentTools():Array{
			var outArr:Array = new Array();
			
			outArr.push([pSet, 'primitiveSet']);
			outArr.push([pKvadr, 'primitiveKvadr']);
			outArr.push([pSmalTreug, 'primitiveSmalTreug']);
			outArr.push([pRectangle, 'primitiveRectangle']);
			outArr.push([pLargeTreug, 'primitiveLargeTreug']);
			outArr.push([pRound, 'primitiveRound']);
			outArr.push([pSixUgol, 'primitiveSixUgol']);
			outArr.push([pPalochka, 'primitivePalochka']);
			return outArr;
		}

	}
	
}
