package source.Designer.InteractiveObject {
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	
	public class CreateIcon extends Sprite{
		private static var heightLine:int = 5;
		private static var xPict:int = 5;
		private static var yPict:int = 5;
		
		private var activChange:Boolean = false;
		
		private var numCol:int;
		private var numLin:int;
		private var etalonLeng:int;
		
		private var butAddPic:iconPicADDer = new iconPicADDer();
		
		private var hPict:int;
		private var wPict:int;
		
		private var iconFrame:Sprite = new Sprite;
		private var picSprite:Sprite = new Sprite;
		
		private var showPict:Bitmap;
		public function CreateIcon(C:int, L:int, etLeng:int, bmpData:BitmapData = null) {
			super();
			
			super.addChild(picSprite);
			super.addChild(iconFrame);
			
			numCol = C;
			numLin = L;
			etalonLeng = etLeng;
			
			addFrame();
			iconFrame.addChild(butAddPic);
			butAddPic.x = xPict;
			butAddPic.y = yPict;
			fillPicSprite();
			
			
			
			hPict = iconFrame.height - 2*heightLine;
			wPict = iconFrame.width - 2*heightLine;
			if(bmpData!=null){
				showPict = new Bitmap(bmpData);
				picSprite.addChild(showPict);
				showPict.x = xPict;
				showPict.y = yPict;
				showPict.width = wPict;
				showPict.height = hPict;
			}
			butAddPic.addEventListener(MouseEvent.MOUSE_DOWN, butAddPic_MOUSE_DOWN);
		}
		private function addFrame(){
			var conor:iconPicConor = new iconPicConor();
			var line:iconPicLine = new iconPicLine();
			iconFrame.addChild(conor);
			iconFrame.addChild(line);
			line.width = numCol*etalonLeng;
			line.x = conor.x + conor.width;
			
			conor = new iconPicConor();
			iconFrame.addChild(conor);
			conor.rotation = 90;
			conor.x = line.x+line.width+conor.width;
			
			line = new iconPicLine();
			iconFrame.addChild(line);
			line.width = numLin*etalonLeng;
			line.rotation = 90;
			line.x = conor.x;
			line.y = conor.y + conor.height;
			
			conor = new iconPicConor();
			iconFrame.addChild(conor);
			conor.rotation = 180;
			conor.x = line.x;
			conor.y = line.y + line.height + conor.height;
			
			line = new iconPicLine();
			iconFrame.addChild(line);
			line.width = numCol*etalonLeng;
			line.rotation = 180;
			line.y = conor.y;
			line.x = conor.x - conor.height;
			
			conor = new iconPicConor();
			iconFrame.addChild(conor);
			conor.rotation = 270;
			conor.y = line.y;
			conor.x = line.x - line.width - conor.width;
			
			line = new iconPicLine();
			iconFrame.addChild(line);
			line.width = numLin*etalonLeng;
			line.rotation = 270;
			line.x = conor.x;
			line.y = conor.y - conor.height;
		}
		private function fillPicSprite(){
			picSprite.graphics.lineStyle(1,0x000000,0);
			picSprite.graphics.beginFill(0x77F0EC);
			picSprite.graphics.drawRect(0,0,iconFrame.width, iconFrame.height);
			picSprite.graphics.endFill();
		}
		private function butAddPic_MOUSE_DOWN(e:MouseEvent){
			activChange = true;
			super.dispatchEvent(new Event(Event.CHANGE));
		}
		public function getActive():Boolean{
			return activChange;
		}
		public function setDisactive(){
			activChange = false;
		}
	}
	
}
