package source.EnvComponents.EnvButton {
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import source.EnvUtils.EnvDraw.Figure;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFieldAutoSize;
	public class SimpleButton extends Sprite{
		//	цвета кнопки относительно позиции мыши
		private static const downColor:uint = 0x6D6D6D;
		private static const upColor:uint = 0xA6A6A6;
		private static const outColor:uint = 0xD6D6D6;
		private static const overColor:uint = 0xA6A6A6;
		//	параметры шрифта надписи
		private static var linkSize:int = 13;
		private static var linkColor:uint = 0x000000;
		private static var linkFont:String = 'Arial';
		private static var disableColor:uint = 0xAFAFAF;
		//	размер кнопки
		private var wButton:Number;
		private var hButton:Number;
		//	маска надписи
		private var labelMask:Sprite = new Sprite;
		//	строка надписи кнопки
		private var butLabel:String;
		//	поле надписи кнопки
		private var fieldLabel:TextField;
		
		public function SimpleButton(W:Number, H:Number, butLabel:String) {
			super();
			//	запоминаем имя кнопки
			this.butLabel = butLabel;
			//	отрисовываем имя кнопки
			drawLabel();
			//	определяем контенеры надписи и её маски
			initLabelContainer();
			//	отрисовываем кнопку
			updateButton(W, H);
			//	определяем слушателей
			initHandler();
		}
		//	метод определения контенеров отображения
		private function initLabelContainer():void{
			//	добавление поля надписи в супер класс-контенер
			super.addChild(fieldLabel);
			//	добавление маски кнопки в супер класс-контенер
			super.addChild(labelMask);
			//	определение маски для надписи
			fieldLabel.mask = labelMask;
		}
		//	отрисовка кнопки (перезагрузка)
		public function updateButton(W:Number, H:Number):void{
			wButton = W;
			hButton = H;
			//	метод отрисовки
			drawButton(outColor);
		}
		//	определения слушателей левой клавиши мыши и наведение/сведение курсора
		private function initHandler():void{
			super.addEventListener(MouseEvent.MOUSE_DOWN, BUTTON_MOUSE_DOWN);
			super.addEventListener(MouseEvent.MOUSE_UP, BUTTON_MOUSE_UP);
			super.addEventListener(MouseEvent.ROLL_OUT, BUTTON_ROLL_OUT);
			super.addEventListener(MouseEvent.ROLL_OVER, BUTTON_ROLL_OVER);
		}
		private function BUTTON_MOUSE_DOWN(e:MouseEvent):void{
			drawButton(downColor);
		}
		private function BUTTON_MOUSE_UP(e:MouseEvent):void{
			drawButton(upColor);
		}
		private function BUTTON_ROLL_OUT(e:MouseEvent):void{
			drawButton(outColor);
		}
		private function BUTTON_ROLL_OVER(e:MouseEvent):void{
			drawButton(overColor);
		}
		//	отрисовка кнопки
		private function drawButton(inColor:uint):void{
			Figure.insertRect(super, wButton, hButton, 1, 1, 0xAEAEAE, 1, inColor);
			//	отрисовка маски надписи
			Figure.insertRect(labelMask, wButton, hButton);
			//	определение позиции надписи
			if(fieldLabel.width>wButton){
				fieldLabel.x = 1;
			}else{
				fieldLabel.x = (wButton - fieldLabel.width)/2;
			}
		}
		//	метод отрисовки надписи кнопки
		private function drawLabel():void{
			//	определение текстового поля
			fieldLabel = new TextField();
			//	определение формата надписи
			var fieldFormat:TextFormat = new TextFormat();
			//	шрифт
			fieldFormat.font = linkFont;
			//	размер
			fieldFormat.size = linkSize;
			//	цвет
			fieldLabel.textColor = linkColor;
			//	присвоение формата надписи
			fieldLabel.defaultTextFormat = fieldFormat;
			//	запись текста 
			fieldLabel.text = butLabel;
			//	устанавливаем авторасширение в левый край
			fieldLabel.autoSize = TextFieldAutoSize.LEFT;
			//	делаем надпись невосприимчивой к курсору
			fieldLabel.mouseEnabled = false;
		}
		//	изменение параметра доступности кнопки
		public function enabled(f:Boolean):void{
			super.mouseChildren = f;
			super.mouseEnabled = f;
			super.tabChildren = f;
			if(f){
				fieldLabel.textColor = linkColor;
			}else{
				fieldLabel.textColor = disableColor
			}
		}
	}
	
}
