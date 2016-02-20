package source.Task {
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import source.DesignerMain;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import flash.geom.Rectangle;
	import source.utils.Figure;
	
	public class InitLayers extends Sprite {
		public static var RESIZE_SELECT:String = 'onResizeSelect';
		public static var COPY_SELECTED_PACK:String = 'onCopySelectedPack';
		public static var DELETE_SELECTED_PACK:String = 'onDeleteSelectedPack';
		public static var GET_OBJECTS_SETTINGS:String = 'onGetObjectsSettings';
		private var layerArray:Array = new Array([new Sprite,	"Панель рисования",			22],
												 [new Sprite,	"Координатная плоскость",	21],
												 [new Sprite,	"Поля перестановки",		20],
												 [new Sprite,	"Кнопки",					19],
												 [new Sprite,	"Групповое поле (Ч)",		18],
												 [new Sprite,	"Групповое поле (Ц)",		17],
												 [new Sprite,	"Компл. таны (Ч)",			1],
												 [new Sprite,	"Картинки таны (Ч)",		2],
												 [new Sprite,	"Польз. таны (Ч)",			3],
												 [new Sprite,	"SWF таны (Ч)",				14],
												 [new Sprite,	"Таблицы",					4],
												 [new Sprite,	"Линии",					5],
												 [new Sprite,	"Надписи",					6],
												 [new Sprite,	"Перечисл. поля",			7],
												 [new Sprite,	"Выбор ответов",			16],
												 [new Sprite,	"Точки соединения",			8],
												 [new Sprite,	"Компл. таны (Ц)",			9],
												 [new Sprite,	"Картинки таны (Ц)",		10],
												 [new Sprite,	"Польз. таны (Ц)",			11],
												 [new Sprite,	"SWF таны (Ц)",				15],
												 [new Sprite,	"Области выделения",		12],
												 [new Sprite,	"SWF объекты",				13],
												 [new Sprite,	"ЧЯРис",					23]);
		public var palitraContainer:Sprite = new Sprite();
		public var brushContainer:Sprite = new Sprite(); 
		public var dragContainer:Sprite = new Sprite();
		public function InitLayers() {
			super();
			setAllSprite();
			dragContainer.addEventListener(MouseEvent.MOUSE_DOWN, DRAG_MOUSE_DOWN);
			super.mouseEnabled = false;
		}
		public function setAllSprite():void{
			var i:int;
			super.addChild(palitraContainer);
			for(i=0;i<layerArray.length;i++){
				super.addChild(layerArray[i][0]);
			}
			super.addChild(brushContainer);
			
			super.addChild(dragContainer);
		}
		public function removeAllSprite():void{
			var i:int;
			for(i=0;i<layerArray.length;i++){
				super.removeChild(layerArray[i][0]);
			}
		}
		public function clearAllSprite():void{
			var i:int;
			for(i=0;i<layerArray.length;i++){
				while(layerArray[i][0].numChildren>0){
					layerArray[i][0].removeChildAt(0);
				}
			}
		}
		public function getLayerArray():Array{
			return layerArray;
		}
		public function getNamedSprite(s:String):Sprite{
			var i:int;
			for(i=0;i<layerArray.length;i++){
				if(layerArray[i][1] == s){
					return layerArray[i][0];
				}
			}
			return null;
		}
		public function getLayerSettings():String{
			var s:String = "";
			var i:int;
			for(i=0;i<layerArray.length;i++){
				s += layerArray[i][2]+",";
			}
			s = s.substring(0,s.length-1);
			return s;
		}
		public function setLinkArray(str:String):void{
			var arr:Array = str.substring(str.indexOf("(")+1, str.lastIndexOf(")")).split(",");
			//trace(arr);
			this.linkArray = arr;
			/*var promArr:Array;
			var i,j:int;
			for(i=0;i<arr.length;i++){
				promArr = new Array();
				for(j=0;j<layerArray.length;j++){
					if(layerArray[j][2] == arr[i]){
						promArr = layerArray[j];
						layerArray.splice(j,1);
					}
				}
				//trace(promArr);
				if(promArr.length!=0){
					layerArray.splice(i,0,promArr);
				}
			}
			setAllSprite();*/
		}
		public function set linkArray(value:Array):void{
			var arr:Array = value;
			var promArr:Array;
			var i:int;
			var j:int;
			for(i=0;i<arr.length;i++){
				promArr = new Array();
				for(j=0;j<layerArray.length;j++){
					if(layerArray[j][2] == arr[i]){
						promArr = layerArray[j];
						layerArray.splice(j,1);
					}
				}
				//trace(promArr);
				if(promArr.length!=0){
					layerArray.splice(i,0,promArr);
				}
			}
			setAllSprite();
		}
		private function DRAG_MOUSE_DOWN(event:MouseEvent):void{
			//trace(this + ': SELECT START DRAG')
			var i:int;
			var l:int;
			l = pointSelected.length;
			for(i=0;i<l;i++){
				if(event.target == pointSelected[i]) return;
			}
			DesignerMain.STAGE.addEventListener(MouseEvent.MOUSE_UP, DRAG_MOUSE_UP);
			dragContainer.startDrag();
			dragContainer.focusRect = false;
			//DesignerMain.STAGE.focus = dragContainer;
			dragContainer.addEventListener(KeyboardEvent.KEY_DOWN, SELECTED_KEY_DOWN);
			super.dispatchEvent(new Event(GET_OBJECTS_SETTINGS));
		}
		private function DRAG_MOUSE_UP(event:MouseEvent):void{
			dragContainer.stopDrag();
			DesignerMain.STAGE.removeEventListener(MouseEvent.MOUSE_UP, DRAG_MOUSE_UP);
			var X:Number = dragContainer.x;
			var Y:Number = dragContainer.y;
			dragContainer.x = dragContainer.y = 0;
			var i:int;
			var l:int;
			l = dragContainer.numChildren;
			for(i=0;i<l;i++){
				dragContainer.getChildAt(i).x += X;
				dragContainer.getChildAt(i).y += Y;
			}
		}
		private function SELECTED_KEY_DOWN(event:KeyboardEvent):void{
			if(event.keyCode == Keyboard.C){
				if(event.ctrlKey) super.dispatchEvent(new Event(COPY_SELECTED_PACK));
			}
			if(event.keyCode == Keyboard.DELETE){
				super.dispatchEvent(new Event(DELETE_SELECTED_PACK));
			}
		}
		
		private var selected:Sprite = new Sprite();
		private var pointSelected:Array = new Array();
		private var oldRect:Rectangle;
		private var remTarget:Sprite;
		private var deltaRect:Object;
		public function drawSelect():void{
			removeSelect();
			var rect:Rectangle = dragContainer.getBounds(dragContainer);
			oldRect = new Rectangle();
			oldRect.x = rect.x - 2;
			oldRect.y = rect.y - 2;
			oldRect.width = rect.width + 4;
			oldRect.height = rect.height + 4;
			Figure.insertRect(selected, rect.width+4, rect.height+4, 0.1, 0.3, 0x000000, 0);
			var xArr:Array = [0, selected.width];
			var yArr:Array = [0, selected.height];
			var posArr:Array = new Array();
			var i:int;
			var l:int;
			var j:int;
			for(i=0;i<2;i++){
				for(j=0;j<2;j++){
					posArr.push({'x':xArr[i], 'y':yArr[j]});
				}
			}
			l = posArr.length;
			var spr:Sprite;
			var pushSpr:Sprite;
			for(i=0;i<l;i++){
				spr = new Sprite;
				pushSpr = new Sprite;
				Figure.insertRect(spr, 12, 12, 0.1);
				pushSpr.addChild(spr);
				spr.x = spr.y = -6;
				pointSelected.push(pushSpr);
				selected.addChild(pointSelected[i]);
				pushSpr.x = posArr[i].x;
				pushSpr.y = posArr[i].y;
				pushSpr.mouseChildren = false;
				
				
			}
			pointSelected[3].addEventListener(MouseEvent.MOUSE_DOWN, POINT_MOUSE_DOWN);
			dragContainer.addChild(selected);
			selected.x = rect.x-2;
			selected.y = rect.y-2;
		}
		private function POINT_MOUSE_DOWN(event:MouseEvent):void{
			remTarget = event.target as Sprite;
			DesignerMain.STAGE.addEventListener(MouseEvent.MOUSE_UP, POINT_MOUSE_UP);
			DesignerMain.STAGE.addEventListener(MouseEvent.MOUSE_MOVE, POINT_MOUSE_MOVE);
			var rect:Rectangle = getDragRectangle(event.target as Sprite);
			(event.target as Sprite).startDrag(false, rect);
		}
		private function POINT_MOUSE_MOVE(event:MouseEvent):void{
			remTarget.y = remTarget.x
			if(pointSelected[0] == remTarget){
				pointSelected[2].y = remTarget.y;
				pointSelected[1].x = remTarget.x;
			}
			if(pointSelected[1] == remTarget){
				pointSelected[3].y = remTarget.y;
				pointSelected[0].x = remTarget.x;
			}
			if(pointSelected[2] == remTarget){
				pointSelected[0].y = remTarget.y;
				pointSelected[3].x = remTarget.x;
			}
			if(pointSelected[3] == remTarget){
				pointSelected[1].y = remTarget.y;
				pointSelected[2].x = remTarget.x;
			}
			selected.graphics.clear();
			selected.graphics.lineStyle(0.1, 0x000000, 0.3);
			selected.graphics.drawRect(pointSelected[0].x, pointSelected[0].y, pointSelected[3].x - pointSelected[0].x, pointSelected[3].y - pointSelected[0].y);
		}
		private function POINT_MOUSE_UP(event:MouseEvent):void{
			var newRect:Rectangle = new Rectangle(pointSelected[0].x, pointSelected[0].y, pointSelected[3].x - pointSelected[0].x, pointSelected[3].y - pointSelected[0].y);
			deltaRect = new Object();
			deltaRect.deltaX = newRect.x;
			deltaRect.deltaY = newRect.y;
			deltaRect.deltaW = oldRect.width - newRect.width;
			deltaRect.deltaH = oldRect.height - newRect.height;
			deltaRect.scaleX = newRect.width/oldRect.width;
			deltaRect.scaleY = newRect.height/oldRect.height;
			
			oldRect = newRect;
			DesignerMain.STAGE.removeEventListener(MouseEvent.MOUSE_UP, POINT_MOUSE_UP);
			DesignerMain.STAGE.removeEventListener(MouseEvent.MOUSE_MOVE, POINT_MOUSE_MOVE);
			super.stopDrag();
			super.dispatchEvent(new Event(RESIZE_SELECT));
		}
		public function removeSelect():void{
			selected.graphics.clear();
			while(selected.numChildren>0){
				selected.removeChildAt(0);
			}
			while(pointSelected.length>0) {
				if(dragContainer.contains(pointSelected[0])) dragContainer.removeChild(pointSelected[0]);
				pointSelected.shift();
			}
			if(dragContainer.contains(selected)) dragContainer.removeChild(selected);
			
		}
		
		
		private function getDragRectangle(object:Sprite):Rectangle{
			var i:int;
			var l:int;
			var index:int;
			l = pointSelected.length;
			for(i=0;i<l;i++){
				if(object == pointSelected[i]){
					index = i;
					break;
				}
			}
			var outRect:Rectangle;
			switch(index){
				case 0:
					outRect = new Rectangle(-2000, -2000, 2000 + pointSelected[3].x - 15, 2000 + pointSelected[3].y - 15);
				break;
				case 1:
					outRect = new Rectangle(-2000, pointSelected[2].y + 15, 2000 + pointSelected[2].x - 15, 2000);
				break;
				case 2:
					outRect = new Rectangle(pointSelected[1].x + 15, -2000, 2000, 2000 + pointSelected[1].y - 15);
				break;
				case 3:
					outRect = new Rectangle(pointSelected[0].x + 15, pointSelected[0].y + 15, 2000, 2000);
				break;
			}
			return outRect;
		}
		
		public function get resize():Object{
			return deltaRect;
		}
	}
	
}
