package source.utils.DrawRectOnScene {
	import flash.display.Sprite;
	import source.DesignerMain;
	import flash.display.Stage;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.events.Event;

	public class SimpleDrawer extends Sprite{
		public static var DRAW_OBJECT:String = 'onDrawObject';
		
		private var typeRect:String = 'dotLine';
		
		private var STAGE:Stage;
		//private var STAGE:Sprite;
		private var selectSprite:Sprite = new Sprite();
		private var targetSprite:Sprite;
		private var rem_X:Number;
		private var rem_Y:Number;
		private var rem_W:Number;
		private var rem_H:Number;
		public function SimpleDrawer() {
			super();
		}
		public function set type(value:String):void{
			typeRect = value;
		}
		public function set target(value:Sprite):void{
			targetSprite = value;
		}
		public function selectObjects(event:MouseEvent):void{
			STAGE = DesignerMain.STAGE;
			STAGE.addChild(selectSprite);
			STAGE.addEventListener(MouseEvent.MOUSE_MOVE,STAGE_MOUSE_MOVE);
			STAGE.addEventListener(MouseEvent.MOUSE_UP,STAGE_MOUSE_UP);
			rem_X = GLOBAL_TO_LOCAL(event.localX,event.localY,event)[0];
			rem_Y = GLOBAL_TO_LOCAL(event.localX,event.localY,event)[1];
			//rem_X = event.localX;
			//rem_Y = event.localY;
			selectSprite.x = rem_X;
			selectSprite.y = rem_Y;
		}
		private function STAGE_MOUSE_MOVE(event:MouseEvent):void{
			selectSprite.graphics.clear();
			selectSprite.mouseEnabled = false;
			selectSprite.graphics.lineStyle(0.1,0x000000);
			var tekX:Number = GLOBAL_TO_LOCAL(event.localX,event.localY,event)[0] - rem_X;
			var tekY:Number = GLOBAL_TO_LOCAL(event.localX,event.localY,event)[1] - rem_Y;
			if(event.shiftKey){
				
				var obj:Object = getRectPosition(tekX, tekY, typeRect);
				tekX = obj.X;
				tekY = obj.Y;
			}
			drawFigure(tekX, tekY);
		}
		private function drawFigure(tekX:Number, tekY:Number):void{
			if(typeRect == 'line'){
				selectSprite.graphics.moveTo(0, 0);
				selectSprite.graphics.lineTo(tekX, tekY);
				return;
			}
			if(typeRect == 'dotLine'){
				drawLine(selectSprite,	0,		0,		Math.round(tekX/2),	0);
				drawLine(selectSprite,	tekX,	0,		Math.round(tekX/2),	0);
				drawLine(selectSprite,	tekX,	0,		tekX,				Math.round(tekY/2));
				drawLine(selectSprite,	tekX,	tekY,	tekX,				Math.round(tekY/2));
				drawLine(selectSprite,	tekX,	tekY,	Math.round(tekX/2),	tekY);
				drawLine(selectSprite,	0,		tekY,	Math.round(tekX/2),	tekY);
				drawLine(selectSprite,	0,		tekY,	0,					Math.round(tekY/2));
				drawLine(selectSprite,	0,		0,		0,					Math.round(tekY/2));
				return;
			}
			selectSprite.graphics.drawRect(0, 0, tekX, tekY);
		}
		private function STAGE_MOUSE_UP(event:MouseEvent):void{
			rem_W = selectSprite.width;
			rem_H = selectSprite.height;
			var tekX:Number;
			var tekY:Number;
			var obj:Object;
			if(typeRect!='line'){
				if(event.shiftKey){
					tekX = GLOBAL_TO_LOCAL(event.localX,event.localY,event)[0] - rem_X;
					tekY = GLOBAL_TO_LOCAL(event.localX,event.localY,event)[1] - rem_Y;
					obj = getRectPosition(tekX, tekY, typeRect);
					tekX = obj.X;
					tekY = obj.Y;
					tekX = rem_X + tekX;
					tekY = rem_Y + tekY;
				}else{
					tekX = GLOBAL_TO_LOCAL(event.localX,event.localY,event)[0];
					tekY = GLOBAL_TO_LOCAL(event.localX,event.localY,event)[1];
					
				}
				if(rem_X>tekX) rem_X = tekX;
				if(rem_Y>tekY) rem_Y = tekY;
			}else{
				rem_W = GLOBAL_TO_LOCAL(event.localX,event.localY,event)[0] - rem_X;
				rem_H = GLOBAL_TO_LOCAL(event.localX,event.localY,event)[1] - rem_Y;
				if(event.shiftKey){
					obj = getRectPosition(rem_W, rem_H, typeRect);
					rem_W = obj.X;
					rem_H = obj.Y;
				}
			}
			selectSprite.graphics.clear();
			STAGE.removeEventListener(MouseEvent.MOUSE_MOVE,STAGE_MOUSE_MOVE);
			STAGE.removeEventListener(MouseEvent.MOUSE_UP,STAGE_MOUSE_UP);
			STAGE.removeChild(selectSprite);
			if(typeRect!='line'){
				if(Math.abs(rem_W)<10 && Math.abs(rem_H)<10) return;
				if(Math.abs(rem_W)<5 || Math.abs(rem_H)<5) return;
			}
			var targetArr:Array = LOCAL_TO_GLOBAL(rem_X, rem_Y);
			rem_X = targetArr[0];
			rem_Y = targetArr[1];
			if(event.shiftKey){
				obj = getRectPosition(tekX, tekY, typeRect);
				tekX = obj.X;
				tekY = obj.Y;
			}
			super.dispatchEvent(new Event(DRAW_OBJECT));
		}
		public function get rectangle():Object{
			var outObject:Object = new Object;
			outObject.x = rem_X;
			outObject.y = rem_Y;
			outObject.width = rem_W;
			outObject.height = rem_H;
			return outObject;
		}
		private function GLOBAL_TO_LOCAL(_X:int,_Y:int, e:MouseEvent):Array{
			var arr:Array = new Array(2);
			var localPoint:Point = new Point(_X,_Y);
			var globalPoint:Point = e.target.localToGlobal(localPoint);
			arr[0] = globalPoint.x;
			arr[1] = globalPoint.y;
			return arr;
		}
		private function LOCAL_TO_GLOBAL(_X:int, _Y:int):Array{
			var globalPoint:Point = new Point(_X,_Y);
			var localPoint:Point = targetSprite.globalToLocal(globalPoint);
			var arr:Array = new Array();
			arr.push(localPoint.x);
			arr.push(localPoint.y);
			return arr;
		}
		private function drawLine (Spr:Sprite, _X1:int, _Y1:int, _X2:int, _Y2:int):void{
			var tek_X:int = _X1;
			var tek_Y:int = _Y1;
			var L:Number = Math.sqrt((_X2 - _X1)*(_X2 - _X1) + (_Y2 - _Y1)*(_Y2 - _Y1));
			var numStep:int = Math.round(L/4);
			var stepX:int = Math.round((_X2 - _X1)/numStep);
			var stepY:int = Math.round((_Y2 - _Y1)/numStep);
			var i:int;
			numStep = Math.round(numStep/2);
			for(i=0;i<numStep;i++){
				Spr.graphics.moveTo(tek_X, tek_Y);
				tek_X += stepX;
				tek_Y += stepY;
				Spr.graphics.lineTo(tek_X, tek_Y);
				tek_X += stepX;
				tek_Y += stepY;
			}
		}
		
		
		
		private function getRectPosition(X:Number, Y:Number, type:String):Object{
			var outObject:Object = new Object();
			var outX:Number;
			var outY:Number;
			if(typeRect == 'line'){
				if(X>=0 && Y>=0){
					if(Math.abs(X-Y)<Math.min(X, Y)){
						if(X>Y){
							outY = Y;
							outX = Y;
						}else{
							outY = X;
							outX = X;
						}
					}else{
						if(Y>X){
							outY = Y;
							outX = 0;
						}else{
							outY = 0;
							outX = X;
						}
					}
					outObject.X = outX;
					outObject.Y = outY;
					return outObject;
				}
				if(X>=0 && Y<0){
					if(Math.abs(X-Math.abs(Y))<Math.min(X, Math.abs(Y))){
						if(X>Math.abs(Y)){
							outY = -X;
							outX = X;
						}else{
							outY = Y;
							outX = -Y;
						}
					}else{
						if(X>Math.abs(Y)){
							outY = 0;
							outX = X;
						}else{
							outY = Y;
							outX = 0;
						}
					}
					outObject.X = outX;
					outObject.Y = outY;
					return outObject;
				}
				if(X<0 && Y>=0){
					if(Math.abs(Math.abs(X)-Y)<Math.min(Math.abs(X), Y)){
						if(Math.abs(X)>Y){
							outY = -X;
							outX = X;
						}else{
							outY = Y;
							outX = -Y;
						}
					}else{
						if(Y>Math.abs(X)){
							outY = Y;
							outX = 0;
						}else{
							outY = 0;
							outX = X;
						}
					}
					outObject.X = outX;
					outObject.Y = outY;
					return outObject;
				}
				if(X<0 && Y<0){
					if(Math.abs(Math.abs(X)-Math.abs(Y))<Math.min(Math.abs(X), Math.abs(Y))){
						if(Math.abs(X)>Math.abs(Y)){
							outY = Y;
							outX = Y;
						}else{
							outY = X;
							outX = X;
						}
					}else{
						if(Math.abs(Y)>Math.abs(X)){
							outY = Y;
							outX = 0;
						}else{
							outY = 0;
							outX = X;
						}
					}
					outObject.X = outX;
					outObject.Y = outY;
					return outObject;
				}
				
				
				if(Math.abs(Math.abs(X)-Math.abs(Y))<Math.min(Math.abs(X), Math.abs(Y))/2){
					if(Math.abs(Y)>Math.abs(X)){
						outY = Y;
						outX = Y;
					}
					else {
						outX = X;
						outY = X;
					}
				}else{
					if(Math.abs(Y)>Math.abs(X)) {
						outY = Y;
						outX = 0;
					}
					else {
						outX = X;
						outY = 0;
					}
				}
			}else{
				if((X>=0 && Y>=0)||(X<0 && Y<0)){
					if(Math.abs(Y)>Math.abs(X)){
						outY = Y;
						outX = Y;
					}
					else {
						outX = X;
						outY = X;
					}
					outObject.X = outX;
					outObject.Y = outY;
					return outObject;
				}
				if(X>=0 && Y<0){
					if(Math.abs(Y)>X){
						outY = Y;
						outX = -Y;
					}else{
						outX = X;
						outY = -X;
					}
					outObject.X = outX;
					outObject.Y = outY;
					return outObject;
				}
				if(X<0 && Y>=0){
					if(Y>Math.abs(X)){
						outY = Y;
						outX = -Y;
					}else{
						outX = X;
						outY = -X;
					}
					outObject.X = outX;
					outObject.Y = outY;
					return outObject;
				}
			}
			outObject.X = outX;
			outObject.Y = outY;
			return outObject;
		}
	}
	
}
