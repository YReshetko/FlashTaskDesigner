package source.utils {
	import flash.display.Sprite;
	import flash.display.LineScaleMode;
	
	public class Figure {
		public static function returnRect(w:int, h:int, lineThick:int = 1, lineAlpha:Number = 1, lineColor:uint = 0x000000, fillAlpha:Number = 1, fillColor:uint = 0xD6D6D6):Sprite{
			var outSprite:Sprite = new Sprite();
			outSprite.graphics.lineStyle(lineThick, lineColor, lineAlpha, false, LineScaleMode.NONE);
			outSprite.graphics.beginFill(fillColor, fillAlpha);
			outSprite.graphics.drawRect(0, 0, w, h);
			outSprite.graphics.endFill();
			return outSprite;
		}
		public static function insertRect(inSprite:Sprite, w:int, h:int, lineThick:int = 1, lineAlpha:Number = 1, lineColor:uint = 0x000000, fillAlpha:Number = 1, fillColor:uint = 0xD6D6D6):void{
			inSprite.graphics.clear();
			inSprite.graphics.lineStyle(lineThick, lineColor, lineAlpha, false, LineScaleMode.NONE);
			inSprite.graphics.beginFill(fillColor, fillAlpha);
			inSprite.graphics.drawRect(0, 0, w, h);
			inSprite.graphics.endFill();
		}
		public static function returnLine(x1:int, y1:int, x2:int, y2:int, lineAlpha:Number = 1, lineThick:int = 1, lineColor:uint = 0x000000):Sprite{
			var outSprite:Sprite = new Sprite()
			outSprite.graphics.lineStyle(lineThick, lineColor, lineAlpha, false, LineScaleMode.NONE);
			outSprite.graphics.moveTo(x1, y1);
			outSprite.graphics.lineTo(x2, y2);
			return outSprite;
		}
		public static function insertLine(inSprite:Sprite, x1:int, y1:int, x2:int, y2:int, lineAlpha:Number = 1, lineThick:int = 1, lineColor:uint = 0x000000):void{
			inSprite.graphics.lineStyle(lineThick, lineColor, lineAlpha);
			inSprite.graphics.moveTo(x1, y1);
			inSprite.graphics.lineTo(x2, y2);
		}
		public static function insertCurve(inSprite:Sprite, pointArr:Array, lineAlpha:Number = 1, lineThick:int = 1, lineColor:uint = 0x000000, fillAlpha:Number = 1, fillColor:uint = 0xD6D6D6):void{
			var i:int;
			var leng:int = pointArr.length;
			inSprite.graphics.lineStyle(lineThick, lineColor, lineAlpha, false, LineScaleMode.NONE);
			inSprite.graphics.beginFill(fillColor, fillAlpha);
			inSprite.graphics.moveTo(pointArr[0][0], pointArr[0][1]);
			if(pointArr[0].length == 2){
				for(i=1;i<leng;i++){
					inSprite.graphics.lineTo(pointArr[i][0], pointArr[i][1]);
				}
			}
			if(pointArr[0].length == 4){
				for(i=1;i<leng;i++){
					inSprite.graphics.curveTo(pointArr[i][2], pointArr[i][3], pointArr[i][0], pointArr[i][1]);
				}
			}
			inSprite.graphics.endFill();
		}
		public static function insertCurveWithoutFill(inSprite:Sprite, pointArr:Array, lineAlpha:Number = 1, lineThick:int = 1, lineColor:uint = 0x000000):void{
			var i:int;
			var leng:int = pointArr.length;
			inSprite.graphics.lineStyle(lineThick, lineColor, lineAlpha, false, LineScaleMode.NONE);
			inSprite.graphics.moveTo(pointArr[0][0], pointArr[0][1]);
			if(pointArr[0].length == 2){
				for(i=1;i<leng;i++){
					inSprite.graphics.lineTo(pointArr[i][0], pointArr[i][1]);
				}
			}
			if(pointArr[0].length == 4){
				for(i=1;i<leng;i++){
					inSprite.graphics.curveTo(pointArr[i][2], pointArr[i][3], pointArr[i][0], pointArr[i][1]);
				}
			}
		}
		public static function insertCircle(inSprite:Sprite, radius:Number, lineAlpha:Number = 1, lineThick:int = 1, lineColor:uint = 0x000000, fillAlpha:Number = 1, fillColor:uint = 0xD6D6D6):void{
			inSprite.graphics.lineStyle(lineThick, lineColor, lineAlpha, false, LineScaleMode.NONE);
			inSprite.graphics.beginFill(fillColor, fillAlpha);
			inSprite.graphics.drawCircle(0, 0, radius);
			inSprite.graphics.endFill();
		}
		
		public static function drawGreed(inSprite:Sprite, size:Number, w:Number, h:Number, lineAlpha:Number = 1, lineThick:Number = 0.1, lineColor:uint = 0x000000):void{
			inSprite.graphics.clear();
			inSprite.graphics.lineStyle(lineThick, lineColor, lineAlpha, false, LineScaleMode.NONE);
			var column:int;
			var line:int;
			column = Math.ceil(w/size);
			line = Math.ceil(h/size);
			var i:int;
			for(i=0;i<column;i++){
				inSprite.graphics.moveTo(i*size, 0);
				inSprite.graphics.lineTo(i*size, h);
			}
			for(i=0;i<line;i++){
				inSprite.graphics.moveTo(0, i*size);
				inSprite.graphics.lineTo(w, i*size);
			}
		}
	}
	
}
