package source.BlockOfTask.Task.TaskObjects.GroupField {
	import source.BlockOfTask.Task.TaskObjects.BaseTan.BaseTan;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import source.MainPlayer;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import flash.geom.Rectangle;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import source.BlockOfTask.Task.SeparatTask;
	
	public class GroupFieldModel extends BaseTan{
		public static var CHECK_FIELD:String = 'onCheckField';
		internal var colorContainer:Sprite = new Sprite();
		internal var blackContainer:Sprite = new Sprite();
		private var arrObject:Array = new Array();
		private var arrVisible:Array = new Array();
		
		private var isTan:Boolean = true;
		private var isField:Boolean = false;
		private var isAlpha:Boolean = false;
		
		private var colorStand:Boolean = false;
		private var wField:Number;
		private var hField:Number;
		
		private var jump:Number = 20;

		private var currentLabel:String = '';
		
		public function GroupFieldModel(colorContainer:Sprite, blackContainer:Sprite) {
			super();
			colorContainer.addChild(this.colorContainer);
			super.tanColor = this.colorContainer;
			
			blackContainer.addChild(this.blackContainer);
			super.tanBlack = this.blackContainer;
			this.colorContainer.mouseChildren = false;
			this.blackContainer.mouseChildren = false;
			this.colorContainer.mouseEnabled = true;
		}
		public function set inJump(value:Number):void{
			jump = value;
		}
		
		override public function set width(value:Number):void{
			this.wField = value;
		}
		override public function set height(value:Number):void{
			this.hField = value;
		}
		override public function get width():Number{
			return wField;
		}
		override public function get height():Number{
			return hField;
		}
		override public function set colorX(value:Number):void{
			colorContainer.x = value;
		}
		override public function set colorY(value:Number):void{
			colorContainer.y = value;
		}
		public function set blackX(value:Number):void{
			blackContainer.x = value;
		}
		public function set blackY(value:Number):void{
			blackContainer.y = value;
		}
		
		/*override public function get colorX():Number{
			return colorContainer.x;
		}
		override public function get colorY():Number{
			return colorContainer.y;
		}
		override public function get blackX():Number{
			return blackContainer.x;
		}
		override public function get blackY():Number{
			return blackContainer.y;
		}*/
		
		
		override public function set colorR(value:int):void{
			colorContainer.rotation = value;
		}
		override public function get colorR():int{
			return colorContainer.rotation;
		}
		override public function set blackR(value:int):void{
			blackContainer.rotation = value;
		}
		override public function get blackR():int{
			return blackContainer.rotation;
		}
				
		private var clickTimer:Timer = new Timer(200, 1);
		private var isClick:Boolean = false;
		private function CONTAINER_FIELD_MOUSE_DOWN(event:MouseEvent):void{
			if(this.isField){
				MainPlayer.STAGE.addEventListener(MouseEvent.MOUSE_UP, CONTAINER_FIELD_MOUSE_UP);
				isClick = true;
				clickTimer.addEventListener(TimerEvent.TIMER, CLICK_TIMER);
				clickTimer.start();
				if(!this.isTan){
					if(super.animationToDown != ''){
						this.currentLabel = super.animationToDown;
						//super.animationToDown = '';
						this.dispatchEvent(new Event(SeparatTask.GET_LABEL_ANIMATION));
					}
				}
			}
		}
		private function CLICK_TIMER(event:TimerEvent = null):void{
			clickTimer.removeEventListener(TimerEvent.TIMER, CLICK_TIMER);
			isClick = false;
		}
		private function CONTAINER_FIELD_MOUSE_UP(event:MouseEvent):void{
			if(this.isField){
				MainPlayer.STAGE.removeEventListener(MouseEvent.MOUSE_UP, CONTAINER_FIELD_MOUSE_UP);
				if(isClick){
					clickTimer.stop();
					CLICK_TIMER();
					FIELD_CLICK();
				}
			}
			if(this.stand && super.animationToComplate != ''){
				this.currentLabel = super.animationToComplate;
				//super.animationToComplate = '';
				this.dispatchEvent(new Event(SeparatTask.GET_LABEL_ANIMATION));
			}
			super.dispatchEvent(new Event(CHECK_FIELD));
		}
		private function FIELD_CLICK(event:MouseEvent = null):void{
			trace(this + ': FIELD CLICK')
			var i:int;
			var l:int;
			l = arrObject.length;
			var remNum:int;
			for(i=0;i<l;i++){
				if(arrObject[i].tanColor.visible){
					remNum = i;
					break;
				}
			}
			arrObject[remNum].tanColor.visible = false;
			if(remNum == l-1) arrObject[0].tanColor.visible = true;
			else arrObject[remNum+1].tanColor.visible = true;
		}
		private function COLOR_KEY_DOWN(event:KeyboardEvent):void{
			switch(event.keyCode){
				case Keyboard.LEFT: colorR += 5; break;
				case Keyboard.RIGHT: colorR -= 5; break;
			}
		}
		private function COLOR_MOUSE_DOWN(event:MouseEvent):void{
			trace(this + ': FIELD DOWN')
			if(super.animationToDown != ''){
				this.currentLabel = super.animationToDown;
				//super.animationToDown = '';
				this.dispatchEvent(new Event(SeparatTask.GET_LABEL_ANIMATION));
			}
			colorContainer.startDrag();
			MainPlayer.STAGE.addEventListener(MouseEvent.MOUSE_UP, COLOR_MOUSE_UP);
			this.colorStand = false;
			//super.dispatchEvent(new Event(GET_SETTINGS));
		}
		
		private function COLOR_MOUSE_UP(event:MouseEvent):void{
			trace(this + ': FIELD UP')
			colorContainer.stopDrag();
			MainPlayer.STAGE.removeEventListener(MouseEvent.MOUSE_UP, COLOR_MOUSE_UP);
			if(!fieldComplete) return;
			if(colorR == blackR || colorR-360 == blackR || colorR == blackR - 360) {
				if(Math.abs(colorContainer.x-blackContainer.x)<this.jump && Math.abs(colorContainer.y-blackContainer.y)<this.jump){
					colorContainer.x = blackContainer.x;
					colorContainer.y = blackContainer.y;
					this.colorStand = true;
				}
			}
			if(this.stand && super.animationToComplate != ''){
				this.currentLabel = super.animationToComplate;
				//super.animationToComplate = '';
				this.dispatchEvent(new Event(SeparatTask.GET_LABEL_ANIMATION));
			}
			super.dispatchEvent(new Event(CHECK_FIELD));
		}
				
		/*override public function get tanColor():Sprite{
			return colorContainer;
		}*/
		public function addObject(value:*, idLabel:int, vis:Boolean = true):void{
			var ID:int = arrObject.length;
			arrObject.push(value);
			arrVisible.push(vis);
			correctFieldEnabled();			
		}
		
		public function set blackAlpha(value:Boolean):void{
			isAlpha = value;
			(value)?blackContainer.alpha = 0.2:blackContainer.alpha = 1;
		}
		public function get blackAlpha():Boolean{
			return isAlpha;
		}
		public function set tan(value:Boolean):void{
			this.isTan = value;
			if(value){
				blackContainer.visible = true;
				this.colorContainer.tabEnabled = true;
				this.colorContainer.addEventListener(MouseEvent.MOUSE_DOWN, COLOR_MOUSE_DOWN);
				this.colorContainer.addEventListener(KeyboardEvent.KEY_DOWN, COLOR_KEY_DOWN);
			}else{
				blackContainer.visible = false;
			}
		}
		public function get tan():Boolean{
			return this.isTan;
		}
		
		
		public function set field(value:Boolean):void{
			this.isField = value;
			if(value){
				colorContainer.addEventListener(MouseEvent.MOUSE_DOWN, CONTAINER_FIELD_MOUSE_DOWN);
			}else{
				var i:int;
				var l:int;
				l = arrObject.length;
				for(i=0;i<l;i++){
					arrObject[i].tanBlack.visible = arrObject[i].tanColor.visible = true;
				}
			}
			
		}
		public function get field():Boolean{
			return this.isField;
		}
		private function correctFieldEnabled():void{
			if(!this.isField) return;
			arrObject[0].tanColor.visible = true;
			var i:int;
			var l:int;
			var flag:Boolean = true;
			l = arrObject.length;
			for(i=1;i<l;i++){
				arrObject[i].tanColor.visible = false;
			}
			for(i=0;i<l;i++){
				if(this.arrVisible[i])	arrObject[i].tanBlack.visible = true;
				else arrObject[i].tanBlack.visible = false;
			}
		}
		
		override public function get stand():Boolean{
			if(!isField && !isTan) return true;
			if(!isTan) return fieldComplete;
			if(!isField) return this.colorStand;
			if(isField && isTan) return fieldComplete && this.colorStand;
			return true;
		}
		private function get fieldComplete():Boolean{
			if(!isField) return true;
			var i:int;
			var l:int;
			l = arrObject.length;
			for(i=0;i<l;i++){
				if(arrObject[i].tanColor.visible && this.arrVisible[i]) return true;
			}
			return false;
		}
		override public function get animationLabel():String{
			var outStr:String = this.currentLabel;
			this.currentLabel = '';
			return outStr;
		}
		
		override public function showAnswer():void{
			if(isTan){
				super.showAnswer();
			}
			if(isField){
				var i:int;
				var l:int;
				l = arrObject.length;
				for(i=0;i<l;i++){
					arrObject[i].tanColor.visible = false;
				}
				l = arrVisible.length;
				for(i=0;i<l;i++){
					if(arrVisible[i]){
						arrObject[i].tanColor.visible = true;
					}
				}
			}
		}
	}	
}
