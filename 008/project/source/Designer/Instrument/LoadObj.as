package source.Designer.Instrument {
import flash.display.Loader;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
import flash.system.LoaderContext;

public class LoadObj extends Sprite{
		private var ID:int;
		private var loadImg;
		private var WIDTH:Number;
		private var HEIGHT:Number;
		private var fileName:String = "";
		private var contentSprite:Sprite = new Sprite;
		private var functionalSprite:Sprite = new Sprite;
		private var CONTENT;
		private var IMG:Bitmap;
		public function LoadObj(_W:Number, _H:Number, _id:int) {
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
			loadImg.addEventListener(MouseEvent.MOUSE_DOWN, loadImg_Mouse_Down);
		}
		private function loadImg_Mouse_Down(e:MouseEvent){
			new LoadFiles(LoadContent);
		}
		public function LoadContent(e, NAME:String){
			fileName = NAME;
			CONTENT = e;
            try{
                IMG = BitmapCopy();
                contentSprite.addChild(IMG);
                IMG.height = HEIGHT;
                IMG.width = WIDTH;
            }catch(e:Error){
                trace(e.getStackTrace());
            }
		}


		public function BitmapCopy():Bitmap{
			var image:Bitmap = new Bitmap(CONTENT);
			var copyImg:BitmapData = new BitmapData(CONTENT.width, CONTENT.height,true,0xffffffff);
			copyImg.draw(image,new Matrix());
			var outImage:Bitmap = new Bitmap(copyImg);
			return outImage;
		}
		public function getContent():Boolean{
			var flag:Boolean = false;
			if(CONTENT!=null && CONTENT!=undefined){
				flag = true;
			}
			return flag;
		}
		public function clearContent(){
			try{
				contentSprite.removeChild(IMG);
			}catch(e:TypeError){}
			catch(e:ArgumentError){}
		}
		public function getFileName():String{
			return fileName;
		}
	}
	
}