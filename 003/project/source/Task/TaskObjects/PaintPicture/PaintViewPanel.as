package source.Task.TaskObjects.PaintPicture {
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.Event;
	
	public class PaintViewPanel extends PaintView{
		private var pancilBut:Pancil = new Pancil();
		private var eraserBut:Eraser = new Eraser();
		private var plane:Sprite;
		private var picker:PanelPaintPicker;
		public function PaintViewPanel() {
			super();
			super.addEventListener(PaintView.RESIZE_PANEL, CHANGE_WIDTH);
			super.addEventListener(PaintView.SET_COLOR, ON_SET_COLOR);
			drawToolsPanel();
			initHandler();
		}
		private function drawToolsPanel():void{
			plane = new Sprite();
			plane.graphics.lineStyle(0.1, 0x000000, 1);
			plane.graphics.beginFill(0xBBBBBB, 1);
			plane.graphics.drawRect(0, 0, 30, 60);
			plane.graphics.endFill();
			plane.addChild(pancilBut);
			plane.addChild(eraserBut);
			pancilBut.x = eraserBut.x = 5;
			pancilBut.y = 5;
			eraserBut.y = 30;
			super.addChild(plane);
			plane.x = -30;
		}
		private function initHandler():void{
			pancilBut.addEventListener(MouseEvent.MOUSE_DOWN, PANCIL_MOUSE_DOWN);
			eraserBut.addEventListener(MouseEvent.MOUSE_DOWN, ERASER_MOUSE_DOWN);
		}
		
		private function PANCIL_MOUSE_DOWN(event:MouseEvent):void{
			super.paint = !super.paint;
			if(super.paint) {
				pancilBut.gotoAndStop(2);
				this.eraserBut.gotoAndStop(1);
				super.eraser =  false;
			}else {
				pancilBut.gotoAndStop(1);
			}
		}
		private function ERASER_MOUSE_DOWN(event:MouseEvent):void{
			super.eraser = !super.eraser;
			if(super.eraser) {
				pancilBut.gotoAndStop(1);
				this.eraserBut.gotoAndStop(2);
				super.paint =  false;
			}else {
				this.eraserBut.gotoAndStop(1);
			}
		}
		
		private function CHANGE_WIDTH(event:Event):void{
			if(picker == null){
				picker = new PanelPaintPicker(super.panelWidth)
				picker.addEventListener(PanelPaintPicker.SELECT_CURRENT_COLOR, CHANGE_PAINT_COLOR);
				super.addChild(picker);
			}
			else {
				picker.Width = super.panelWidth;
			}
			picker.y = super.panelHeight;
		}
		
		private function ON_SET_COLOR(event:Event):void{
			if(picker != null){
				picker.color = super.setableColor;
			}
		}
		
		private function CHANGE_PAINT_COLOR(event:Event):void{
			super.drawColor = picker.color;
		}
		public function get listPosition():XMLList{
			var outXml:XMLList = new XMLList('<PAINT/>');
			outXml.X = super.x;
			outXml.Y = super.y;
			outXml.WIDTH = super.panelWidth;
			outXml.HEIGHT = super.panelHeight;
			outXml.THICK = super.brushThink;
			
			if(super.backgroundFileName!=''){
				outXml.BACKGROUNDFILENAME = super.backgroundFileName;
			}
			outXml.AUTHORFILENAME = super.authorFileName;
			outXml.appendChild(picker.listColores);
			return outXml;
		}

	}
	
}
