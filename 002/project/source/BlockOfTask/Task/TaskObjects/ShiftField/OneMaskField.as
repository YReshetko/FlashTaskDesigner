package source.BlockOfTask.Task.TaskObjects.ShiftField {
	import flash.display.Sprite;
	import source.utils.Figure;
	import source.BlockOfTask.Task.TaskObjects.UserTan.OneUserTan;
	import source.BlockOfTask.Task.TaskObjects.PictureTan.OnePictureTan;
	import flash.utils.ByteArray;
	import flash.display.Bitmap;
	import source.BlockOfTask.Task.TaskObjects.Label.LabelClass;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.filters.BlurFilter;
	import flash.geom.Point;
	import source.MainPlayer;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	public class OneMaskField extends Sprite {
		public static var REPLACE_RIGHT:String = 'onReplaceReight';
		public static var REPLACE_LEFT:String = 'onReplaceLeft';
		public static var REPLACE_TOP:String = 'onReplaceTop';
		public static var REPLACE_BOTTOM:String = 'onReplaceBottom';
		
		public static var SELECT_FIELD:String = 'onSelectField';
		
		private var background:Sprite = new Sprite();
		private var container:Sprite = new Sprite();
		private var maskfield:Sprite = new Sprite();
		private var selectContainer:Sprite;
		
		private var wField:Number = 10;
		private var hField:Number = 10;
		
		private var inObject:*;
		
		private var indexI:int = 0;
		private var indexJ:int = 0;
		
		private var isSelect:Boolean = false;
		public function OneMaskField() {
			super();
			super.focusRect = null;
			initField();
			
		}
		
		
		private function initField():void{
			super.addChild(background);
			super.addChild(container);
			container.x = container.y = 1;
			super.addChild(maskfield);
			maskfield.x = maskfield.y = -1
			super.mask = maskfield;
			select = false;
			super.mouseChildren = false;
			super.addEventListener(MouseEvent.CLICK, ON_SELECT_FIELD);
		}
		private function drawSelectSprite():void{
			var spr:Sprite = new Sprite();
			spr.graphics.lineStyle(1, 0, 0);
			spr.graphics.beginFill(0x0000FF, 1);
			spr.graphics.drawRect(0, 0, this.width, this.height);
			spr.graphics.drawRect(5, 5, this.width-10, this.height-10);
			spr.graphics.endFill();
			var bmpData:BitmapData = new BitmapData(this.width, this.height, true, 0x00000000);
			bmpData.draw(spr, new Matrix());
			bmpData.applyFilter(bmpData, bmpData.rect, new Point(), new BlurFilter(6, 6, 2));
			var bitmap:Bitmap = new Bitmap(bmpData);
			bitmap.alpha = 0.7;
			selectContainer = new Sprite();
			this.selectContainer.addChild(bitmap);
		}
		override public function get width():Number{
			return wField;
		}
		override public function set width(value:Number):void{
			wField = value;
			this.select = false;
		}
		override public function get height():Number{
			return hField;
		}
		override public function set height(value:Number):void{
			hField = value;
			this.select = false;
		}
		public function set select(value:Boolean):void{
			isSelect = value;
			var lineColor:uint;
			if(value) {
				if(selectContainer == null) this.drawSelectSprite(); 
				lineColor = 0x0000BB;
				if(selectContainer != null) super.addChild(selectContainer);
			}
			else {
				lineColor = 0x4B4B4B;
				if(selectContainer != null) if(super.contains(selectContainer)) super.removeChild(selectContainer);
			}
			Figure.insertRect(background, this.width, this.height, 1, 1, lineColor, 1, 0xB4B4B4);
			Figure.insertRect(maskfield, this.width+2, this.height+2);
			if(value){
				//MainPlayer.STAGE.focus = this;
				MainPlayer.STAGE.addEventListener(KeyboardEvent.KEY_DOWN, FIELD_KEY_DOWN);
			}else{
				//MainPlayer.STAGE.focus = null;
				MainPlayer.STAGE.removeEventListener(KeyboardEvent.KEY_DOWN, FIELD_KEY_DOWN);
			}
			
		}
		private function FIELD_KEY_DOWN(event:KeyboardEvent):void{
			switch(event.keyCode){
				case Keyboard.RIGHT:
					super.dispatchEvent(new Event(REPLACE_RIGHT));
				break;
				case Keyboard.LEFT:
					super.dispatchEvent(new Event(REPLACE_LEFT));
				break;
				case Keyboard.UP:
					super.dispatchEvent(new Event(REPLACE_TOP));
				break;
				case Keyboard.DOWN:
					super.dispatchEvent(new Event(REPLACE_BOTTOM));
				break;
			}
		}
		public function get select():Boolean{
			return isSelect;
		}
		public function xml(value:XMLList, content:* = null, name:String = ''):void{
			trace(this + ': NAME XML = ' + value.name());
			var vis:Boolean = true;
			if(value.@visible!='') vis = value.@visible.toString()=='true';
			switch(value.name().toString()){
				case 'USERTAN':
					trace(this + ': ADD USER TAN');
					
					inObject = new OneUserTan(value, container, new Sprite(), content);
				break;
				case 'PICTURETAN':
					trace(this + ': ADD PICTURE TAN');
					inObject = new OnePictureTan(value, container, new Sprite());
					inObject.image = content as ByteArray;
					//super.addObject(pictTan, 2, vis);
				break;
				case 'LABEL':
					inObject = new LabelClass(value, container, new Sprite(), new Sprite());
					//inObject.reset();
				break;
			}
			drawSelectSprite();
		}
		
		private function ON_SELECT_FIELD(event:MouseEvent):void{
			super.dispatchEvent(new Event(SELECT_FIELD));
			//this.select = true;
			
		}
		
		public function get I():int{
			return indexI;
		}
		public function set I(value:int):void{
			indexI = value;
		}
		public function get J():int{
			return indexJ;
		}
		public function set J(value:int):void{
			indexJ = value;
		}
		
		public function get isEmpty():Boolean{
			if(inObject == null) return true;
			return false;
		}

	}
	
}
