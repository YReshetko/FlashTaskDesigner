package source.Designer.Instrument {
	import flash.display.Sprite;
	import flash.display.Bitmap;
	public class SimpleObj extends Sprite{
		private var ID:int;
		private var WIDTH:Number;
		private var HEIGHT:Number;
		private var objSprite:Sprite = new Sprite;
		private var Image:Bitmap;
		public function SimpleObj(_W:Number, _H:Number, _id:int) {
			ID = _id;
			WIDTH =_W;
			HEIGHT = _H;
			this.graphics.lineStyle(1,0x000000,1);
			this.graphics.beginFill(0x666666);
			this.graphics.drawRect(0,0,_W,_H);
			this.graphics.endFill();
			this.addChild(objSprite);
		}
		public function setContent(img:Bitmap){
			Image = img;
			objSprite.addChild(Image);
			Image.width = WIDTH;
			Image.height = HEIGHT;
		}
		public function clearContent(){
			try{
				objSprite.removeChild(Image);
			}catch(e:TypeError){}
			catch(e:ArgumentError){}
		}
	}
}