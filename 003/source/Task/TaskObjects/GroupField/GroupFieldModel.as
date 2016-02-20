package source.Task.TaskObjects.GroupField {
	import source.Task.TaskObjects.BaseTan.BaseTan;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import source.DesignerMain;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import flash.geom.Rectangle;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	
	public class GroupFieldModel extends BaseTan{
		public static var COPY_OBJECT:String = 'onCopyObject';
		public static var REMOVE_TAN:String = 'onRemoveTan';
		public static var GET_SETTINGS:String = 'onGetSettings';
		public static var GET_SETTINGS_IN_OBJECT:String = 'onGetSettingsInObject';
		
		private var colorContainer:Sprite = new Sprite();
		private var background:Sprite = new Sprite();
		internal var objectContainer:Sprite = new Sprite();
		private var framework:Sprite = new Sprite();
		private var framemask:Sprite = new Sprite();
		
		private var blackContainer:Sprite = new Sprite();
		private var blackBackground:Sprite = new Sprite();
		internal var blackObjectContainer:Sprite = new Sprite();
		private var blackFramework:Sprite = new Sprite();
		private var blackFramemask:Sprite = new Sprite();
		
		private var wField:Number = 5;
		private var hField:Number = 5;
		private var deltaFrame:int = 2;
		
		private var arrObject:Array = new Array();
		private var arrVisible:Array = new Array();
		
		private var isTan:Boolean = true;
		private var isField:Boolean = false;
		private var isAlpha:Boolean = false;
		private var remTarget:*;
		//	Парметры для анимации
		private var animationToComplate:String = '';
		private var animationToMouseDown:String = '';
		public function GroupFieldModel(colorContainer:Sprite, blackContainer:Sprite) {
			super();
			colorContainer.addChild(this.colorContainer);
			this.colorContainer.addChild(background);
			this.colorContainer.addChild(objectContainer);
			this.colorContainer.addChild(framemask);
			this.colorContainer.addChild(framework);
			objectContainer.mask = framemask;
			super.tanColor = this.colorContainer;
			
			blackContainer.addChild(this.blackContainer);
			this.blackContainer.addChild(blackBackground);
			this.blackContainer.addChild(blackObjectContainer);
			this.blackContainer.addChild(blackFramework);
			this.blackContainer.addChild(blackFramemask);
			blackObjectContainer.mask = blackFramemask;
			blackObjectContainer.mouseChildren = false;
			blackObjectContainer.mouseEnabled = false;
			super.tanBlack = this.blackContainer;
			
			background.tabEnabled = true;
			blackBackground.tabEnabled = true;
			
			this.colorContainer.addEventListener(MouseEvent.MOUSE_OVER, COLOR_MOUSE_OVER);
			this.colorContainer.addEventListener(MouseEvent.MOUSE_OUT, COLOR_MOUSE_OUT);
			
			this.colorContainer.addEventListener(MouseEvent.MOUSE_DOWN, CONTAINER_FIELD_MOUSE_DOWN);
			
			background.addEventListener(MouseEvent.MOUSE_DOWN, COLOR_MOUSE_DOWN);
			blackBackground.addEventListener(MouseEvent.MOUSE_DOWN, BLACK_MOUSE_DOWN);
			background.addEventListener(KeyboardEvent.KEY_DOWN, COLOR_TAN_KEY_DOWN);
			blackBackground.addEventListener(KeyboardEvent.KEY_DOWN, BLACK_TAN_KEY_DOWN);
		}
		
		
		public function get hasBlackObject():Boolean{
			return isTan;
		}
		public function get hasColorObject():Boolean{
			return true;
		}
		public function get colorObjectXPosition():Number{
			return colorX;
		}
		public function get colorObjectYPosition():Number{
			return colorY;
		}
		
		public function get blackObjectXPosition():Number{
			return blackX;
		}
		public function get blackObjectYPosition():Number{
			return blackY;
		}
		
		public function set colorObjectXPosition(value:Number):void{
			colorContainer.x = value;
		}
		public function set colorObjectYPosition(value:Number):void{
			colorContainer.y = value;
		}
		
		public function set blackObjectXPosition(value:Number):void{
			blackContainer.x = value;
			
		}
		public function set blackObjectYPosition(value:Number):void{
			blackContainer.y = value;
		}
		public function set colorX(value:Number):void{
			colorContainer.x = value;
		}
		public function set colorY(value:Number):void{
			colorContainer.y = value;
		}
		public function set blackX(value:Number):void{
			blackContainer.x = value;
		}
		public function set blackY(value:Number):void{
			blackContainer.y = value;
		}
		
		override public function get colorX():Number{
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
		}
		
		
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
		
		private function drawContainers():void{
			background.graphics.clear();
			framework.graphics.clear();
			framemask.graphics.clear();
			
			blackBackground.graphics.clear();
			blackFramework.graphics.clear();
			blackFramemask.graphics.clear();
			
			background.graphics.lineStyle(1, 0x000000, 0);
			background.graphics.beginFill(0xCBCBCB, 1);
			background.graphics.drawRect(0, 0, wField, hField);
			background.graphics.endFill();
			
			blackBackground.graphics.lineStyle(1, 0x000000, 0);
			blackBackground.graphics.beginFill(0xE0E0E0, 0.4);
			blackBackground.graphics.drawRect(0, 0, wField, hField);
			blackBackground.graphics.endFill();
			
			framework.graphics.lineStyle(1, 0x3636363, 1);
			framework.graphics.beginFill(0x696969, 1);
			framework.graphics.drawRect(0, 0, wField, hField);
			framework.graphics.lineStyle(1, 0x000000, 1);
			framework.graphics.drawRect(deltaFrame, deltaFrame, wField - 2*deltaFrame, hField - 2*deltaFrame);
			framework.graphics.endFill();
			
			blackFramework.graphics.lineStyle(1, 0x3636363, 0.5);
			blackFramework.graphics.beginFill(0xA0A0A0, 0.4);
			blackFramework.graphics.drawRect(0, 0, wField, hField);
			blackFramework.graphics.lineStyle(1, 0x000000, 0.5);
			blackFramework.graphics.drawRect(deltaFrame, deltaFrame, wField - 2*deltaFrame, hField - 2*deltaFrame);
			blackFramework.graphics.endFill();
			
			framemask.graphics.lineStyle(1, 0x000000, 0);
			framemask.graphics.beginFill(0x000000, 0);
			framemask.graphics.drawRect(deltaFrame, deltaFrame, wField - 2*deltaFrame, hField - 2*deltaFrame);
			framemask.graphics.endFill();
			
			blackFramemask.graphics.lineStyle(1, 0x000000, 0);
			blackFramemask.graphics.beginFill(0x000000, 0);
			blackFramemask.graphics.drawRect(deltaFrame, deltaFrame, wField - 2*deltaFrame, hField - 2*deltaFrame);
			blackFramemask.graphics.endFill();
			
			var deltaX:Number = (-1)*background.width/2;
			var deltaY:Number = (-1)*background.height/2;
			background.x = blackBackground.x = framework.x = blackFramework.x = framemask.x = blackFramemask.x = blackObjectContainer.x = objectContainer.x = deltaX;
			background.y = blackBackground.y = framework.y = blackFramework.y = framemask.y = blackFramemask.y = blackObjectContainer.y = objectContainer.y = deltaY;
			
		}
		private function COLOR_MOUSE_OVER(event:MouseEvent):void{
			background.alpha = framework.alpha = 1;
		}
		private function COLOR_MOUSE_OUT(event:MouseEvent):void{
			background.alpha = framework.alpha = 0.2;
		}
		
		private var clickTimer:Timer = new Timer(500, 1);
		private var isClick:Boolean = false;
		private function CONTAINER_FIELD_MOUSE_DOWN(event:MouseEvent):void{
			if(this.isField){
				DesignerMain.STAGE.addEventListener(MouseEvent.MOUSE_UP, CONTAINER_FIELD_MOUSE_UP);
				isClick = true;
				clickTimer.addEventListener(TimerEvent.TIMER, CLICK_TIMER);
				clickTimer.start();
			}
		}
		private function CLICK_TIMER(event:TimerEvent = null):void{
			clickTimer.removeEventListener(TimerEvent.TIMER, CLICK_TIMER);
			isClick = false;
		}
		private function CONTAINER_FIELD_MOUSE_UP(event:MouseEvent):void{
			if(this.isField){
				DesignerMain.STAGE.removeEventListener(MouseEvent.MOUSE_UP, CONTAINER_FIELD_MOUSE_UP);
				if(isClick){
					clickTimer.stop();
					CLICK_TIMER();
					FIELD_CLICK();
				}
			}
		}
		
		private function COLOR_MOUSE_DOWN(event:MouseEvent):void{
			colorContainer.startDrag();
			DesignerMain.STAGE.addEventListener(MouseEvent.MOUSE_UP, COLOR_MOUSE_UP);
			super.dispatchEvent(new Event(GET_SETTINGS));
		}
		
		private function COLOR_MOUSE_UP(event:MouseEvent):void{
			colorContainer.stopDrag();
			DesignerMain.STAGE.removeEventListener(MouseEvent.MOUSE_UP, COLOR_MOUSE_UP);
		}
		
		
		
		private function BLACK_MOUSE_DOWN(event:MouseEvent):void{
			blackContainer.startDrag();
			DesignerMain.STAGE.addEventListener(MouseEvent.MOUSE_UP, BLACK_MOUSE_UP);
			super.dispatchEvent(new Event(GET_SETTINGS));
		}
		private function BLACK_MOUSE_UP(event:MouseEvent):void{
			blackContainer.stopDrag();
			DesignerMain.STAGE.removeEventListener(MouseEvent.MOUSE_UP, BLACK_MOUSE_UP);
		}
		
		override public function get tanColor():Sprite{
			return colorContainer;
		}
		public function addObject(value:*, idLabel:int, vis:Boolean = true):void{
			var ID:int = arrObject.length;
			arrObject.push(value);
			arrObject[ID].labelGroup = 'Group[' + idLabel.toString() + ',' + ID.toString() + ']';
			arrObject[ID].dinamyc = true;
			arrObject[ID].tanColor.addEventListener(MouseEvent.MOUSE_DOWN, IN_OBJECT_MOUSE_DOWN);
			arrObject[ID].tanColor.addEventListener(KeyboardEvent.KEY_DOWN, IN_OBJECT_KEY_DOWN);
			arrVisible.push(vis);
			correctFieldEnabled();
			correctBlackPosition();
			arrObject[ID].addEventListener(BaseTan.GET_SETTINGS, OBJECT_GET_SETTINGS);
			arrObject[ID].addEventListener(BaseTan.REMOVE_TAN, REMOVE_OBJECT_FROM_FIELD);
			
		}
		private function REMOVE_OBJECT_FROM_FIELD(event:Event):void{
			var i:int;
			var l:int;
			l = arrObject.length;
			for(i=0;i<l;i++){
				if(event.target == arrObject[i]){
					arrVisible.splice(i,1);
					objectContainer.removeChild(arrObject[i].tanColor);
					blackObjectContainer.removeChild(arrObject[i].tanBlack);
					arrObject[i].removeEventListener(BaseTan.GET_SETTINGS, OBJECT_GET_SETTINGS);
					arrObject[i].removeEventListener(BaseTan.REMOVE_TAN, REMOVE_OBJECT_FROM_FIELD);
					arrObject.splice(i,1);
				}
			}
		}
		private function OBJECT_GET_SETTINGS(event:Event):void{
			remTarget = event.target;
			super.dispatchEvent(new Event(GET_SETTINGS_IN_OBJECT));
		}
		public function get remember():*{
			return remTarget;
		}
		private function IN_OBJECT_KEY_DOWN(event:KeyboardEvent):void{
			switch(event.keyCode){
				case Keyboard.W:
				case Keyboard.A:
				case Keyboard.S:
				case Keyboard.D:
				case Keyboard.LEFT:
				case Keyboard.RIGHT:
					correctBlackPosition();
					correctSize();
				break;
			}
		}
		private function COLOR_TAN_KEY_DOWN(event:KeyboardEvent):void{
			switch(event.keyCode){
				case Keyboard.W: colorContainer.y -= 1; break;
				case Keyboard.A: colorContainer.x -= 1; break;
				case Keyboard.S: colorContainer.y += 1; break;
				case Keyboard.D: colorContainer.x += 1; break;
				case Keyboard.LEFT: this.colorR += 5; break;
				case Keyboard.RIGHT: this.colorR -= 5; break;
				case Keyboard.DELETE: super.dispatchEvent(new Event(BaseTan.REMOVE_TAN)); break;
			}
		}
		
		private function BLACK_TAN_KEY_DOWN(event:KeyboardEvent):void{
			switch(event.keyCode){
				case Keyboard.W: blackContainer.y -= 1; break;
				case Keyboard.A: blackContainer.x -= 1; break;
				case Keyboard.S: blackContainer.y += 1; break;
				case Keyboard.D: blackContainer.x += 1; break;
				case Keyboard.LEFT: this.blackR += 5; break;
				case Keyboard.RIGHT: this.blackR -= 5; break;
			}
		}
		private function IN_OBJECT_MOUSE_DOWN(event:MouseEvent):void{
			DesignerMain.STAGE.addEventListener(MouseEvent.MOUSE_UP, IN_OBJECT_MOUSE_UP);
		}
		private function IN_OBJECT_MOUSE_UP(event:MouseEvent):void{
			DesignerMain.STAGE.removeEventListener(MouseEvent.MOUSE_UP, IN_OBJECT_MOUSE_UP);
			correctBlackPosition();
			correctSize();
		}
		private function FIELD_CLICK(event:MouseEvent = null):void{
			var i:int;
			var l:int;
			l = arrObject.length;
			var remNum:int;
			for(i=0;i<l;i++){
				if(arrVisible[i]){
					remNum = i;
					break;
				}
			}
			arrVisible[remNum] = arrObject[remNum].tanBlack.visible = arrObject[remNum].tanColor.visible = false;
			if(remNum == l-1) arrVisible[0] = arrObject[0].tanBlack.visible = arrObject[0].tanColor.visible = true;
			else arrVisible[remNum+1] = arrObject[remNum+1].tanBlack.visible = arrObject[remNum+1].tanColor.visible = true;
		}
		private function correctSize():void{
			var rect:Rectangle = objectContainer.getBounds(objectContainer);
			var i:int;
			var l:int;
			l = arrObject.length;
			if(rect.x<0){
				colorContainer.x += rect.x;
				blackContainer.x += rect.x;
				width = rect.width + 2*this.deltaFrame;
				for(i=0;i<l;i++){
					arrObject[i].tanBlack.x = arrObject[i].tanColor.x += Math.abs(rect.x)+this.deltaFrame;
				}
			}
			if(rect.y<0){
				colorContainer.y += rect.y;
				blackContainer.y += rect.y;
				height = rect.height + 2*this.deltaFrame;
				for(i=0;i<l;i++){
					arrObject[i].tanBlack.y = arrObject[i].tanColor.y += Math.abs(rect.y)+this.deltaFrame;
				}
			}
			if(rect.x>=0) width = rect.x + rect.width + 2*this.deltaFrame;
			if(rect.y>=0) height = rect.y + rect.height + 2*this.deltaFrame;
		}
		
		private function correctBlackPosition():void{
			var i:int;
			var l:int;
			l = arrObject.length;
			for(i=0;i<l;i++){
				arrObject[i].tanBlack.x = arrObject[i].tanColor.x
				arrObject[i].tanBlack.y = arrObject[i].tanColor.y
				arrObject[i].blackR = arrObject[i].colorR;
			}
		}
		override public function clear():void{
			while(arrObject.length>0){
				arrVisible.shift();
				objectContainer.removeChild(arrObject[0].tanColor);
				blackObjectContainer.removeChild(arrObject[0].tanBlack);
				arrObject[0].removeEventListener(BaseTan.GET_SETTINGS, OBJECT_GET_SETTINGS);
				arrObject[0].removeEventListener(BaseTan.REMOVE_TAN, REMOVE_OBJECT_FROM_FIELD);
				arrObject.shift();
			}
			this.colorContainer.removeEventListener(MouseEvent.MOUSE_OVER, COLOR_MOUSE_OVER);
			this.colorContainer.removeEventListener(MouseEvent.MOUSE_OUT, COLOR_MOUSE_OUT);
			
			this.colorContainer.removeEventListener(MouseEvent.MOUSE_DOWN, CONTAINER_FIELD_MOUSE_DOWN);
			
			background.removeEventListener(MouseEvent.MOUSE_DOWN, COLOR_MOUSE_DOWN);
			blackBackground.removeEventListener(MouseEvent.MOUSE_DOWN, BLACK_MOUSE_DOWN);
			background.removeEventListener(KeyboardEvent.KEY_DOWN, COLOR_TAN_KEY_DOWN);
			blackBackground.removeEventListener(KeyboardEvent.KEY_DOWN, BLACK_TAN_KEY_DOWN);
			
			this.colorContainer.parent.removeChild(this.colorContainer);
			this.blackContainer.parent.removeChild(this.blackContainer);
		}
		
		
		
		
		
		
		override public function set width(value:Number):void{
			wField = value;
			drawContainers();
		}
		override public function get width():Number{
			return wField;
		}
		override public function set height(value:Number):void{
			hField = value;
			drawContainers();
		}
		override public function get height():Number{
			return hField;
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
				blackBackground.addEventListener(MouseEvent.MOUSE_DOWN, BLACK_MOUSE_DOWN);
			}else{
				blackContainer.visible = false;
				blackBackground.removeEventListener(MouseEvent.MOUSE_DOWN, BLACK_MOUSE_DOWN);
			}
		}
		public function get tan():Boolean{
			return this.isTan;
		}
		
		
		public function set field(value:Boolean):void{
			this.isField = value;
			if(value){
				correctFieldEnabled();
				this.colorContainer.doubleClickEnabled = true;
				this.colorContainer.addEventListener(MouseEvent.DOUBLE_CLICK, FIELD_CLICK);
			}else{
				var i:int;
				var l:int;
				l = arrObject.length;
				for(i=0;i<l;i++){
					arrObject[i].tanBlack.visible = arrObject[i].tanColor.visible = true;
				}
				this.colorContainer.doubleClickEnabled = false;
				this.colorContainer.removeEventListener(MouseEvent.DOUBLE_CLICK, FIELD_CLICK);
			}
			
		}
		public function get field():Boolean{
			return this.isField;
		}
		private function correctFieldEnabled():void{
			if(!this.isField) return;
			var i:int;
			var l:int;
			var flag:Boolean = true;
			l = arrObject.length;
			for(i=0;i<l;i++){
				if(flag){
					if(arrVisible[i]){
						flag = false;
						arrObject[i].tanBlack.visible = arrObject[i].tanColor.visible = true;
					}else{
						arrObject[i].tanBlack.visible = arrObject[i].tanColor.visible = false;
					}
				}else{
					arrVisible[i] = arrObject[i].tanBlack.visible = arrObject[i].tanColor.visible = false;
				}
				
			}
		}
		public function get objectLists():Array{
			var outArr:Array = new Array();
			var i:int;
			var l:int;
			l = arrObject.length;
			for(i=0;i<l;i++){
				outArr.push(arrObject[i].listPosition);
				if(isField){
					outArr[i].@visible = arrVisible[i].toString();
				}
			}
			return outArr;
		}
		
		//	Блок методов определяющий запуск анимации
		override public function get complateAnimation():String{
			return animationToComplate;
		}
		override public function set complateAnimation(value:String):void{
			animationToComplate = value;
		}
		override public function get downAnimation():String{
			return animationToMouseDown;
		}
		override public function set downAnimation(value:String):void{
			animationToMouseDown = value;
		}
		
		public function get listSettings():XMLList{
			var outXml:XMLList = new XMLList('<PACKAGE/>');
			outXml.@label = 'ПОЛЕ ГРУПППИРОВКИ';
			var widthList:XMLList = new XMLList('<FIELD label="ширина" type="number" variable="width" width="40">' + this.width.toString() + '</FIELD>');
			var heightList:XMLList = new XMLList('<FIELD label="высота" type="number" variable="height" width="40">' + this.height.toString() + '</FIELD>');
			var blockList:XMLList = new XMLList('<BLOCK label="размер"/>');
			blockList.appendChild(widthList);
			blockList.appendChild(heightList);
			outXml.appendChild(blockList);
			
			trace("bfore position block");
			blockList = new XMLList('<BLOCK label="позиции"/>');
			//blockList.appendChild(positionObjectsSettings);
			//super.positionObjectsSettings(blockList);
			outXml.appendChild(blockList);
			trace("after position block");
			
			var alphaList:XMLList = new XMLList('<MARK label="прозрачность" variable="blackAlpha">'+this.blackAlpha.toString()+'</MARK>');
			blockList = new XMLList('<BLOCK label="визуализация"/>');
			blockList.appendChild(alphaList);
			outXml.appendChild(blockList);
			
			
			var tanList:XMLList = new XMLList('<MARK label="тан" variable="tan">'+this.tan.toString()+'</MARK>');
			var fieldList:XMLList = new XMLList('<MARK label="перечисление" variable="field">'+this.field.toString()+'</MARK>');
			blockList = new XMLList('<BLOCK label="режим работы"/>');
			blockList.appendChild(tanList);
			blockList.appendChild(fieldList);
			outXml.appendChild(blockList);
			
			var complateList:XMLList = new XMLList('<FIELD label="Завершение" type="string" variable="complateAnimation" width="100">' + this.complateAnimation + '</FIELD>');
			var downList:XMLList = new XMLList('<FIELD label="Нажатие" type="string" variable="downAnimation" width="100">' + this.downAnimation + '</FIELD>');
			blockList = new XMLList('<BLOCK label="Проигрывать анимацию"/>');
			blockList.appendChild(complateList);
			blockList.appendChild(downList);
			outXml.appendChild(blockList);
			
			return outXml;
		}
		
		override public function get isCorrectPosition():Boolean{
			if(colorContainer.x<0 || colorContainer.x>DesignerMain.STAGE.width) return false;
			if(colorContainer.y<0 || colorContainer.y>DesignerMain.STAGE.height) return false;
			if(blackContainer.x<0 || blackContainer.x>DesignerMain.STAGE.width) return false;
			if(blackContainer.y<0 || blackContainer.y>DesignerMain.STAGE.height) return false;
			return true;
		}
		override public function normalizePosition():void{
			if(colorContainer.x<0) colorContainer.x = 6;
			if(colorContainer.x>DesignerMain.STAGE.width) colorContainer.x = DesignerMain.STAGE.width-6;
			if(colorContainer.y<0) colorContainer.y = 6;
			if(colorContainer.y>DesignerMain.STAGE.height) colorContainer.y = DesignerMain.STAGE.height - 6;
			
			if(blackContainer.x<0) blackContainer.x = 6;
			if(blackContainer.x>DesignerMain.STAGE.width) blackContainer.x = DesignerMain.STAGE.width-6;
			if(blackContainer.y<0) blackContainer.y = 6;
			if(blackContainer.y>DesignerMain.STAGE.height) blackContainer.y = DesignerMain.STAGE.height - 6;
		}
	}
	
}
