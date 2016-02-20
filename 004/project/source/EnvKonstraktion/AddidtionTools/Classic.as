package source.EnvKonstraktion.AddidtionTools {
	
	public class Classic extends SelectMenu{
		private var cSet:ClassicTanSetToolBut = new ClassicTanSetToolBut();
		private var crSet:ClassicTanRewordSetToolBut = new ClassicTanRewordSetToolBut();
		private var cLargeTreung:ClassicTanLargeTreungToolBut = new ClassicTanLargeTreungToolBut();
		private var cSredTreung:ClassicTanSredTreungToolBut = new ClassicTanSredTreungToolBut();
		private var cSmalTreung:ClassicTanSmalTrungToolBut = new ClassicTanSmalTrungToolBut();
		private var cKvadrat:ClassicTanKvadratToolBut = new ClassicTanKvadratToolBut();
		private var cRomb:ClassicTanRombToolBut = new ClassicTanRombToolBut();
		
		public function Classic() {
			super();
			super.toolArray = this.currentTools;
		}
		private function get currentTools():Array{
			var outArr:Array = new Array();
			outArr.push([cSet, 'classicSet']);
			outArr.push([crSet, 'classicRewordSet']);
			outArr.push([cLargeTreung, 'classicLTreung']);
			outArr.push([cSredTreung, 'classicSredTreung']);
			outArr.push([cSmalTreung, 'classicSmalTreung']);
			outArr.push([cKvadrat, 'classicKvadrat']);
			outArr.push([cRomb, 'classicRomb']);
			return outArr;
		}
	}
	
}
