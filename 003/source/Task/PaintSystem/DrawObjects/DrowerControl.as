package source.Task.PaintSystem.DrawObjects {
	import flash.display.Sprite;
	import flash.display.LineScaleMode;
	import source.utils.Figure;
	import flash.events.Event;
	
	public class DrowerControl extends Sprite{
		
		public static var SELECT_POINT:String = 'onSelectPoint';
		public static var SELECT_ANHOR:String = 'onSelectAnhor';
		
		private var arrPoint:Array = new Array();
		private var pointObject:Array = new Array();
		private var anhorObject:Array = new Array();
		
		private var isEnabled:Boolean = false;
		
		private var remPoint:POINT;
		private var remAnhor:ANHOR;
		private var currentScale:Number = 1;
		public function DrowerControl(inSprite:Sprite) {
			super();
			inSprite.addChild(super);
		}
		public function get array():Array{
			return arrPoint;
		}
		public function removeFigure():void{
			this.clear();
			while(arrPoint.length>0){
				arrPoint.shift();
			}
			super.graphics.clear();
		}
		public function addNewPoint(x:Number, y:Number):void{
			if(arrPoint.length == 0){
				arrPoint.push([x, y, 0, 0]);
			}else{
				var id:int = arrPoint.length;
				var jX:Number = arrPoint[id-1][0] + (x - arrPoint[id-1][0])/2
				var jY:Number = arrPoint[id-1][1] + (y - arrPoint[id-1][1])/2
				arrPoint.push([x, y, jX, jY]);
			}
			drawFigure();
			addObjectPoint();
		}
		public function set points(value:Array):void{
			clear();
			while(arrPoint.length>0)arrPoint.shift();
			arrPoint = value;
			drawFigure();
			addObjectPoint();
		}
		private function drawFigure():void{
			super.graphics.clear();
			super.graphics.lineStyle(2, 0x000000, 1, false, LineScaleMode.NONE);
			super.graphics.moveTo(arrPoint[0][0], arrPoint[0][1]);
			var i:int;
			var l:int;
			l = arrPoint.length;
			for(i=1;i<l;i++){
				super.graphics.curveTo(arrPoint[i][2], arrPoint[i][3], arrPoint[i][0], arrPoint[i][1]);
			}
		}
		private function addObjectPoint():void{
			clear();
			var i:int;
			var l:int;
			l = arrPoint.length;
			for(i=0;i<l;i++){
				pointObject.push(new POINT());
				super.addChild(pointObject[i]);
				pointObject[i].x = arrPoint[i][0];
				pointObject[i].y = arrPoint[i][1];
				pointObject[i].ID = i;
				pointObject[i].scaleX = pointObject[i].scaleY = this.currentScale;
				pointObject[i].addEventListener(POINT.POINT_MOUSE_DOWN, POINT_MOUSE_DOWN);
				pointObject[i].addEventListener(POINT.REMOVE_POINT, POINT_REMOVE);
				if(i!=0){
					anhorObject.push(new ANHOR());
					super.addChild(anhorObject[i-1]);
					anhorObject[i-1].addEventListener(ANHOR.ANHOR_MOUSE_DOWN, ANHOR_MOUSE_DOWN);
					anhorObject[i-1].ID = i;
					anhorObject[i-1].scaleX = anhorObject[i-1].scaleY = this.currentScale;
				}
			}
			replaceAnhor();
			enabled = isEnabled;
		}
		private function replaceAnhor():void{
			var i:int;
			var l:int;
			l = arrPoint.length;
			for(i=0;i<l;i++){
				if(i!=0){
					anhorObject[i-1].x = arrPoint[i][2];
					anhorObject[i-1].y = arrPoint[i][3];
				}
			}
		}
		public function set enabled(value:Boolean):void{
			isEnabled = value;
			var i:int;
			var l:int;
			l = pointObject.length;
			for(i=0;i<l;i++){
				pointObject[i].visible = isEnabled;
			}
			l = anhorObject.length;
			for(i=0;i<l;i++){
				anhorObject[i].visible = isEnabled;
			}
		}
		public function get enabled():Boolean{
			return isEnabled;
		}
		private function clear():void{
			while(pointObject.length>0){
				pointObject[0].removeEventListener(POINT.POINT_MOUSE_DOWN, POINT_MOUSE_DOWN);
				pointObject[0].removeEventListener(POINT.REMOVE_POINT, POINT_REMOVE);
				super.removeChild(pointObject[0]);
				pointObject.shift();
			}
			while(anhorObject.length>0){
				anhorObject[0].removeEventListener(ANHOR.ANHOR_MOUSE_DOWN, ANHOR_MOUSE_DOWN);
				super.removeChild(anhorObject[0]);
				anhorObject.shift();
			}
		}
		private function allPointDeselect():void{
			var i:int;
			var l:int;
			l = pointObject.length;
			for(i=0;i<l;i++){
				pointObject[i].select = false;
			}
			l = anhorObject.length;
			for(i=0;i<l;i++){
				anhorObject[i].select = false;
			}
		}
		private function POINT_MOUSE_DOWN(e:Event):void{
			allPointDeselect();
			remPoint = e.target as POINT;
			e.target.select = true;
			super.setChildIndex(remPoint, super.numChildren-1);
			super.dispatchEvent(new Event(SELECT_POINT));
		}
		private function POINT_REMOVE(event:Event):void{
			var ID:int = event.target.ID;
			var flag:Boolean = true;
			if(ID<1||ID>=anhorObject.length-1 && pointObject.length>2) flag = false;
			pointObject[ID].removeEventListener(POINT.POINT_MOUSE_DOWN, POINT_MOUSE_DOWN);
			pointObject[ID].removeEventListener(POINT.REMOVE_POINT, POINT_REMOVE);
			super.removeChild(pointObject[ID]);
			arrPoint.splice(ID, 1);
			pointObject.splice(ID, 1);
			if(anhorObject.length!=0 && ID<anhorObject.length) {
				anhorObject[ID].removeEventListener(ANHOR.ANHOR_MOUSE_DOWN, ANHOR_MOUSE_DOWN);
				super.removeChild(anhorObject[ID]);
				anhorObject.splice(ID, 1);
			}
			else {
				if(ID >= anhorObject.length && ID!=0) {
					anhorObject[ID-1].removeEventListener(ANHOR.ANHOR_MOUSE_DOWN, ANHOR_MOUSE_DOWN);
					super.removeChild(anhorObject[ID-1]);
					anhorObject.splice(ID-1, 1);
				}
			}
			var i:int;
			var l:int;
			l = pointObject.length;
			for(i=0;i<l;i++){
				pointObject[i].ID = i;
			}
			l = anhorObject.length;
			for(i=0;i<l;i++){
				anhorObject[i].ID = i+1;
			}
			if(flag){
				arrPoint[ID][2] = anhorObject[ID-1].x = pointObject[ID-1].x + (pointObject[ID].x - pointObject[ID-1].x)/2;
				arrPoint[ID][3] = anhorObject[ID-1].y = pointObject[ID-1].y + (pointObject[ID].y - pointObject[ID-1].y)/2;
				anhorObject[ID-1].select = true;
			}
			if(pointObject.length>1) {
				remPoint = pointObject[0];
				redrawFromPoint();
				enabled = true;
			}else{
				super.graphics.clear();
			}
		}
		private function ANHOR_MOUSE_DOWN(e:Event):void{
			allPointDeselect();
			remAnhor = e.target as ANHOR;
			e.target.select = true;
			super.setChildIndex(remAnhor, super.numChildren-1);
			super.dispatchEvent(new Event(SELECT_ANHOR));
		}
		public function get point():POINT{
			return remPoint;
		}
		public function get anhor():ANHOR{
			return remAnhor;
		}
		public function redrawFromPoint():void{
			var id:int = remPoint.ID;
			var leftFlag:Boolean = false;
			var rightFlag:Boolean = false;
			if(arrPoint.length==1){
				arrPoint[0][0] = remPoint.x;
				arrPoint[0][1] = remPoint.y;
				return;
			}
			if(id == 0){
				if(Math.abs(arrPoint[id+1][2]-(arrPoint[id][0] + (arrPoint[id+1][0] - arrPoint[id][0])/2))<5&&
				   Math.abs(arrPoint[id+1][3]-(arrPoint[id][1] + (arrPoint[id+1][1] - arrPoint[id][1])/2))<5){
					   rightFlag = true;
				   }
			}
			if(id == pointObject.length-1){
				if(Math.abs(arrPoint[id][2]-(arrPoint[id-1][0] + (arrPoint[id][0] - arrPoint[id-1][0])/2))<5&&
				   Math.abs(arrPoint[id][3]-(arrPoint[id-1][1] + (arrPoint[id][1] - arrPoint[id-1][1])/2))<5){
					   leftFlag = true;
				   }
			}
			if(id>0 && id<pointObject.length-1){
				if(Math.abs(arrPoint[id+1][2]-(arrPoint[id][0] + (arrPoint[id+1][0] - arrPoint[id][0])/2))<5&&
				   Math.abs(arrPoint[id+1][3]-(arrPoint[id][1] + (arrPoint[id+1][1] - arrPoint[id][1])/2))<5){
					   rightFlag = true;
				   }
				if(Math.abs(arrPoint[id][2]-(arrPoint[id-1][0] + (arrPoint[id][0] - arrPoint[id-1][0])/2))<5&&
				   Math.abs(arrPoint[id][3]-(arrPoint[id-1][1] + (arrPoint[id][1] - arrPoint[id-1][1])/2))<5){
					   leftFlag = true;
				   }
			}
			arrPoint[id][0] = remPoint.x;
			arrPoint[id][1] = remPoint.y;
			if(leftFlag){
				arrPoint[id][2] = arrPoint[id-1][0] + (arrPoint[id][0] - arrPoint[id-1][0])/2;
				arrPoint[id][3] = arrPoint[id-1][1] + (arrPoint[id][1] - arrPoint[id-1][1])/2;
			}
			if(rightFlag){
				arrPoint[id+1][2] = arrPoint[id][0] + (arrPoint[id+1][0] - arrPoint[id][0])/2;
				arrPoint[id+1][3] = arrPoint[id][1] + (arrPoint[id+1][1] - arrPoint[id][1])/2;
			}
			drawFigure();
			replaceAnhor();
		}
		public function redrawFromAnhor():void{
			var id:int = remAnhor.ID;
			arrPoint[id][2] = remAnhor.x;
			arrPoint[id][3] = remAnhor.y;
			drawFigure();
		}
		public function set scale(value:Number):void{
			currentScale = value;
			var i:int;
			var l:int;
			l = this.pointObject.length;
			for(i=0;i<l;i++){
				this.pointObject[i].scaleX = value;
				this.pointObject[i].scaleY = value;
			}
			l = this.anhorObject.length;
			for(i=0;i<l;i++){
				this.anhorObject[i].scaleX = value;
				this.anhorObject[i].scaleY = value;
			}
		}
	}
	
}
