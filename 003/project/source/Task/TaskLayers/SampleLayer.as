package source.Task.TaskLayers {
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.events.MouseEvent;
	import source.utils.Figure;
	import flash.text.TextFormat;
	import flash.events.Event;
	
	public class SampleLayer extends Sprite{
		public static var LAYER_MOUSE_DOWN:String = 'onLayerMouseDown';
		public static var LAYER_ENABLED:String = 'onLayerEnabled';
		public static var LAYER_VISIBLE:String = 'onLayerVisible';
		
		private static const wPoint:Number = 18;
		private static const hPoint:Number = 18;
		private static const wLabel:Number = 150;
		
		private static const downColor:uint = 0x696969;
		private static const outColor:uint = 0xB9B9B9;
		private static const overColor:uint = 0x999999;
		
		
		private var visiblePoint:Sprite = new Sprite();
		private var enabledPoint:Sprite = new Sprite();
		private var isEnabled:Boolean = true;
		private var isVisible:Boolean = true;
		private var labelPoint:Sprite = new Sprite();
		private var field:TextField = new TextField();
		
		private var enabledBut:LayerEnabledBut = new LayerEnabledBut();
		private var visibleBut:LayerVisibleBut = new LayerVisibleBut();
		
		private var id:int;
		private var arrData:Array;
		public function SampleLayer() {
			super();
			initSample();
		}
		private function initSample():void{
			super.addChild(visiblePoint);
			super.addChild(enabledPoint);
			super.addChild(labelPoint);
			
			
			enabledPoint.x = wPoint;
			labelPoint.x = wPoint*2;
			VISIBLE_MOUSE_OUT();
			ENABLED_MOUSE_OUT();
			LABEL_MOUSE_OUT();
			
			visibleBut.x = visiblePoint.width/2;
			visibleBut.y = visiblePoint.height/2;
			
			enabledBut.x = enabledPoint.width/2;
			enabledBut.y = enabledPoint.height/2;
			visibleBut.mouseEnabled = false;
			enabledBut.mouseEnabled = false;
			
			visiblePoint.addChild(visibleBut);
			enabledPoint.addChild(enabledBut);
			
			var format:TextFormat = new TextFormat();
			format.size = 13;
			format.bold = true;
			field.defaultTextFormat = format;
			field.height = hPoint;
			field.width = wLabel;
			labelPoint.addChild(field);
			field.mouseEnabled = false;
			visiblePoint.addEventListener(MouseEvent.MOUSE_OVER, VISIBLE_MOUSE_OVER);
			visiblePoint.addEventListener(MouseEvent.MOUSE_OUT, VISIBLE_MOUSE_OUT);
			visiblePoint.addEventListener(MouseEvent.MOUSE_DOWN, VISIBLE_MOUSE_DOWN);
			visiblePoint.addEventListener(MouseEvent.MOUSE_UP, VISIBLE_MOUSE_OVER);
			enabledPoint.addEventListener(MouseEvent.MOUSE_OVER, ENABLED_MOUSE_OVER);
			enabledPoint.addEventListener(MouseEvent.MOUSE_OUT, ENABLED_MOUSE_OUT);
			enabledPoint.addEventListener(MouseEvent.MOUSE_DOWN, ENABLED_MOUSE_DOWN);
			enabledPoint.addEventListener(MouseEvent.MOUSE_UP, ENABLED_MOUSE_OVER);
			labelPoint.addEventListener(MouseEvent.MOUSE_OVER, LABEL_MOUSE_OVER);
			labelPoint.addEventListener(MouseEvent.MOUSE_OUT, LABEL_MOUSE_OUT);
			labelPoint.addEventListener(MouseEvent.MOUSE_DOWN, LABEL_MOUSE_DOWN);
			labelPoint.addEventListener(MouseEvent.MOUSE_UP, LABEL_MOUSE_OVER);
		}
		private function VISIBLE_MOUSE_OVER(e:MouseEvent = null):void{
			visiblePoint.graphics.clear();
			Figure.insertRect(visiblePoint, wPoint, hPoint, 1, 1, 0xFFFFFF, 1, overColor);
		}
		private function VISIBLE_MOUSE_OUT(e:MouseEvent = null):void{
			visiblePoint.graphics.clear();
			Figure.insertRect(visiblePoint, wPoint, hPoint, 1, 1, 0xFFFFFF, 1, outColor);
		}
		private function VISIBLE_MOUSE_DOWN(e:MouseEvent = null):void{
			visiblePoint.graphics.clear();
			Figure.insertRect(visiblePoint, wPoint, hPoint, 1, 1, 0xFFFFFF, 1, downColor);
			super.dispatchEvent(new Event(LAYER_VISIBLE));
		}
		
		
		private function ENABLED_MOUSE_OVER(e:MouseEvent = null):void{
			enabledPoint.graphics.clear();
			Figure.insertRect(enabledPoint, wPoint, hPoint, 1, 1, 0xFFFFFF, 1, overColor);
		}
		private function ENABLED_MOUSE_OUT(e:MouseEvent = null):void{
			enabledPoint.graphics.clear();
			Figure.insertRect(enabledPoint, wPoint, hPoint, 1, 1, 0xFFFFFF, 1, outColor);
		}
		private function ENABLED_MOUSE_DOWN(e:MouseEvent = null):void{
			enabledPoint.graphics.clear();
			Figure.insertRect(enabledPoint, wPoint, hPoint, 1, 1, 0xFFFFFF, 1, downColor);
			super.dispatchEvent(new Event(LAYER_ENABLED));
		}
		
		
		private function LABEL_MOUSE_OVER(e:MouseEvent = null):void{
			labelPoint.graphics.clear();
			Figure.insertRect(labelPoint, wLabel, hPoint, 1, 1, 0xFFFFFF, 1, overColor);
		}
		private function LABEL_MOUSE_OUT(e:MouseEvent = null):void{
			labelPoint.graphics.clear();
			Figure.insertRect(labelPoint, wLabel, hPoint, 1, 1, 0xFFFFFF, 1, outColor);
		}
		private function LABEL_MOUSE_DOWN(e:MouseEvent = null):void{
			labelPoint.graphics.clear();
			Figure.insertRect(labelPoint, wLabel, hPoint, 1, 1, 0xFFFFFF, 1, downColor);
			super.dispatchEvent(new Event(LAYER_MOUSE_DOWN));
		}
		
		
		
		
		
		public function set ID(value:int):void{
			id = value;
		}
		public function get ID():int{
			return id;
		}
		public function set layer(value:Array):void{
			//trace(this + ' VALUE LAYER = ' + value);
			arrData = value;
			this.text = arrData[1];
			this.enabled = true;
			this.visible = true;
		}
		public function get layer():Array{
			return arrData;
		}
		public function set text(value:String):void{
			field.text = value;
		}
		
		public function set enabled(value:Boolean):void{
			isEnabled = value;
			enabledBut.visible = !value;
			arrData[0].mouseEnabled = value;
			arrData[0].mouseChildren = value;
		}
		public function get enabled():Boolean{
			return isEnabled;
		}
		override public function set visible(value:Boolean):void{
			isVisible = value;
			visibleBut.visible = value;
			arrData[0].visible = value;
		}
		override public function get visible():Boolean{
			return isVisible;
		}
		
		public function clear():void{
			visiblePoint.removeEventListener(MouseEvent.MOUSE_OVER, VISIBLE_MOUSE_OVER);
			visiblePoint.removeEventListener(MouseEvent.MOUSE_UP, VISIBLE_MOUSE_OVER);
			visiblePoint.removeEventListener(MouseEvent.MOUSE_OUT, VISIBLE_MOUSE_OUT);
			visiblePoint.removeEventListener(MouseEvent.MOUSE_DOWN, VISIBLE_MOUSE_DOWN);
			enabledPoint.removeEventListener(MouseEvent.MOUSE_OVER, ENABLED_MOUSE_OVER);
			enabledPoint.removeEventListener(MouseEvent.MOUSE_UP, ENABLED_MOUSE_OVER);
			enabledPoint.removeEventListener(MouseEvent.MOUSE_OUT, ENABLED_MOUSE_OUT);
			enabledPoint.removeEventListener(MouseEvent.MOUSE_DOWN, ENABLED_MOUSE_DOWN);
			labelPoint.removeEventListener(MouseEvent.MOUSE_OVER, LABEL_MOUSE_OVER);
			labelPoint.removeEventListener(MouseEvent.MOUSE_OUT, LABEL_MOUSE_OUT);
			labelPoint.removeEventListener(MouseEvent.MOUSE_DOWN, LABEL_MOUSE_DOWN);
			labelPoint.removeEventListener(MouseEvent.MOUSE_UP, LABEL_MOUSE_OVER);
			super.removeChild(visiblePoint);
			super.removeChild(enabledPoint);
			super.removeChild(labelPoint);
			labelPoint.removeChild(field);
			field = null;
			labelPoint = null;
			enabledPoint = null;
			visiblePoint = null;
		}
		public function get idLayer():Number{
			return arrData[2];
		}
	}
	
}
