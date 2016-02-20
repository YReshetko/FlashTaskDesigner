package source.Task.PaintSystem {
	import flash.display.Sprite;
	import source.utils.Figure;
	import flash.events.MouseEvent;
	import source.Task.PaintSystem.DrawObjects.DrowerControl;
	import flash.events.Event;
	import source.Task.PaintSystem.DrawObjects.BaseFigure;
	import flash.utils.ByteArray;
	import flash.display.Bitmap;
	
	public class PaintContainer extends Sprite{
		//	Контенер будет хранить все контенеры связанные с рисованием
		private var mainContainer:Sprite = new Sprite();
		private var pictureContainer:Sprite = new Sprite();
		private var figureContainer:Sprite = new Sprite();
		private var greedContainer:Sprite = new Sprite();
		private var drawContainer:Sprite = new Sprite();
		private var circleTarget:Sprite = new Sprite();
		
		private var hGreed:Number = 10;
		private var wGreed:Number = 10;
		
		private var scalePanel:Number = 1;
		
		private var hPanel:Number = 3000;
		private var wPanel:Number = 4000;
		
		
		private var isDraw:Boolean = false;
		private var lock:Boolean = true;
		
		private var isDragScene:Boolean = false;
		private var isDragFigure:Boolean = true;
		
		private var drowerControl:DrowerControl;
		private var currentObject:*;
		
		private var baseFigure:BaseFigure;
		private var imageContainer:ImageContainer;
		public function PaintContainer() {
			super();
			initContainer();
		}
		public function set container(value:Sprite):void{
			value.addChild(super);
		}
		private function initContainer():void{
			mainContainer.addChild(pictureContainer);
			mainContainer.addChild(figureContainer);
			mainContainer.addChild(greedContainer);
			mainContainer.addChild(drawContainer);
			//mainContainer.addChild(circleTarget);
			circleTarget.mouseEnabled = false;
			greedContainer.mouseEnabled = false;
			super.addChild(mainContainer);
			Figure.insertRect(mainContainer, wPanel, hPanel, 1, 0);
			Figure.insertCircle(circleTarget, 5, 1, 1, 0x000000, 0);
			drawGrid();
			drowerControl = new DrowerControl(drawContainer);
			drowerControl.addEventListener(DrowerControl.SELECT_POINT, TAKE_POINT);
			drowerControl.addEventListener(DrowerControl.SELECT_ANHOR, TAKE_ANHOR);
			
			baseFigure = new BaseFigure(figureContainer);
			baseFigure.addEventListener(BaseFigure.FIGURE_EDIT, EDIT_FIGURE);
			imageContainer = new ImageContainer(pictureContainer);
		}
		private function EDIT_FIGURE(event:Event):void{
			var arr:Array = baseFigure.points;
			drowerControl.points = arr;
		}
		public function set position(value:Number):void{
			mainContainer.x = value;
		}
		public function setImage(value:ByteArray, name:String):void{
			imageContainer.setImage(value, name);
		}
		private function drawGrid():void{
			greedContainer.graphics.clear();
			var w:int = Math.ceil(wPanel/wGreed);
			var h:int = Math.ceil(hPanel/hGreed);
			var i:int;
			for(i=0;i<w;i++){
				Figure.insertLine(greedContainer, i*wGreed, 0, i*wGreed, hPanel, 1, 0.1);
			}
			for(i=0;i<h;i++){
				Figure.insertLine(greedContainer, 0, i*hGreed, wPanel, i*hGreed, 1, 0.1);
			}
		}
		public function set scale(value:Number):void{
			scalePanel = value;
			mainContainer.scaleX = value;
			mainContainer.scaleY = value;
			this.drowerControl.scale = 1/value;
			circleTarget.scaleX = circleTarget.scaleY = 1/value;
		}
		public function get scale():Number{
			return scalePanel;
		}
		
		
		public function set drawFigure(value:Boolean):void{
			isDraw = value;
			if(value){
				mainContainer.addChild(circleTarget);
				mainContainer.addEventListener(MouseEvent.MOUSE_MOVE, GREED_MOUSE_MOVE);
				mainContainer.addEventListener(MouseEvent.MOUSE_DOWN, GREED_MOUSE_DOWN);
				mainContainer.mouseChildren = false;
				baseFigure.enabled = false;
				drowerControl.enabled = false;
				currentObject = circleTarget;
			}else{
				if(mainContainer.contains(circleTarget)) mainContainer.removeChild(circleTarget);
				mainContainer.removeEventListener(MouseEvent.MOUSE_MOVE, GREED_MOUSE_MOVE);
				mainContainer.removeEventListener(MouseEvent.MOUSE_DOWN, GREED_MOUSE_DOWN);
				mainContainer.mouseChildren = true;
				baseFigure.enabled = true;
				drowerControl.enabled = true;
				currentObject = null;
			}
		}
		public function get drawFigure():Boolean{
			return isDraw;
		}
		private function GREED_MOUSE_MOVE(e:MouseEvent):void{
			if (currentObject == null) return;
			var simple_X:int;
			var simple_Y:int;
			var _G:int = wGreed;
			var _V:int = hGreed;
			var _P:int = scale;
			//	Проверяем параметр привязки сетки
			if(lock){
				//	Если привязан, то размещаем окружность на ближайшей узловой точке сетки
				simple_X = Math.round((e.localX+mainContainer.x)/_G)*_G - Math.round(mainContainer.x/_G)*_G;
				simple_Y = Math.round((e.localY+mainContainer.y)/_V)*_V - Math.round(mainContainer.y/_V)*_V;
			}else{
				//	Если не привязан, то двигаем окружность за мышью
				simple_X = e.localX;
				simple_Y = e.localY;
			}
			currentObject.x = simple_X;
			currentObject.y = simple_Y;
			if(currentObject.toString() == '[object POINT]')drowerControl.redrawFromPoint();
			if(currentObject.toString() == '[object ANHOR]')drowerControl.redrawFromAnhor();
		}
		
		private function GREED_MOUSE_DOWN(e:MouseEvent):void{
			drowerControl.addNewPoint(circleTarget.x, circleTarget.y);
		}
		private function TAKE_POINT(e:Event):void{
			currentObject = drowerControl.point;
			mainContainer.mouseChildren = false;
			mainContainer.mouseEnabled = true;
			mainContainer.addEventListener(MouseEvent.MOUSE_MOVE, GREED_MOUSE_MOVE);
			mainContainer.addEventListener(MouseEvent.MOUSE_UP, PUT_POINT);
		}
		private function PUT_POINT(e:MouseEvent):void{
			trace(this + ': PUT POINT')
			currentObject = null;
			mainContainer.mouseChildren = true;
			mainContainer.removeEventListener(MouseEvent.MOUSE_MOVE, GREED_MOUSE_MOVE);
			mainContainer.removeEventListener(MouseEvent.MOUSE_UP, PUT_POINT);
		}
		private function TAKE_ANHOR(e:Event):void{
			currentObject = drowerControl.anhor;
			mainContainer.mouseChildren = false;
			mainContainer.mouseEnabled = true;
			mainContainer.addEventListener(MouseEvent.MOUSE_MOVE, GREED_MOUSE_MOVE);
			mainContainer.addEventListener(MouseEvent.MOUSE_UP, PUT_POINT);
		}
		
		public function saveFigure():void{
			var inArray:Array = drowerControl.array;
			if(inArray.length<=1) return;
			baseFigure.addFigure(inArray);
			drowerControl.removeFigure();
		}
		public function setOutFigure(value:Object):void{
			trace(this + ': 1');
			var inArr:Array = new Array();
			var X:int;
			var Y:int;
			var Beta:Number = value.rotation*(-Math.PI/8);
			var obj:Object;
			X = value.x;
			Y = value.y;
			var i:int;
			var l:int;
			var j:int;
			var k:int;
			trace(this + ': 2');
			l = value.points.length;
			trace(this + ': 3');
			for(i=0;i<l;i++){
				inArr.push(new Array());
				for(j=0;j<value.points[i].length;j++){
					inArr[i].push(value.points[i][j]);
				}
			}
			trace(this + ': 4');
			l = inArr.length;
			trace(this + ': 5');
			if(l>1){
				if(inArr[1].length==2){
					for(i=1;i<l;i++){
						inArr[i][2] = inArr[i-1][0] + (inArr[i][0] - inArr[i-1][0])/2;
						inArr[i][3] = inArr[i-1][1] + (inArr[i][1] - inArr[i-1][1])/2;
					}
				}
			}
			trace(this + ': 6');
			for(i=0;i<l;i++){
				for(j=0;j<inArr[i].length;j=j+2){
					obj = rotationFigure(inArr[i][j], inArr[i][j+1], Beta);
					inArr[i][j] = obj.X + X;
					inArr[i][j+1] = obj.Y + Y;
				}
			}
			trace(this + ': 7');
			baseFigure.addFigure(inArr);
		}
		private function rotationFigure(X:Number, Y:Number, Beta:Number):Object{
			var r:Number = Math.sqrt(X*X+Y*Y);
			var cosAlpha:Number = X/r;
			var sinAlpha:Number = Y/r;
			var cosBeta:Number = Math.cos(Beta);
			var sinBeta:Number = Math.sin(Beta);
			var sinResult:Number;
			var cosResult:Number;
			sinResult = sinAlpha*cosBeta + cosAlpha*sinBeta;
			cosResult = cosAlpha*cosBeta - sinAlpha*sinBeta;
			return {'X':r*cosResult, 'Y':r*sinResult};
		}
		
		public function printImage():void{
			var inArr:Array = baseFigure.rectangles;
			var bmpArr:Array = imageContainer.getSampleImage(inArr);
			baseFigure.printingImages = bmpArr;
			var i:int;
			var l:int;
			l = inArr.length;
		}
		public function get listSettings():XMLList{
			var outXml:XMLList = new XMLList('<PACKAGE/>');
			if(imageContainer.listSettings!=null)outXml.appendChild(imageContainer.listSettings);
			if(baseFigure.listFigure!=null) {
				outXml.appendChild(baseFigure.listFigure);
				baseFigure.clear();
			}
			//trace(this + 'XML = \n' + outXml);
			return outXml;
		}
		public function get bitmap():Bitmap{
			return imageContainer.copyBitmap;
		}
		public function get nameBitmap():String{
			return imageContainer.nameBitmap;
		}
		
		public function set alphaBase(value:Boolean):void{
			baseFigure.visible = value;
		}
		public function get alphaBase():Boolean{
			return baseFigure.visible;
		}
		
		public function set dragContainer(value:Boolean):void{
			isDragScene = value;
			if(value){
				this.mainContainer.mouseChildren = false;
				this.mainContainer.tabChildren  = false;
				this.mainContainer.addEventListener(MouseEvent.MOUSE_DOWN, SCENE_MOUSE_DOWN);
				this.mainContainer.addEventListener(MouseEvent.MOUSE_UP, SCENE_MOUSE_UP);
			}else{
				this.mainContainer.mouseChildren = true;
				this.mainContainer.tabChildren  = true;
				this.mainContainer.removeEventListener(MouseEvent.MOUSE_DOWN, SCENE_MOUSE_DOWN);
				this.mainContainer.removeEventListener(MouseEvent.MOUSE_UP, SCENE_MOUSE_UP);
			}
		}
		public function get dragContainer():Boolean{
			return isDragScene;
		}
		private function SCENE_MOUSE_DOWN(event:MouseEvent):void{
			this.mainContainer.startDrag()
		}
		private function SCENE_MOUSE_UP(event:MouseEvent):void{
			this.mainContainer.stopDrag()
		}
		public function set dragFigure(value:Boolean):void{
			isDragFigure = value;
			figureContainer.mouseChildren = value;
			figureContainer.mouseEnabled = value;
			pictureContainer.mouseChildren = value;
			pictureContainer.mouseEnabled = value;
			pictureContainer.tabChildren = value;
			pictureContainer.tabEnabled = value;
		}
		public function get dragFigure():Boolean{
			return isDragFigure;
		}
		
		public function set isLock(value:Boolean):void{
			lock = value;
		}
		public function get isLock():Boolean{
			return lock;
		}
		
		public function set widthGreed(value:Number):void{
			this.wGreed = value;
			drawGrid();
		}
		public function get widthGreed():Number{
			return this.wGreed;
		}
		public function set heightGreed(value:Number):void{
			this.hGreed = value;
			drawGrid();
		}
		public function get heightGreed():Number{
			return this.hGreed;
		}
		public function clear():void{
			baseFigure.clear();
			imageContainer.clear();
		}
	}
	
}
