package source.Task.TaskObjects.CoordinatePlane {
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.events.MouseEvent;
	import source.DesignerMain;
	
	public class OnePlane extends Sprite{
		private var step:int = 10;
		private var pWidth:Number = 300;
		private var pHeight:Number = 300;
		private var orientation:String = 'center';
		
		private var moveLabel:MoveLabel = new MoveLabel();
		
		private var xField:TextField;
		private var yField:TextField;
		
		private var xArray:Array = new Array();
		private var yArray:Array = new Array();
		public function OnePlane(container:Sprite, xml:XMLList) {
			super();
			container.addChild(super);
			this.xml = xml;
		}
		private function set xml(value:XMLList):void{
			pWidth = parseInt(value.@width)
			pHeight = parseInt(value.@height);
			super.x = parseInt(value.@x);
			super.y = parseInt(value.@y);
			initFields();
			drawPlane();
			super.addChild(moveLabel);
			moveLabel.addEventListener(MouseEvent.MOUSE_DOWN, MOVE_MOUSE_DOWN);
		} 
		private function initFields():void{
			xField = new TextField();
			yField = new TextField();
			var format:TextFormat = new TextFormat();
			format.size = 12;
			format.bold = true;
			xField.autoSize = TextFieldAutoSize.LEFT;
			yField.autoSize = TextFieldAutoSize.LEFT;
			xField.defaultTextFormat = format;
			yField.defaultTextFormat = format;
			super.addChild(xField);
			super.addChild(yField);
			xField.text = 'X';
			yField.text = 'Y';
		}
		private function drawPlane():void{
			super.graphics.clear();
			clearArray();
			var xCenter:Number;
			var yCenter:Number;
			
			
			if(orientation == 'center'){
				xCenter = pWidth/2;
				yCenter = pHeight/2;
			}else{
				xCenter = step + 5;
				yCenter = pHeight - step - 5;
			}
			xField.x = pWidth - 5;
			xField.y = yCenter;
			
			yField.x = xCenter + 5;
			yField.y = 0;
			
			super.graphics.lineStyle(2, 0, 1);
			super.graphics.moveTo(xCenter, pHeight);
			super.graphics.lineTo(xCenter, 0);
			super.graphics.moveTo(0, yCenter);
			super.graphics.lineTo(pWidth, yCenter);
			
			
			super.graphics.moveTo(xCenter-5, 10);
			super.graphics.lineTo(xCenter, 0);
			super.graphics.lineTo(xCenter+5, 10);
			
			super.graphics.moveTo(pWidth-10, yCenter-5);
			super.graphics.lineTo(pWidth, yCenter);
			super.graphics.lineTo(pWidth-10, yCenter+5);
			//	Рисуем вертикальные линии
			super.graphics.lineStyle(0.1, 0, 0.1);
			var currentX:Number = xCenter;
			xArray.push(currentX);
			while(true){
				currentX += step;
				if(currentX>pWidth-11) break;
				xArray.push(currentX);
				super.graphics.moveTo(currentX, 11);
				super.graphics.lineTo(currentX, pHeight);
			}
			currentX = xCenter;
			while(true){
				currentX -= step;
				if(currentX<0)break;
				xArray.push(currentX);
				super.graphics.moveTo(currentX, 11);
				super.graphics.lineTo(currentX, pHeight);
			}
			//	Рисуем горизонтальные линии
			var currentY:Number = yCenter;
			yArray.push(currentY);
			while(true){
				currentY += step;
				if(currentY>pHeight) break;
				yArray.push(currentY);
				super.graphics.moveTo(0, currentY);
				super.graphics.lineTo(pWidth-11, currentY);
			}
			currentY = yCenter;
			while(true){
				currentY -= step;
				if(currentY<11) break;
				yArray.push(currentY);
				super.graphics.moveTo(0, currentY);
				super.graphics.lineTo(pWidth-11, currentY);
			}
		}
		private function clearArray():void{
			while(xArray.length>0) xArray.shift();
			while(yArray.length>0) yArray.shift();
		}
		private function MOVE_MOUSE_DOWN(event:MouseEvent):void{
			DesignerMain.STAGE.addEventListener(MouseEvent.MOUSE_UP, MOVE_MOUSE_UP);
			super.startDrag();
		}
		private function MOVE_MOUSE_UP(event:MouseEvent):void{
			DesignerMain.STAGE.removeEventListener(MouseEvent.MOUSE_UP, MOVE_MOUSE_UP);
			super.stopDrag();
		}

	}
	
}
