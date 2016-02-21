package source.Designer.Instrument {
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.events.MouseEvent;
	public class LineObj extends Sprite{
		//private var pointC;
		private var ID:int;
		private var TargetID:int = -1;
		private var WIDTH:int;
		private var HEIGHT:int;
		private var InputImg:Bitmap;
		private var contentSprite:Sprite = new Sprite;
		private var functionalSprite:Sprite = new Sprite;
		private var SelectMethod;
		public function LineObj(_W:Number, _H:Number, _id:int) {
			ID = _id;
			WIDTH = _W;
			HEIGHT = _H;
			greyColor();
			this.addChild(contentSprite)
			this.addChild(functionalSprite);
		}
		public function greenColor(){
			this.graphics.clear()
			this.graphics.lineStyle(1,0x000000,0);
			this.graphics.beginFill(0x00ff00);
			this.graphics.drawRect(0,0,WIDTH,HEIGHT);
			this.graphics.endFill();
		}
		public function greyColor(){
			this.graphics.clear()
			this.graphics.lineStyle(1,0x000000,0);
			this.graphics.beginFill(0x666666);
			this.graphics.drawRect(0,0,WIDTH,HEIGHT);
			this.graphics.endFill();
		}
		public function setContent(_id:int, CONTENT:Bitmap){
			InputImg = CONTENT;
			contentSprite.addChild(InputImg);
			InputImg.width = WIDTH;
			InputImg.height = HEIGHT;
			//trace(_id);
			TargetID = _id;
		}
		public function getID():int{
			return TargetID;
		}
		public function selectObject(method){
			this.addEventListener(MouseEvent.MOUSE_DOWN, SELECT_OBJECT);
			SelectMethod = method;
		}
		private function SELECT_OBJECT(e:MouseEvent){
			SelectMethod(ID, TargetID);
		}
		public function clearContent(){
			try{
				contentSprite.removeChild(InputImg);
			}catch(e:TypeError){}
			catch(e:ArgumentError){}
			TargetID = -1;
		}
	}
}