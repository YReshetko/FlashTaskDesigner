package source.utils.TestCounter {
	import flash.display.Sprite;
	import flash.text.*;
	import flash.events.MouseEvent;
	import flash.events.Event;
	public class CounterViewr extends Sprite{
		private static const txtLabel:String = "Всего/Текущее/Выполнено\n";
		
		private var mainSprite:Sprite = new Sprite;
		private var textSprite:Sprite = new Sprite;
		private var pointSprite:Sprite = new Sprite;
		private var maskSprite:Sprite = new Sprite;
		
		private var currentPosition:Number = 0;
		
		private var pointArr:Array = new Array;
		private var testField:TextField;
		
		private var panelOnPress:Boolean = false;
		private var pWidth:Number;
		public function CounterViewr(W:Number) {
			super();
			pWidth = W;
			if(W>15) initLayer(W);
		}
		
		public function initPanel(numTask:int){
			var i:int;
			testField = setField();
			textSprite.addChild(testField);
			for(i=0;i<numTask;i++){
				pointArr.push(new Sprite);
				setPointTask(pointArr[i], (i+1));
				pointSprite.addChild(pointArr[i]);
				pointArr[i].y = 12.5;
				pointArr[i].x = 12.5 + (25*i);
			}
			pointSprite.mouseChildren = false;
			textSprite.mouseChildren = false;
		}
		public function setText(s:String){
			testField.text = txtLabel+s;
		}
		public function changColorPoint(num:int, color:String){
			if(pointArr[num]!=undefined) redrawPointTask(pointArr[num], color);
		}
		public function setCurrentPoint(num:int){
			if(pointSprite.width>pWidth){
				if(25*num>pWidth/2){
					currentPosition = pWidth/2 - 25*num;
				}else{
					currentPosition = 0;
				}
				if(currentPosition <= pWidth - pointSprite.width) currentPosition = pWidth - pointSprite.width-4.5;
				gotoCurrentPosition();
			}
		}
		private function gotoCurrentPosition(){
			pointSprite.addEventListener(Event.ENTER_FRAME, MOVER_POSITION);
		}
		private function MOVER_POSITION(e:Event){
			if(Math.abs(pointSprite.x - currentPosition)>0.5){
				pointSprite.x +=  (currentPosition - pointSprite.x)/5;
			}else{
				pointSprite.x =  currentPosition;
				pointSprite.removeEventListener(Event.ENTER_FRAME, MOVER_POSITION);
			}
		}
		private function initLayer(W:Number){
			drawMain(W);
			drawMask(W);
			super.addChild(mainSprite);
			mainSprite.x = 1;
			mainSprite.y = 1;
			mainSprite.addChild(textSprite);
			mainSprite.addChild(pointSprite);
			//pointSprite.y = 27;
			textSprite.y = 27;
			super.addChild(maskSprite);
			mainSprite.mask = maskSprite;
			mainSprite.addEventListener(MouseEvent.MOUSE_DOWN, MAIN_MOUSE_DOWN);
		}
		private function drawMask(W:Number){
			maskSprite.graphics.lineStyle(0.1, 0x000000, 1);
			maskSprite.graphics.beginFill(0x999999, 1);
			maskSprite.graphics.drawRect(0,0,W+2,27);
			maskSprite.graphics.endFill();
		}
		private function drawMain(W:Number){
			mainSprite.graphics.lineStyle(0.1, 0x000000, 0);
			mainSprite.graphics.beginFill(0x999999, 0);
			mainSprite.graphics.drawRect(0,0,W,25);
			mainSprite.graphics.endFill();
		}
		private function setField():TextField{
			var field:TextField = new TextField();
			var textFormat:TextFormat = new TextFormat();
			textFormat.color = 0x000000;//	цвет текста только чёрный
			textFormat.size = 11;//	размер шрифта
			textFormat.bold = true;
			textFormat.align = "center";//	выравнивание по центру
			field.width = 150;
			field.height = 35;
			field.type = TextFieldType.DYNAMIC;
			field.mouseEnabled = false;
			field.defaultTextFormat = textFormat;
			return field;
		}
		private function setPointTask(spr:Sprite, num:int){
			spr.graphics.lineStyle(0.1, 0x000000, 1);
			spr.graphics.beginFill(0x999999, 1);
			spr.graphics.drawCircle(0, 0, 8);
			spr.graphics.endFill();
			var field:TextField = new TextField();
			var textFormat:TextFormat = new TextFormat();
			textFormat.color = 0x000000;//	цвет текста только чёрный
			textFormat.size = 12;//	размер шрифта
			textFormat.bold = true;
			textFormat.align = 'center';
			field.autoSize = TextFieldAutoSize.CENTER;
			field.type = TextFieldType.DYNAMIC;
			field.mouseEnabled = false;
			field.defaultTextFormat = textFormat;
			field.text = num.toString();
			field.height = field.textHeight;
			field.width = field.textWidth;
			spr.addChild(field);
			field.x = - field.width/2;
			field.y = - field.height/2;
		}
		private function redrawPointTask(spr:Sprite, color:String){
			spr.graphics.clear();
			spr.graphics.lineStyle(0.1, 0x000000, 1);
			spr.graphics.beginFill(uint(parseInt(color)), 1);
			spr.graphics.drawCircle(0, 0, 8);
			spr.graphics.endFill();
		}
		private function MAIN_MOUSE_DOWN(e:MouseEvent){
			//trace("PANEL MOUSE_DOWN");
			panelOnPress = true;
			var remPos:int = textSprite.y;
			textSprite.y = pointSprite.y;
			pointSprite.y = remPos;
		}
		public function getOnPress():Boolean{
			return panelOnPress
		}
		public function defaultOnPress(){
			panelOnPress = false
		}
	}
}