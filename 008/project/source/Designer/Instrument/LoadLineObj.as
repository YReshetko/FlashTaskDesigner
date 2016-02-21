package source.Designer.Instrument {
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	public class LoadLineObj extends Sprite {
		private var ID:int;
		private var loadImg;
		public var pointC;
		private var WIDTH:Number;
		private var HEIGHT:Number;
		private var fileName:String = "";
		private var contentSprite:Sprite = new Sprite;
		private var functionalSprite:Sprite = new Sprite;
		private var CONTENT;
		private var IMG:Bitmap;
		private var OverMethod;
		private var OutMethod;
		public function LoadLineObj(_W:Number, _H:Number, _id:int) {
			ID = _id;
			WIDTH =_W;
			HEIGHT = _H;
			this.graphics.lineStyle(1,0x000000,0);
			this.graphics.beginFill(0x666666);
			this.graphics.drawRect(0,0,_W,_H);
			this.graphics.endFill();
			this.addChild(contentSprite)
			this.addChild(functionalSprite);
			loadImg = new AddImgModul();
			loadImg.x = 1;
			loadImg.y = 1;
			functionalSprite.addChild(loadImg);
			pointC = new AddPoinModul();
			setPoint();
			loadImg.addEventListener(MouseEvent.MOUSE_DOWN, loadImg_Mouse_Down);
		}
		public function setPoint(){
			functionalSprite.addChild(pointC);
			pointC.x = WIDTH/2;
			pointC.y = HEIGHT/2;
		}
		private function loadImg_Mouse_Down(e:MouseEvent){
			new LoadFiles(LoadContent);
		}
		public function LoadContent(e, NAME:String){
			fileName = NAME;
			CONTENT = e;
			IMG = BitmapCopy();
			contentSprite.addChild(IMG);
			IMG.height = HEIGHT;
			IMG.width = WIDTH;
		}
		public function BitmapCopy():Bitmap{
			var image:Bitmap = Bitmap(CONTENT);
			var copyImg:BitmapData = new BitmapData(CONTENT.width, CONTENT.height,true,0xffffffff);
			copyImg.draw(image,new Matrix());
			var outImage:Bitmap = new Bitmap(copyImg);
			return outImage;
		}
		public function startFunction(method1, method2){
			OverMethod = method1;
			OutMethod = method2
			pointC.addEventListener(MouseEvent.MOUSE_DOWN, POINT_MOUSE_DOWN);
			pointC.addEventListener(MouseEvent.MOUSE_UP, POINT_MOUSE_UP);
			
		}
		private function POINT_MOUSE_DOWN(e:MouseEvent){
			if(CONTENT!=null && CONTENT!=undefined){
				OverMethod(ID, pointC);
			}
		}
		private function POINT_MOUSE_UP(e:MouseEvent){
			if(CONTENT!=null && CONTENT!=undefined){
				OutMethod(ID, pointC);
			}
		}
		public function getFileName():String{
			return fileName;
		}
		public function clearContent(){
			try{
				contentSprite.removeChild(IMG);
			}catch(e:TypeError){}
			catch(e:ArgumentError){}
		}
	}
}