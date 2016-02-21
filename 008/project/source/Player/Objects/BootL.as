package source.Player.Objects {
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.utils.ByteArray;

	public class BootL extends Sprite {
		private var imgSprite:Sprite = new Sprite;
		private var functSprite:Sprite = new Sprite;
		private var WIDTH:int;
		private var HEIGHT:int;
		private var ID:int;
		private var image:Bitmap;
		private var CONTENT;
		public function BootL(_W:int, _H:int, _id:int) {
			WIDTH = _W;
			HEIGHT = _H;
			ID = _id;
			this.addChild(imgSprite);
		}
		public function loadContent(value:ByteArray){
			new LoadFile(value, loadComplate);
		}
		public function loadComplate(e){
			CONTENT = e;
			image = Bitmap(CONTENT);
			var copyIMG1:BitmapData = new BitmapData(image.width, image.height, true, 0xffffffff);
			var copyIMG2:BitmapData = new BitmapData(image.width, image.height, true, 0xffffffff);
			copyIMG1.draw(image,new Matrix());
			copyIMG2.draw(image,new Matrix());
			var image1:Bitmap = new Bitmap(copyIMG1);
			var image2:Bitmap = new Bitmap(copyIMG2);
			imgSprite.addChild(image1);
			functSprite.addChild(image2);
			image1.width = WIDTH;
			image1.height = HEIGHT;
			image2.width = WIDTH;
			image2.height = HEIGHT;
		}
		public function getSpriteIMG():Sprite{
			return functSprite;
		}
	}
	
}