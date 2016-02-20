package source.Components {
	import flash.display.Sprite;
	import source.MainEnvelope;
	import flash.text.TextField;
	import flash.display.GradientType;
	import flash.geom.Matrix;
	import flash.display.SpreadMethod;
	import flash.events.MouseEvent;
	import flash.text.TextFormat;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import source.EnvInterface.EnvMenu.Menu;
	
	public class MessageWindow extends Sprite{
		public static var ERROR:String = 'Error';
		public static var WARNING:String = 'Warning';
		public static var LOADER:String = 'Loader';
		private static const hDrag:int = 15;
		private static const wWind:int = 450;
		private static const hText:int = 105;
		private static const wImag:int = 75;
		private static const hButt:int = 55;
		private static const wBar:int = 380;
		private static const hBar:int = 25;
		
		private var container:Sprite;
		private var window:Sprite = new Sprite();
		private var barContainer:Sprite = new Sprite();
		private var loadBar:Sprite = new Sprite();
		private var barContur:Sprite = new Sprite();
		
		private var errorLabel:ErrorLbl = new ErrorLbl();
		private var warningLabel:WarningLbl = new WarningLbl();
		
		private var startX:Number;
		private var startY:Number;
		
		private var field:TextField = new TextField();
		private var percentField:TextField = new TextField();
		private var label:TextField = new TextField();
		
		private var button:Array = new Array();
		private var dispatch:Array = new Array();
		
		private var rect:Rectangle;
		public function MessageWindow(container:Sprite, width:Number, height:Number) {
			super();
			this.container = container;
			startX = (width - wWind)/2;
			startY = (height - (hDrag + hText + hButt))/2;
			rect = new Rectangle(0, 0, width - wWind, height - (hDrag + hText + hButt) - Menu.MENU_HEIGHT);
			initWindow();
		}
		private function initWindow():void{
			window.graphics.lineStyle(1, 0x000000, 0);
			var colors:Array = [0x555555, 0xB9B9B9];
			var alphas:Array = [1, 1];
			var ratios:Array = [0x00, 0xFF];
			var matr:Matrix = new Matrix();
			matr.createGradientBox(wWind, hDrag, Math.PI/2, 0, 0);
			var spreadMethod:String = SpreadMethod.PAD;
			window.graphics.beginGradientFill(GradientType.LINEAR, colors, alphas, ratios, matr, spreadMethod);
			window.graphics.drawRect(0, 0, wWind, hDrag);
			window.graphics.endFill();
			window.graphics.beginFill(0xB9B9B9, 1);
			window.graphics.drawRect(0, hDrag, wWind, hText+hButt);
			window.graphics.endFill();
			window.addEventListener(MouseEvent.MOUSE_DOWN, DRAG_WINDOW);
			window.addChild(field);
			field.x = wImag;
			field.y = hDrag;
			field.width = wWind - wImag;
			field.height = hText;
			field.mouseEnabled = false;
			var format:TextFormat = new TextFormat('Arial', 12, 0x000000, true);
			field.wordWrap = true;
			field.multiline = true;
			field.defaultTextFormat = format;
			
			window.addChild(label);
			label.x = label.y = 0;
			label.width = 200;
			label.height = hDrag;
			label.mouseEnabled = false;
			format.size = 10;
			format.color = 0xFFFFFF;
			label.defaultTextFormat = format;
			
			window.addChild(errorLabel);
			errorLabel.x = (wImag - errorLabel.width)/2;
			errorLabel.y = hDrag + (hText - errorLabel.height)/2;
			window.addChild(warningLabel);
			warningLabel.x = (wImag - warningLabel.width)/2;
			warningLabel.y = hDrag + (hText - warningLabel.height)/2;
			warningLabel.visible = false;
			errorLabel.visible = false;
			
			loadBar.graphics.lineStyle(1, 0x000000, 0);
			loadBar.graphics.beginFill(0x00FF00, 1);
			loadBar.graphics.drawRect(0, 0, wBar, hBar);
			loadBar.graphics.endFill();
			
			barContur.graphics.lineStyle(0.1, 0x000000, 1);
			barContur.graphics.drawRect(0, 0, wBar, hBar);
			barContainer.addChild(loadBar);
			barContainer.addChild(barContur);
			barContainer.addChild(percentField);
			percentField.x = 0;
			percentField.y = 0;
			percentField.width = wBar;
			percentField.height = hBar;
			percentField.mouseEnabled = false;
			format.color = 0x000000;
			format.size = 13;
			format.bold = true;
			format.align = 'center';
			percentField.defaultTextFormat = format;
		}
		private function DRAG_WINDOW(event:MouseEvent):void{
			if(event.target == window){
				if(event.localY < hDrag){
					window.startDrag(false, rect);
					MainEnvelope.STAGE.addEventListener(MouseEvent.MOUSE_UP, STOP_DRAG_WINDOW);
				}
			}
		}
		private function STOP_DRAG_WINDOW(event:MouseEvent):void{
			MainEnvelope.STAGE.removeEventListener(MouseEvent.MOUSE_UP, STOP_DRAG_WINDOW);
			startX = window.x;
			startY = window.y;
			window.stopDrag();
		}
		
		
		/**
			Объект для открытия сообщения
			value.type:String - тип сообщения ошибка/предупреждение
			type = <ERROR, MESSAGE, LOADER>
			value.text:String - текст сообщения
			value.button:Array - массив имён кнопок для сообщения
			value.dispather:Array - массив констант для диспатча
		*/
		public function set message(value:Object):void{
			if(value.type == ERROR) {
				label.text = 'ОШИБКА';
				errorLabel.visible = true;
			}
			if(value.type == WARNING) {
				label.text = 'ПРЕДУПРЕЖДЕНИЕ';
				warningLabel.visible = true;
			}
			if(value.type == LOADER){
				label.text = 'ЗАГРУЗКА';
				window.addChild(barContainer);
				barContainer.x = (wWind-wBar)/2;
				barContainer.y = hDrag+hText+((hButt-hBar)/2);
				
			}
			field.text = value.text;
			var i:int;
			var l:int;
			l = value.dispather.length;
			for(i=0;i<l;i++){
				dispatch.push(value.dispather[i]);
			}
			l = value.button.length;
			for(i=0;i<l;i++){
				button.push(new Button(value.button[i]));
				window.addChild(button[i]);
				button[i].addEventListener(COEvent.CLICK, BUTTON_ON_CLICK);
			}
			replace();
			container.addChild(window);
			window.x = startX;
			window.y = startY;
		}
		/**
			value.text:String - текст сообщения
			value.complate - булево значение признака окончания загрузки
			value.total - общее число загружаемого материала
			value.current - текущее число загруженного материала
		*/
		public function set loading(value:Object):void{
			if(value.complate){
				clear();
			}else{
				var prom:int = int((value.current/value.total)*10000);
				var percent:Number = prom/100;
				loadBar.scaleX = percent/100;
				percentField.text = percent.toString() + ' %';
			}
		}
		private function BUTTON_ON_CLICK(event:Event):void{
			var i:int;
			var l:int;
			l = button.length;
			for(i=0;i<l;i++){
				if(event.target == button[i]){
					//trace(this + ': Dispatch = ' + dispatch[i]);
					super.dispatchEvent(new Event(dispatch[i]));
					clear();
					return;
				}
			}
			clear();
		}
		private function replace():void{
			var i:int;
			var l:int;
			var num:int;
			l = button.length;
			if(l>6) num = 3;
			else num = 4;
			var deltaX:Number;
			var deltaY:Number;
			deltaX = (wWind-num*110)/2;
			deltaY = hDrag + hText + (hButt - Math.floor(l/num)*25)/2;
			for(i=0;i<l;i++){
				button[i].x = deltaX + (i%num)*110;
				button[i].y = deltaY + Math.floor(i/num)*25;
			}
			
		}
		private function clear():void{
			if(container.contains(window))container.removeChild(window);
			errorLabel.visible = false;
			warningLabel.visible = false;
			if(window.contains(barContainer)) window.removeChild(barContainer);
			field.text = '';
			while(button.length>0){
				if(button[0].hasEventListener(COEvent.CLICK)) button[0].removeEventListener(COEvent.CLICK, BUTTON_ON_CLICK);
				if(window.contains(button[0])) window.removeChild(button[0]);
				button.shift();
			}
			while(dispatch.length>0){
				dispatch.shift();
			}
		}
	}
	
}
