package source.BlockOfTask.Task.TaskObjects.PaintPicture {
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.Event;
	
	public class PanelPaintPicker extends Sprite{
		public static var SELECT_CURRENT_COLOR:String = 'onSelectCurrentColor';
		private static var backgroundColor:uint = 0xDDDDDD;
		
		private var pickerArray:Array = new Array();
		
		private var WPanel:Number = 0;
		
		private var selectColor:uint = 0xFFFFFF;
		public function PanelPaintPicker(width:Number) {
			super();
			Width = width;
		}
		public function set Width(value:Number):void{
			WPanel = value;
			drawPanelBackground();
			replace();
		}
		
		private function drawPanelBackground():void{
			super.graphics.clear();
			super.graphics.lineStyle(0.1, 0x000000, 1);
			super.graphics.beginFill(backgroundColor, 1);
			super.graphics.drawRect(0, 0, WPanel, Height);
			super.graphics.endFill();
		}
		
		public function get Height():Number{
			var out:Number = Math.ceil((pickerArray.length*(OnePaintPicker.size+5))/WPanel);
			return (out==0)?(OnePaintPicker.size+10):(out * (OnePaintPicker.size+5)+5)
		}
		
		public function set color(value:uint):void{
			var ID:int = pickerArray.length;
			pickerArray.push(new OnePaintPicker(value));
			super.addChild(pickerArray[ID]);
			(pickerArray[ID] as OnePaintPicker).addEventListener(MouseEvent.MOUSE_DOWN, SELECT_CURRENT_PICKER);
			(pickerArray[ID] as OnePaintPicker).addEventListener(OnePaintPicker.REMOVE_PICKER, REMOVE_ONE_PICKER);
			replace();
			drawPanelBackground();
		}
		private function REMOVE_ONE_PICKER(event:Event):void{
			var i:int;
			var l:int;
			l = pickerArray.length;
			for(i=0;i<l;i++){
				if((event.target as OnePaintPicker) == (pickerArray[i] as OnePaintPicker)){
					(pickerArray[i] as OnePaintPicker).removeEventListener(MouseEvent.MOUSE_DOWN, SELECT_CURRENT_PICKER);
					(pickerArray[i] as OnePaintPicker).removeEventListener(OnePaintPicker.REMOVE_PICKER, REMOVE_ONE_PICKER);
					super.removeChild(pickerArray[i]);
					pickerArray.splice(i, 1);
					deselectAll();
					replace();
					drawPanelBackground();
					if(pickerArray.length>0){
						(pickerArray[0] as OnePaintPicker).select = true;
						selectColor = (pickerArray[0] as OnePaintPicker).color;
						super.dispatchEvent(new Event(SELECT_CURRENT_COLOR));
					}
					return;
				}
			}
		}
		public function get color():uint{
			return selectColor;
		}
		private function replace():void{
			var i:int;
			var j:int;
			var l:int;
			var currentY:int = -1;
			l = pickerArray.length;
			var num:int = Math.ceil((pickerArray.length*(OnePaintPicker.size+5))/WPanel);
			for(i=0;i<l;i++){
				if(i%num==0) ++currentY;
				pickerArray[i].y = 5 + (i%num)*(OnePaintPicker.size+5);
				pickerArray[i].x = 5 + currentY*(OnePaintPicker.size+5);
			}
		}
		
		private function SELECT_CURRENT_PICKER(event:MouseEvent):void{
			deselectAll();
			var i:int;
			var l:int;
			l = pickerArray.length;
			for(i=0;i<l;i++){
				if((pickerArray[i] as OnePaintPicker) == (event.target as OnePaintPicker)){
					(pickerArray[i] as OnePaintPicker).select = true;
					selectColor = (pickerArray[i] as OnePaintPicker).color;
					super.dispatchEvent(new Event(SELECT_CURRENT_COLOR));
					return;
				}
			}
		}
		private function deselectAll():void{
			var i:int;
			var l:int;
			l = pickerArray.length;
			for(i=0;i<l;i++){
				(pickerArray[i] as OnePaintPicker).select = false;
			}
		}
		
		public function get listColores():XMLList{
			var outXml:XMLList = new XMLList('<COLORES/>');
			var i:int;
			var l:int;
			l = pickerArray.length;
			for(i=0;i<l;i++){
				outXml.appendChild(new XMLList('<COLOR id="'+i+'">0x'+rebuildColor((pickerArray[i] as OnePaintPicker).color)+'</COLOR>'));
			}
			return outXml;
		}
		private function rebuildColor(value:uint):String{
			var colorStr:String = value.toString(16);
			while(colorStr.length<6) colorStr = '0' + colorStr ;
			return colorStr;
		}

	}
	
}
