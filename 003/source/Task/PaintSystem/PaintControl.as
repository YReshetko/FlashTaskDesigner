package source.Task.PaintSystem {
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import source.utils.Figure;
	import flash.events.Event;
	import source.utils.Components.Field;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import source.DesignerMain;
	
	public class PaintControl extends PaintContainer{
		public static var ADD_FIGURE_ON_SCENE:String = 'onAddFigureOnScene';
		
		
		private var dragPanelContainer:Sprite = new Sprite();
		private var drawLine:PaintButLine = new PaintButLine();
		private var newFigure:PaintButNewFigure = new PaintButNewFigure();
		private var alphaTan:PaintButAlphaTan = new PaintButAlphaTan();
		private var dragScene:PaintButHand = new PaintButHand();
		private var blockDrag:PaintButBlockDrag = new PaintButBlockDrag();
		private var addFigure:PaintButAddOnScen = new PaintButAddOnScen();
		private var prinatImage:PaintButAddImage = new PaintButAddImage();
		
		private var butLock:ButLock = new ButLock();
		
		private var butRemove:ButRemoveFigure = new ButRemoveFigure();
		
		private var scaleField:Field = new Field();
		private var scaleLabel:TextField = new TextField();
		
		private var wField:Field = new Field();
		private var hField:Field = new Field();
		
		private var wLabel:TextField = new TextField();
		private var hLabel:TextField = new TextField();
		
		private var buttonContainer:Sprite = new Sprite();
		public function PaintControl() {
			super();
			initPanel();
			initHandler();
		}
		private function initPanel():void{
			super.addChild(buttonContainer);
			buttonContainer.addChild(dragPanelContainer)
			buttonContainer.addChild(drawLine);
			buttonContainer.addChild(newFigure);
			buttonContainer.addChild(alphaTan);
			buttonContainer.addChild(dragScene);
			buttonContainer.addChild(blockDrag);
			buttonContainer.addChild(addFigure);
			buttonContainer.addChild(prinatImage);
			
			buttonContainer.addChild(butLock);
			
			buttonContainer.addChild(scaleField);
			buttonContainer.addChild(scaleLabel);
			
			buttonContainer.addChild(wField);
			buttonContainer.addChild(wLabel);
			buttonContainer.addChild(hField);
			buttonContainer.addChild(hLabel);
			
			buttonContainer.addChild(butRemove);
			
			
			
			butRemove.x = hField.x = wField.x = scaleField.x = butLock.x = prinatImage.x = drawLine.x = alphaTan.x = blockDrag.x = 5;
			newFigure.x = dragScene.x = addFigure.x = 30;
			
			drawLine.y = newFigure.y = 5;
			alphaTan.y = dragScene.y = 30;
			blockDrag.y = addFigure.y = 55;
			prinatImage.y = 80;
			
			butLock.y = 120;
			butLock.gotoAndStop(3);
			
			
			
			scaleLabel.y = scaleField.y = 145;
			wLabel.y = wField.y = 170;
			hLabel.y = hField.y = 195;
			hField.width = wField.width = scaleField.width = 30;
			hField.height = wField.height = scaleField.height = 21
			hField.input = wField.input = scaleField.input = true;
			hField.restrict = wField.restrict = scaleField.restrict = '0-9';
			hField.maxLength = wField.maxLength = scaleField.maxLength = 3;
			scaleField.text = (super.scale * 100).toString();
			wField.text = super.widthGreed.toString();
			hField.text = super.heightGreed.toString();
			
			hLabel.x = wLabel.x = scaleLabel.x = scaleField.width+5;
			hLabel.autoSize = wLabel.autoSize = scaleLabel.autoSize = TextFieldAutoSize.LEFT;
			scaleLabel.text = '%';
			wLabel.text = 'W';
			hLabel.text = 'H';
			var format:TextFormat = new TextFormat();
			format.size = 14;
			format.bold = true;
			scaleLabel.setTextFormat(format);
			wLabel.setTextFormat(format);
			hLabel.setTextFormat(format);
			
			butRemove.y = 250;
			
			
			super.position = 0;
			Figure.insertRect(dragPanelContainer, buttonContainer.width+10, buttonContainer.height+10, 2);
			dragPanelContainer.addEventListener(MouseEvent.MOUSE_DOWN, DRAG_START);
		}
		private function DRAG_START(event:MouseEvent):void{
			DesignerMain.STAGE.addEventListener(MouseEvent.MOUSE_UP, STOP_DRAG);
			buttonContainer.startDrag();
		}
		private function STOP_DRAG(event:MouseEvent):void{
			DesignerMain.STAGE.removeEventListener(MouseEvent.MOUSE_UP, STOP_DRAG);
			buttonContainer.stopDrag();
		}
		private function initHandler():void{
			drawLine.addEventListener(MouseEvent.MOUSE_OVER, LINE_MOUSE_OVER);
			drawLine.addEventListener(MouseEvent.MOUSE_OUT, LINE_MOUSE_OUT);
			drawLine.addEventListener(MouseEvent.MOUSE_DOWN, LINE_MOUSE_DOWN);
			
			newFigure.addEventListener(MouseEvent.MOUSE_OVER, FIGURE_MOUSE_OVER);
			newFigure.addEventListener(MouseEvent.MOUSE_OUT, FIGURE_MOUSE_OUT);
			newFigure.addEventListener(MouseEvent.MOUSE_DOWN, FIGURE_MOUSE_DOWN);
			newFigure.addEventListener(MouseEvent.MOUSE_UP, FIGURE_MOUSE_UP);
			
			alphaTan.addEventListener(MouseEvent.MOUSE_OVER, ALPHA_TAN_MOUSE_OVER);
			alphaTan.addEventListener(MouseEvent.MOUSE_OUT, ALPHA_TAN_MOUSE_OUT);
			alphaTan.addEventListener(MouseEvent.MOUSE_DOWN, ALPHA_TAN_MOUSE_DOWN);
			
			dragScene.addEventListener(MouseEvent.MOUSE_OVER, DRAG_SCENE_MOUSE_OVER);
			dragScene.addEventListener(MouseEvent.MOUSE_OUT, DRAG_SCENE_MOUSE_OUT);
			dragScene.addEventListener(MouseEvent.MOUSE_DOWN, DRAG_SCENE_MOUSE_DOWN);
			
			blockDrag.addEventListener(MouseEvent.MOUSE_DOWN, BLOCK_DRAG_MOUSE_DOWN);
			
			prinatImage.addEventListener(MouseEvent.MOUSE_DOWN, PRINT_MOUSE_DOWN);
			
			addFigure.addEventListener(MouseEvent.MOUSE_DOWN, ADD_FIGURE_MOUSE_DOWN);
			
			
			
			butLock.addEventListener(MouseEvent.MOUSE_OVER, BUT_LOCK_MOUSE_OVER);
			butLock.addEventListener(MouseEvent.MOUSE_OUT, BUT_LOCK_MOUSE_OUT);
			butLock.addEventListener(MouseEvent.MOUSE_DOWN, BUT_LOCK_MOUSE_DOWN);
			
			
			scaleField.addEventListener(Field.TEXT_INPUT, SCALE_TEXT_INPUT);
			scaleField.addEventListener(Field.FIELD_FOCUS_OUT, SCALE_FOCUS_OUT);
			
			wField.addEventListener(Field.TEXT_INPUT, WIDTH_TEXT_INPUT);
			wField.addEventListener(Field.FIELD_FOCUS_OUT, WIDTH_FOCUS_OUT);
			
			hField.addEventListener(Field.TEXT_INPUT, HEIGHT_TEXT_INPUT);
			hField.addEventListener(Field.FIELD_FOCUS_OUT, HEIGHT_FOCUS_OUT);
			
			butRemove.addEventListener(MouseEvent.MOUSE_DOWN, REMOVE_MOUSE_DOWN);
		}
		private function LINE_MOUSE_OVER(e:MouseEvent = null):void{
			if(drawLine.currentFrame == 1) drawLine.gotoAndStop(2);
			if(drawLine.currentFrame == 3) drawLine.gotoAndStop(4);
		}
		private function LINE_MOUSE_OUT(e:MouseEvent = null):void{
			if(drawLine.currentFrame == 2) drawLine.gotoAndStop(1);
			if(drawLine.currentFrame == 4) drawLine.gotoAndStop(3);
		}
		private function LINE_MOUSE_DOWN(e:MouseEvent = null):void{
			if(super.drawFigure){
				super.drawFigure = false;
				drawLine.gotoAndStop(2);
				super.dragFigure = true;
			}else{
				super.drawFigure = true;
				drawLine.gotoAndStop(4);
				super.dragContainer = false;
				super.dragFigure = false;
				dragScene.gotoAndStop(1);
			}
		}
		
		private function FIGURE_MOUSE_OVER(e:MouseEvent = null):void{
			newFigure.gotoAndStop(2);
		}
		private function FIGURE_MOUSE_OUT(e:MouseEvent = null):void{
			newFigure.gotoAndStop(1);
		}
		private function FIGURE_MOUSE_DOWN(e:MouseEvent = null):void{
			newFigure.gotoAndStop(3);
			super.saveFigure();
		}
		private function FIGURE_MOUSE_UP(e:MouseEvent = null):void{
			newFigure.gotoAndStop(2);
		}
		private function PRINT_MOUSE_DOWN(e:MouseEvent):void{
			super.printImage();
		}
		private function ADD_FIGURE_MOUSE_DOWN(e:MouseEvent):void{
			super.dispatchEvent(new Event(ADD_FIGURE_ON_SCENE));
		}
		
		private function ALPHA_TAN_MOUSE_OVER(e:MouseEvent = null):void{
			if(super.alphaBase){
				alphaTan.gotoAndStop(2);
			}
		}
		private function ALPHA_TAN_MOUSE_OUT(e:MouseEvent = null):void{
			if(super.alphaBase) alphaTan.gotoAndStop(1);
		}
		private function ALPHA_TAN_MOUSE_DOWN(e:MouseEvent = null):void{
			super.alphaBase = !super.alphaBase;
			if(!super.alphaBase) alphaTan.gotoAndStop(3);
			else alphaTan.gotoAndStop(2);
			
		}
		
		
		private function DRAG_SCENE_MOUSE_OVER(e:MouseEvent = null):void{
			if(!super.dragContainer)dragScene.gotoAndStop(2);
			else dragScene.gotoAndStop(4);
		}
		private function DRAG_SCENE_MOUSE_OUT(e:MouseEvent = null):void{
			if(!super.dragContainer) dragScene.gotoAndStop(1);
			else dragScene.gotoAndStop(3);
		}
		private function DRAG_SCENE_MOUSE_DOWN(e:MouseEvent = null):void{
			super.dragContainer = !super.dragContainer;
			if(super.dragContainer) {
				dragScene.gotoAndStop(4);
				super.drawFigure = false;
				drawLine.gotoAndStop(1);
			}
			else {
				dragScene.gotoAndStop(2);
			}
		}
		private function BLOCK_DRAG_MOUSE_DOWN(e:MouseEvent):void{
			super.dragFigure = !super.dragFigure;
			if(super.dragFigure) blockDrag.gotoAndStop(1);
			else blockDrag.gotoAndStop(2);
		}
		
		
		
		private function BUT_LOCK_MOUSE_OVER(e:MouseEvent = null):void{
			if(super.isLock){
				butLock.gotoAndStop(2);
			}
		}
		private function BUT_LOCK_MOUSE_OUT(e:MouseEvent = null):void{
			if(super.isLock) butLock.gotoAndStop(3);
		}
		private function BUT_LOCK_MOUSE_DOWN(e:MouseEvent = null):void{
			super.isLock = !super.isLock;
			if(!super.isLock) butLock.gotoAndStop(1);
			else butLock.gotoAndStop(2);
			
		}
		
		private function SCALE_TEXT_INPUT(event:Event):void{
			var num:int = parseFloat(scaleField.text);
			if(num<20) return;
			super.scale = num/100;
		}
		private function SCALE_FOCUS_OUT(event:Event):void{
			var num:int = parseFloat(scaleField.text);
			if(num<20) {
				super.scale = 0.2;
				scaleField.text = '20';
			}else super.scale = num/100;
		}
		
		
		private function WIDTH_TEXT_INPUT(event:Event):void{
			var num:int = parseFloat(wField.text);
			if(num<3) return;
			super.widthGreed = num;
		}
		private function WIDTH_FOCUS_OUT(event:Event):void{
			var num:int = parseFloat(wField.text);
			if(num<2) {
				super.widthGreed = 2;
				wField.text = '2';
			}else super.widthGreed = num;
		}
		
		
		private function HEIGHT_TEXT_INPUT(event:Event):void{
			var num:int = parseFloat(hField.text);
			if(num<3) return;
			super.heightGreed = num;
		}
		private function HEIGHT_FOCUS_OUT(event:Event):void{
			var num:int = parseFloat(hField.text);
			if(num<2) {
				super.heightGreed = 2;
				hField.text = '2';
			}else super.heightGreed = num;
		}
		private function REMOVE_MOUSE_DOWN(event:MouseEvent):void{
			super.saveFigure();
			super.clear();
			
		}
	}
	
}
