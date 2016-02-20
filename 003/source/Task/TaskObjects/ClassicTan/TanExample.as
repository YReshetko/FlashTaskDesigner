package source.Task.TaskObjects.ClassicTan {
	import source.Task.TaskObjects.BaseTan.BaseLineTan;
	import flash.display.Sprite;
	
	public class TanExample extends BaseLineTan{
		private static var tanArr:Array = new Array([],
													[[[0, 200], [200,  0 ], [400, 200]]],
													[[[0, 200], [200,  0 ], [200, 400]]],
													[[[0,  0 ], [100, 100], [ 0 , 200]]],
													[[[0,  0 ], [100, 100], [200,  0 ]]],
													[[[0,  0 ], [ 0 , 200], [200,  0 ]]],
													[[[0, 100], [100,  0 ], [300,  0 ], [200, 100]], [[0, 0], [200, 0], [300, 100], [100, 100]]],
													[[[0, 100], [100,  0 ], [200, 100], [100, 200]]]);
/*		private static var tanCutArr:Array = new Array([],
													[[[40, 180], [200,  20 ], [360, 180]]],
													[[[20, 200], [180,  40 ], [180, 360]]],
													[[[20,  40 ], [80, 100], [ 20 , 160]]],
													[[[40,  20 ], [100, 80], [160,  20 ]]],
													[[[20,  20 ], [ 20 , 160], [160,  20 ]]],
													[[[40, 80], [100,  20 ], [260,  20 ], [180, 80]], [[40, 20], [200, 20], [260, 80], [100, 80]]],
													[[[20, 100], [100,  20 ], [180, 100], [100, 180]]]);
*/
		private var tanID:int;
		public function TanExample(id:int, blackContainer:Sprite, colorContainer:Sprite) {
			super(colorContainer, blackContainer);
			tanID = id;
			super.arrPoint = tanArr[tanID];
			super.centring();
			super.line = false;
		}
		public function get id():int{
			return tanID-1;
		}
		public function set settings(value:XMLList):void{
			var inXml:XMLList = value;
			super.setSize(parseFloat(inXml.WIDTH), parseFloat(inXml.HEIGHT));
			super.color = inXml.COLOR.COLOR;
			super.colorR = inXml.COLOR.R;
			super.blackR = inXml.BLACK.R;
			super.setColorPosition(parseFloat(inXml.COLOR.X), parseFloat(inXml.COLOR.Y));
			super.setBlackPosition(parseFloat(inXml.BLACK.X), parseFloat(inXml.BLACK.Y));
			super.alphaB = inXml.ALPHA.toString() == 'true';
			super.deleteB = inXml.DELBLACK.toString() == 'true';
			super.deleteC = inXml.DELCOLOR.toString() == 'true';
			if(inXml.PAINTING.toString()!=''){
				super.paint = true;
				if(inXml.PAINTING.TIME.toString()!=''){
					super.paintTime = parseInt(inXml.PAINTING.TIME);
				}
			}
			if(inXml.CUT.toString()!=''){
				super.cut = true;
				super.cutHelp = inXml.CUT.HELP.toString()=='true'
			}
			if(inXml.SHOWING.toString()!=''){
				if(inXml.SHOWING.TAN.toString() == 'BLACK'){
					super.setShowing('ЧЁРНЫЙ', parseInt(inXml.SHOWING.BLOCK.toString()), parseInt(inXml.SHOWING.SHOW.toString()));
				}else{
					super.setShowing('ЦВЕТНОЙ', parseInt(inXml.SHOWING.BLOCK.toString()), parseInt(inXml.SHOWING.SHOW.toString()));
				}
			}
			if(inXml.VANISHING.toString()!=''){
				if(inXml.VANISHING.TAN.toString() == 'BLACK'){
					super.setVanishing('ЧЁРНЫЙ', parseInt(inXml.VANISHING.BLOCK.toString()), parseInt(inXml.VANISHING.SHOW.toString()), parseInt(inXml.VANISHING.VANISH.toString()));
				}else{
					super.setVanishing('ЦВЕТНОЙ', parseInt(inXml.VANISHING.BLOCK.toString()), parseInt(inXml.VANISHING.SHOW.toString()), parseInt(inXml.VANISHING.VANISH.toString()));
				}
			}
		}
		public function get listSettings():XMLList{
			var outXml:XMLList = super.listLineSettings;
			outXml.@label = 'КОМПЛЕКТНЫЙ ТАН';
			return outXml;
		}
		
		public function get listPosition():XMLList{
			var outXml:XMLList = new XMLList('<TAN/>');
			outXml.@id = tanID.toString();
			outXml.WIDTH = super.width;
			outXml.HEIGHT = super.height;
			
			outXml.COLOR.X = super.colorX;
			outXml.COLOR.Y = super.colorY;
			outXml.COLOR.R = super.colorR;
			outXml.COLOR.COLOR = '0x' + super.color.toString(16);
			
			outXml.BLACK.X = super.blackX;
			outXml.BLACK.Y = super.blackY;
			outXml.BLACK.R = super.blackR;
			
			outXml.ALPHA = super.alphaB;
			outXml.DELBLACK = super.deleteB;
			outXml.DELCOLOR = super.deleteC;
			
			if(super.showTan != 'НЕТ'){
				if(super.showTan == 'ЦВЕТНОЙ') {
					outXml.SHOWING.TAN = 'COLOR';
				}else{
					outXml.SHOWING.TAN = 'BLACK';
				}
				outXml.SHOWING.BLOCK = super.showBlock;
				outXml.SHOWING.SHOW = super.showShow;
			}
			if(super.vanishTan != 'НЕТ'){
				if(super.vanishTan == 'ЦВЕТНОЙ'){
					outXml.VANISHING.TAN = 'COLOR';
				}else{
					outXml.VANISHING.TAN = 'BLACK';
				}
				outXml.VANISHING.BLOCK = super.vanishBlock;
				outXml.VANISHING.SHOW = super.vanishShow;
				outXml.VANISHING.VANISH = super.vanishVanish;
			}
			if(super.paint){
				outXml.PAINTING.PAINT = true;
				outXml.PAINTING.TIME = super.paintTime;
			}
			if(super.cut){
				if(super.cutHelp) outXml.CUT.HELP = true;
				else outXml.CUT.HELP = false;
			}
			
			return outXml;
		}
	}
	
}
