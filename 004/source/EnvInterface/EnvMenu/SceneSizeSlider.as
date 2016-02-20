package source.EnvInterface.EnvMenu {
	import flash.display.Sprite;
	import flash.text.TextField;
	import source.EnvUtils.EnvDraw.Figure;
	import flash.text.TextFormat;
	import flash.geom.Rectangle;
	import flash.events.MouseEvent;
	import source.MainEnvelope;
	import flash.text.TextFieldType;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import flash.events.Event;
	import flash.net.SharedObject;
	
	public class SceneSizeSlider extends Sprite{
		public static var GET_PERCENT:String = 'onGetPercent';
		
		private var sliderBackground:Sprite = new Sprite();
		private var sliderButton:Sprite = new Sprite();
		private var sliderField:TextField = new TextField();
		private var rect:Rectangle;
		private var percent:Number = 100;
		
		private var settings:SharedObject;
		public function SceneSizeSlider() {
			super();
			settings = SharedObject.getLocal('MainWindowSize');
			initSlider();
			loadPercent();
		}
		private function initSlider():void{
			drawBackground();
			drawButton();
			drawField();
			
			super.addChild(sliderBackground);
			super.addChild(sliderButton);
			super.addChild(sliderField);
			sliderField.x = sliderBackground.width + 10;
			sliderField.text = '100%';
			
			sliderButton.x = 50;
			
			rect = new Rectangle(1, 0, 99, 0);
			
			sliderButton.addEventListener(MouseEvent.MOUSE_DOWN, SLIDER_MOUSE_DOWN);
			sliderBackground.addEventListener(MouseEvent.MOUSE_DOWN, BACKGROUND_MOUSE_DOWN);
			sliderField.addEventListener(MouseEvent.CLICK, FIELD_CLICK);
		}
		
		private function drawBackground():void{
			Figure.insertCurve(sliderBackground, [[0,18],[100, 18],[100, 4],[0,18]], 1, 1, 0xAAAAAA, 1, 0xBBBBBB);
		}
		private function drawButton():void{
			Figure.insertCurve(sliderButton, [[-2, 2], [-2, 20], [2, 20], [2, 2], [-2, 2]], 1, 1, 0x9D9D9D, 1, 0x9E9E9E);
		}
		private function drawField():void{
			sliderField.height = Menu.MENU_HEIGHT-4;
			sliderField.width = 35;
			sliderField.y = 2;
			var format:TextFormat = new TextFormat();
			format.size = 13;
			sliderField.defaultTextFormat = format;
			
		}
		private function BACKGROUND_MOUSE_DOWN(event:MouseEvent):void{
			if(event.localX<2) sliderButton.x = 1;
			else sliderButton.x = event.localX;
			SLIDER_MOUSE_MOVE(null);
			SLIDER_MOUSE_DOWN(null);
		}
		private function SLIDER_MOUSE_DOWN(event:MouseEvent):void{
			MainEnvelope.STAGE.addEventListener(MouseEvent.MOUSE_UP, SLIDER_MOUSE_UP);
			MainEnvelope.STAGE.addEventListener(MouseEvent.MOUSE_MOVE, SLIDER_MOUSE_MOVE);
			sliderButton.startDrag(false, rect);
		}
		private function SLIDER_MOUSE_UP(event:MouseEvent):void{
			MainEnvelope.STAGE.removeEventListener(MouseEvent.MOUSE_UP, SLIDER_MOUSE_UP);
			MainEnvelope.STAGE.removeEventListener(MouseEvent.MOUSE_MOVE, SLIDER_MOUSE_MOVE);
			sliderButton.stopDrag();
			SLIDER_MOUSE_MOVE(null);
			
		}
		private function SLIDER_MOUSE_MOVE(event:MouseEvent):void{
			percent = sliderButton.x*2;
			sliderField.text = percent.toString() + '%';
			savePercent();
			super.dispatchEvent(new Event(GET_PERCENT));
		}
		
		private function FIELD_CLICK(event:MouseEvent):void{
			sliderField.removeEventListener(MouseEvent.CLICK, FIELD_CLICK);
			sliderField.background = true;
			sliderField.border = true;
			sliderField.text = percent.toString();
			sliderField.type = TextFieldType.INPUT;
			MainEnvelope.STAGE.focus = sliderField;
			sliderField.setSelection(0, sliderField.text.length);
			sliderField.restrict = '0-9';
			sliderField.maxChars = 3;
			sliderField.addEventListener(FocusEvent.FOCUS_OUT, FIELD_FOCUS_OUT);
			sliderField.addEventListener(KeyboardEvent.KEY_DOWN, FIELD_KEY_DOWN);
		}
		private function FIELD_KEY_DOWN(event:KeyboardEvent):void{
			if(event.keyCode == Keyboard.ENTER) applyPercent();
		}
		private function FIELD_FOCUS_OUT(event:FocusEvent):void{
			applyPercent();
		}
		private function applyPercent():void{
			sliderField.removeEventListener(FocusEvent.FOCUS_OUT, FIELD_FOCUS_OUT);
			sliderField.removeEventListener(KeyboardEvent.KEY_DOWN, FIELD_KEY_DOWN);
			sliderField.addEventListener(MouseEvent.CLICK, FIELD_CLICK);
			if(parseInt(sliderField.text)>200) sliderField.text = '200';
			if(parseInt(sliderField.text)<2) sliderField.text = '2';
			sliderField.background = false;
			sliderField.border = false;
			
			sliderField.type = TextFieldType.DYNAMIC;
			percent = parseInt(sliderField.text);
			sliderField.text = percent.toString() + '%';
			sliderButton.x = percent/2;
			savePercent();
			super.dispatchEvent(new Event(GET_PERCENT));
		}
		
		public function get scale():Number{
			return percent;
		}
		
		private function savePercent():void{
			delete settings.data.percent;
			
			settings.data.percent = percent;
			try{
				settings.flush();
			}catch(error:Error){}
		}
		private function loadPercent():void{
			if(settings.data.percent != undefined){
				percent = parseInt(settings.data.percent.toString());
				sliderField.text = percent.toString() + '%';
				super.dispatchEvent(new Event(GET_PERCENT));	
			}
		}
	}
	
}
