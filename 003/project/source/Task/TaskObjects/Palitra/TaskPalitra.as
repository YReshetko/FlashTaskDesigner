package source.Task.TaskObjects.Palitra {
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import source.utils.Figure;
	import source.DesignerMain;
	import source.Task.OneTask;
	import flash.ui.Mouse;
	import flash.geom.Point;

	public class TaskPalitra extends Sprite{
		//public static var CURRENT_COLOR_CHANGE:String = 'onCurrentColorChange';
		
		private static const wBrushContainer:Number = 50;
		private static const hDragContainer:Number = 15;
		
		private static const deltaX:int = 3;
		private static const deltaY:int = 3;
		private var arrPicker:Array = new Array();
		private var currentColor:uint = 0x000000;
		private var brushContainer:Sprite = new Sprite();
		private var dragContainer:Sprite = new Sprite();
		private var pickerContainer:Sprite = new Sprite();
		private var mainBrushContainer:Sprite;
		
		private var samplePicker:OnePicker;
		
		private var remObject:OnePicker;
		private var brush:Brush;
		private var brushSelect:Boolean;
		
		public function TaskPalitra(inXml:XMLList, container:Sprite, brushCont:Sprite) {
			super();
			container.addChild(super);
			super.x = 300;
			super.y = 450;
			mainBrushContainer = brushCont;
			initContainer();
			drawPanel(inXml);
			initSamplePicker();
			initBrush();
			correctPosition();
		}
		private function initBrush():void{
			brush = new Brush();
			PICK_DOWN_BRUSH();
		}
		private function PICK_UP_BRUSH(e:MouseEvent = null):void{
			DesignerMain.STAGE.addEventListener(MouseEvent.MOUSE_MOVE, DRAG_BRUSH);
			brushContainer.removeEventListener(MouseEvent.CLICK, PICK_UP_BRUSH);
			brushContainer.addEventListener(MouseEvent.CLICK, PICK_DOWN_BRUSH);
			pickBrush();
		}
		private function PICK_DOWN_BRUSH(e:MouseEvent = null):void{
			try{DesignerMain.STAGE.removeEventListener(MouseEvent.MOUSE_MOVE, DRAG_BRUSH);}
			catch (e:TypeError){}
			brushContainer.addEventListener(MouseEvent.CLICK, PICK_UP_BRUSH);
			brushContainer.removeEventListener(MouseEvent.CLICK, PICK_DOWN_BRUSH);
			putBrush();
		}
		private function DRAG_BRUSH(e:MouseEvent):void{
			var point:Point = new Point(e.stageX, e.stageY);
			var contPoint:Point = mainBrushContainer.localToGlobal(new Point(mainBrushContainer.x, mainBrushContainer.y));
			brush.x = point.x - contPoint.x;
			brush.y = point.y - contPoint.y;
			e.updateAfterEvent();
		}
		private function putBrush():void{
			brushSelect = false;
			brushContainer.addChild(brush);
			brush.x = 0
			brush.y = 5 + brush.height;
		}
		private function pickBrush():void{
			brushSelect = true;
			mainBrushContainer.addChild(brush);
		}
		public function get select():Boolean{
			return brushSelect;
		}
		private function initSamplePicker():void{
			samplePicker = new OnePicker(0x000000);
			samplePicker.sample = true;
			pickerContainer.addChild(samplePicker);
			samplePicker.addEventListener(OnePicker.PICKER_SELECT, PICKER_IS_SELECT);
			samplePicker.addEventListener(OnePicker.PICKER_SET_COLOR, PICKER_IS_SET_COLOR);
			samplePicker.addEventListener(OnePicker.CLEAR_GLOBAL_PICKER, CLEAR_IS_GLOBAL_PICKER);
		}
		private function PICKER_IS_SET_COLOR(e:Event):void{
			addPicker(e.target.color);
		}
		private function drawPanel(inXml:XMLList):void{
			if(inXml == null) return;
			var str:String;
			for each(var sample:XML in inXml.elements()){
				str = sample.name().toString();
				switch(str){
					case 'X':
						super.x = parseFloat(sample);
					break;
					case 'Y':
						super.y = parseFloat(sample);
					break;
					case 'COLOR':
						addPicker(uint(sample));
					break;
				}
			}
			
			
			//if(arrPicker.length>0) color = arrPicker[0].color;
		}
		private function addPicker(inColor:uint):void{
			var ID:int = arrPicker.length;
			arrPicker.push(new OnePicker(inColor));
			pickerContainer.addChild(arrPicker[ID]);
			arrPicker[ID].ID = ID;
			//arrPicker[ID].addEventListener(MouseEvent.MOUSE_DOWN, PICKER_MOUSE_DOWN);
			arrPicker[ID].addEventListener(OnePicker.PICKER_SELECT, PICKER_IS_SELECT);
			arrPicker[ID].addEventListener(OnePicker.REMOVE_PICKER, PICKER_IS_REMOVE);
			arrPicker[ID].addEventListener(OnePicker.CLEAR_GLOBAL_PICKER, CLEAR_IS_GLOBAL_PICKER);
			correctPosition();
		}
		private function PICKER_IS_REMOVE(e:Event):void{
			var id:int = e.target.ID;
			pickerContainer.removeChild(arrPicker[id]);
			arrPicker[id].removeEventListener(OnePicker.PICKER_SELECT, PICKER_IS_SELECT);
			arrPicker[id].removeEventListener(OnePicker.REMOVE_PICKER, PICKER_IS_REMOVE);
			arrPicker[id].removeEventListener(OnePicker.CLEAR_GLOBAL_PICKER, CLEAR_IS_GLOBAL_PICKER);
			arrPicker[id].clear();
			arrPicker.splice(id,1);
			correctPosition();
		}
		private function PICKER_IS_SELECT(e:Event):void{
			var i:int;
			var l:int;
			l = arrPicker.length;
			for(i=0;i<l;i++){
				arrPicker[i].select = false;
			}
			samplePicker.select = false;
			e.target.select = true;
			remObject = e.target as OnePicker;
			super.dispatchEvent(new Event(OneTask.GET_OBJECT_SETTINGS));
			if(brushSelect && !e.target.sample) {
				brush.color = e.target.color;
				color = brush.color;
			}
		}
		public function get remember():OnePicker{
			return remObject;
		}
		private function CLEAR_IS_GLOBAL_PICKER(e:Event):void{
			remObject = null;
			super.dispatchEvent(new Event(OneTask.GET_OBJECT_SETTINGS));
		}
		private function correctPosition():void{
			//trace(this + ': PALITRA 1');
			var currentX:Number = deltaX;
			var currentY:Number = deltaY;
			var i:int;
			//trace(this + ': PALITRA 2');
			var l:int = arrPicker.length;
			//trace(this + ': PALITRA 3');
			for(i=0;i<l;i++){
				if(i%7 == 0 && i!=0) currentY += OnePicker.pickerSize + deltaY;
				currentX = (i%7) * (OnePicker.pickerSize + deltaX) + deltaX;
				arrPicker[i].x = currentX;
				arrPicker[i].y = currentY;
				arrPicker[i].ID = i;
			}
			//trace(this + ': PALITRA 4');
			if(l%7 == 0 && l!=0) currentY += OnePicker.pickerSize + deltaY;
			//trace(this + ': PALITRA 5');
			currentX = (l%7) * (OnePicker.pickerSize + deltaX) + deltaX;
			//trace(this + ': PALITRA 6');
			if(samplePicker!=null){
				samplePicker.x = currentX;
				samplePicker.y = currentY;
			}
			//trace(this + ': PALITRA 7');
			drawContainers();
		}
		private function drawContainers():void{
			pickerContainer.graphics.clear();
			dragContainer.graphics.clear();
			brushContainer.graphics.clear();
			Figure.insertRect(pickerContainer, pickerContainer.width + 2*deltaX, pickerContainer.height + 2*deltaY, 1, 1, 0x000000, 1, 0xB6B6B6);
			Figure.insertRect(dragContainer, wBrushContainer + pickerContainer.width-1, hDragContainer, 1, 1, 0x000000, 1, 0x3F3F3F);
			Figure.insertRect(brushContainer, wBrushContainer, pickerContainer.height-1, 1, 1, 0x000000, 1, 0xB6B6B6);
			
		}
		private function initContainer():void{
			super.addChild(brushContainer);
			super.addChild(dragContainer);
			super.addChild(pickerContainer);
			dragContainer.x = brushContainer.x = -wBrushContainer;
			dragContainer.y = -hDragContainer;
			dragContainer.addEventListener(MouseEvent.MOUSE_DOWN, DRAG_MOUSE_DOWN);
		}
		private function DRAG_MOUSE_DOWN(e:MouseEvent):void{
			super.startDrag();
			DesignerMain.STAGE.addEventListener(MouseEvent.MOUSE_UP, DRAG_MOUSE_UP);
		}
		private function DRAG_MOUSE_UP(e:MouseEvent):void{
			super.stopDrag();
			DesignerMain.STAGE.removeEventListener(MouseEvent.MOUSE_UP, DRAG_MOUSE_UP);
		}
		
		private function PICKER_MOUSE_DOWN(e:MouseEvent):void{
			color = e.target.color;
			
		}
		public function get color():uint{
			return currentColor
		}
		public function set color(value:uint):void{
			currentColor = value;
			//super.dispatchEvent(new Event(CURRENT_COLOR_CHANGE));
		}
		public function clear():void{
			super.parent.removeChild(super);
			arrPicker = null;
		}
		
		public function get listPosition():XMLList{
			var outXml:XMLList = new XMLList('<PALITRA/>');
			outXml.X = super.x;
			outXml.Y = super.y;
			var colorXml:XMLList;
			var i:int;
			var l:int;
			l = arrPicker.length;
			for(i=0;i<l;i++){
				colorXml = new XMLList('<COLOR/>');
				colorXml.@id = (i+1).toString();
				colorXml.setChildren('0x'+arrPicker[i].color.toString(16));
				outXml.appendChild(colorXml);
			}
			return outXml;
		}
		public function get isCorrectPosition():Boolean{
			if(super.x<0 || super.x>DesignerMain.STAGE.width) return false;
			if(super.y<0 || super.x>DesignerMain.STAGE.height) return false;
			return true;
		}
		
		public function get arrColors():Array{
			var outArr:Array = new Array();
			var i:int;
			var l:int;
			l = arrPicker.length;
			for(i=0;i<l;i++){
				outArr.push((arrPicker[i] as OnePicker).color);
			}
			return outArr;
		}
	}
	
}
