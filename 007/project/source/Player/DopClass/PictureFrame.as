package source.Player.DopClass {
	import flash.display.Sprite;
	import flash.display.Bitmap;
	
	public class PictureFrame extends Sprite{
		private static var wScene:int = 730;
		private static var hScene:int = 495
		private var arrImge:Array = new Array;
		public function PictureFrame() {
			super();
			super.graphics.lineStyle(2, 0x000000,1);
			super.graphics.beginFill(0x999999,1);
			super.graphics.drawRect(0,0,wScene,hScene);
			super.graphics.endFill()
		}
		
		public function addPict(arrPict:Array){
			var i,j,ID:int;
			var _H,_W:int;
			trace(this + ': Start Added Image');
			for(i=0; i<arrPict.length;i++){
				if(arrPict[i]!=""){
					arrImge[i] = new Bitmap(arrPict[i]);
					_H = arrImge[i].height;
					_W = arrImge[i].width;
					super.addChild(arrImge[i]);
				}else{
					arrImge[i] = "";
				}
			}
			trace(this + ': Stape 1 - Complate');
			if(_H>=_W){
				ID = 0;
				drawFrame1();
				for(i=0;i<2;i++){
					for(j=0;j<3;j++){
						if(arrImge[ID]!=''){
							arrImge[ID].height = hScene/2 - 4;
							arrImge[ID].width = wScene/3 - 4;
							arrImge[ID].x = j*wScene/3+2;
							arrImge[ID].y = i*hScene/2+2;
						}
						++ID;
					}
				}
			}else{
				ID = 0;
				drawFrame2();
				for(i=0;i<2;i++){
					for(j=0;j<3;j++){
						if(arrImge[ID]!=''){
							arrImge[ID].height = hScene/3 - 4;
							arrImge[ID].width = wScene/2 - 4;
							arrImge[ID].x = i*wScene/2+2;
							arrImge[ID].y = j*hScene/3+2;
						}
						++ID;
					}
				}
			}
			trace(this + ': All - Complate');
		}
		private function drawFrame1(){
			super.graphics.moveTo(wScene/3,0);
			super.graphics.lineTo(wScene/3,hScene);
			super.graphics.moveTo(2*wScene/3,0);
			super.graphics.lineTo(2*wScene/3,hScene);
			
			super.graphics.moveTo(0,hScene/2);
			super.graphics.lineTo(wScene,hScene/2);
		}
		private function drawFrame2(){
			super.graphics.moveTo(0,hScene/3);
			super.graphics.lineTo(wScene,hScene/3);
			super.graphics.moveTo(0,2*hScene/3);
			super.graphics.lineTo(wScene,2*hScene/3);
			
			super.graphics.moveTo(wScene/2,0);
			super.graphics.lineTo(wScene/2,hScene);
		}
		public function setMark(ID:int){
			var mark:PictRight = new PictRight();
			super.addChild(mark);
			mark.height = arrImge[ID].height/1.5;
			mark.width = arrImge[ID].width/1.5;
			mark.x = arrImge[ID].x + arrImge[ID].width;
			mark.y = arrImge[ID].y + arrImge[ID].height;
		}
	}
	
}
