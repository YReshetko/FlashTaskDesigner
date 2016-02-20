package source.BlockOfTask.Task.TaskObjects.ClassicTan {
	import source.BlockOfTask.Task.TaskObjects.BaseTan.BaseLineTan;
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
		private static var tanCutArr:Array = new Array([],
													[[[40, 180], [200,  20 ], [360, 180]]],
													[[[20, 200], [180,  40 ], [180, 360]]],
													[[[20,  40 ], [80, 100], [ 20 , 160]]],
													[[[40,  20 ], [100, 80], [160,  20 ]]],
													[[[20,  20 ], [ 20 , 160], [160,  20 ]]],
													[[[40, 80], [100,  20 ], [260,  20 ], [180, 80]], [[40, 20], [200, 20], [260, 80], [100, 80]]],
													[[[20, 100], [100,  20 ], [180, 100], [100, 180]]]);

		private var tanID:int;
		public function TanExample(inXml:XMLList, blackContainer:Sprite, colorContainer:Sprite) {
			super(colorContainer, blackContainer);
			tanID = parseInt(inXml.@id);
			super.arrPoint = tanArr[tanID];
			super.centring();
			super.setSize(parseFloat(inXml.WIDTH), parseFloat(inXml.HEIGHT));
			super.color = inXml.COLOR.COLOR;
			super.colorR = inXml.COLOR.R;
			super.blackR = inXml.BLACK.R;
			super.setColorPosition(parseFloat(inXml.COLOR.X), parseFloat(inXml.COLOR.Y));
			super.setBlackPosition(parseFloat(inXml.BLACK.X), parseFloat(inXml.BLACK.Y));
			super.alphaB = inXml.ALPHA.toString() == 'true';
			super.deleteB = inXml.DELBLACK.toString() == 'true';
			super.deleteColorTan = inXml.DELCOLOR.toString() == 'true';
			if(inXml.PAINTING.toString()!=''){
				if(inXml.PAINTING.TIME.toString()==''){
					super.paintTan();
				}else{
					super.paintTan(parseInt(inXml.PAINTING.TIME));
				}
			}
			if(inXml.CUT.toString()!=''){
				super.cutTan(tanCutArr[tanID], inXml.CUT.HELP.toString()=='true');
			}
			if(inXml.SHOWING.toString()!=''){
				if(inXml.SHOWING.TAN.toString() == 'BLACK'){
					super.setShowing('black', parseInt(inXml.SHOWING.BLOCK.toString()), parseInt(inXml.SHOWING.SHOW.toString()));
				}else{
					super.setShowing('color', parseInt(inXml.SHOWING.BLOCK.toString()), parseInt(inXml.SHOWING.SHOW.toString()));
				}
			}
			if(inXml.VANISHING.toString()!=''){
				if(inXml.VANISHING.TAN.toString() == 'BLACK'){
					super.setVanishing('black', parseInt(inXml.VANISHING.BLOCK.toString()), parseInt(inXml.VANISHING.SHOW.toString()), parseInt(inXml.VANISHING.VANISH.toString()));
				}else{
					super.setVanishing('color', parseInt(inXml.VANISHING.BLOCK.toString()), parseInt(inXml.VANISHING.SHOW.toString()), parseInt(inXml.VANISHING.VANISH.toString()));
				}
			}
			super.line = false;
		}
		public function get id():int{
			return tanID-1;
		}
	}
	
}
