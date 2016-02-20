package source.Task.TaskObjects.ShiftField {
	import flash.display.Sprite;
	import source.utils.Figure;
	import source.Task.TaskObjects.UserTan.OneUserTan;
	import source.Task.TaskObjects.PictureTan.OnePictureTan;
	import flash.utils.ByteArray;
	import flash.display.Bitmap;
	import source.Task.TaskObjects.Label.LabelClass;
	import source.Task.TaskObjects.BaseTan.BaseTan;
	import source.Task.TaskObjects.Label.ExtendLabel;
	import flash.events.Event;
	
	public class OneMaskField extends Sprite {
		
		
		private var background:Sprite = new Sprite();
		private var container:Sprite = new Sprite();
		private var maskfield:Sprite = new Sprite();
		
		private var wField:Number = 10;
		private var hField:Number = 10;
		
		private var inObject:*;
		
		public function OneMaskField() {
			super();
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
			var lineColor:uint;
			if(value) lineColor = 0x0000BB;
			else lineColor = 0x4B4B4B;
			Figure.insertRect(background, this.width, this.height, 1, 1, lineColor, 1, 0xB4B4B4);
			Figure.insertRect(maskfield, this.width+2, this.height+2);
		}
		public function xml(value:XMLList, content:* = null, name:String = ''):void{
			while(container.numChildren>0) container.removeChildAt(0);
			trace(this + ': NAME XML = ' + value.name());
			var vis:Boolean = true;
			if(value.@visible!='') vis = value.@visible.toString()=='true';
			switch(value.name().toString()){
				case 'USERTAN':
					trace(this + ': ADD USER TAN');
					
					inObject = new OneUserTan(value, container, new Sprite(), content as Bitmap, name);
					inObject.addEventListener(BaseTan.REMOVE_TAN, CLEAR_FIELD);
				break;
				case 'PICTURETAN':
					trace(this + ': ADD PICTURE TAN');
					inObject = new OnePictureTan(value, container, new Sprite());
					inObject.image = content as ByteArray;
					inObject.addEventListener(BaseTan.REMOVE_TAN, CLEAR_FIELD);
					//super.addObject(pictTan, 2, vis);
				break;
				case 'LABEL':
					inObject = new LabelClass(value, container, new Sprite(), new Sprite());
					inObject.reset();
					inObject.addEventListener(ExtendLabel.REMOVE_LABEL, CLEAR_FIELD);
				break;
			}
			
		}
		private function CLEAR_FIELD(event:Event):void{
			while(container.numChildren>0) container.removeChildAt(0);
			inObject = null;
		}
		public function get listPosition():XMLList{
			var outXml:XMLList = new XMLList('<FIELD/>');
			outXml.@width = this.width;
			outXml.@height = this.height;
			if(inObject!=null) outXml.appendChild(inObject.listPosition);
			return outXml;
		}

	}
	
}
