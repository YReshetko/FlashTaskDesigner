package source.Utilites {
	import flash.display.BitmapData;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.geom.Point;
	
	public class CuterPict {

		public static function cutPict(bmpData:BitmapData, numCol:int, numLin:int):Array{
			var image:Bitmap = new Bitmap(bmpData);
			var currentRect:Rectangle;
			var currentPoint:Point = new Point(0,0);
			var wCut = image.width/numCol;
			var hCut = image.height/numLin;
			var conturSprite:Sprite = ramkaSprite(wCut, hCut);
			var arrBitmap:Array = new Array;
			var i,j,l,m,ID:int;
			for(i=0;i<numCol;i++){
				for(j=0;j<numLin;j++){
					currentRect = new Rectangle(i*wCut, j*hCut, wCut, hCut);
					arrBitmap.push(new BitmapData(wCut, hCut, true, 0xFFFFFFFF));
					ID = arrBitmap.length-1;
					arrBitmap[ID].copyPixels(bmpData, currentRect, currentPoint);
					arrBitmap[ID].draw(conturSprite);
				}
			}
			return arrBitmap;
		}
		private static function ramkaSprite(w:int, h:int):Sprite{
			var spr:Sprite = new Sprite;
			spr.graphics.lineStyle(1,0x000000,0);
			spr.graphics.beginFill(0x000000,1);
			spr.graphics.drawRect(0,0,w,1);
			spr.graphics.drawRect(w-1,0,1,h);
			spr.graphics.drawRect(0,h-1,w,1);
			spr.graphics.drawRect(0,0,1,h);
			spr.graphics.endFill();
			return spr;
		}

	}
	
}
