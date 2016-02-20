package source.Task.Animation.AroundPoint {
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.events.MouseEvent;
	
	public class LabelPoint extends Sprite{
		private var labelID:int;
		private static var w:Number = 26;
		private static var h:Number = 22;
		
		private var field:TextField = new TextField();
		private var bgSprite:Sprite = new Sprite();
		private var depth:int;
		public function LabelPoint(id:int) {
			super();
			labelID = id;
			initLabel();
		}
		private function initLabel():void{
			show = false;
			
			field.background = false;
			field.border = false;
			field.autoSize = TextFieldAutoSize.LEFT;
			var format:TextFormat = new TextFormat();
			format.bold = true;
			format.size = 13;
			field.setTextFormat(format);
			field.defaultTextFormat = format;
			field.text = (labelID+1).toString();
			super.addChild(bgSprite);
			super.addChild(field);
			bgSprite.x = -1*bgSprite.width/2;
			bgSprite.y = -1*bgSprite.height/2;
			field.x = -1*field.width/2;
			field.y = -1*field.height/2;
			field.mouseEnabled = false;
			field.tabEnabled = false;
			bgSprite.mouseEnabled = false;
			bgSprite.tabEnabled = false;
			super.addEventListener(MouseEvent.MOUSE_OVER, LABEL_MOUSE_OVER);
			super.addEventListener(MouseEvent.MOUSE_OUT, LABEL_MOUSE_OUT);
		}
		public function set show(value:Boolean):void{
			var a:Number;
			if(value) a = 1;
			else a = 0.5;
			bgSprite.graphics.clear();
			bgSprite.graphics.lineStyle(1, 0xFFFF00, a-0.5);
			bgSprite.graphics.beginFill(0x999999, a);
			bgSprite.graphics.drawRoundRect(0, 0, w, h, 15, 15);
			bgSprite.graphics.endFill();
			
			if(value) field.textColor = 0x660033;
			else field.textColor = 0x000000;
		}
		private function LABEL_MOUSE_OVER(event:MouseEvent):void{
			depth = super.parent.getChildIndex(super);
			super.parent.setChildIndex(super, super.parent.numChildren-1);
			show = true;
			super.scaleX = super.scaleY = 1.1;
		}
		private function LABEL_MOUSE_OUT(event:MouseEvent):void{
			super.parent.setChildIndex(super, depth);
			show = false;
			this.scaleX = this.scaleY = 1;
		}
		public function get ID():int{
			return labelID;
		}

	}
	
}
