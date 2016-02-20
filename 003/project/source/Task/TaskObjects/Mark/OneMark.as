package source.Task.TaskObjects.Mark {
	import flash.display.Sprite;	
	import flash.geom.ColorTransform;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import source.DesignerMain;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import source.utils.Figure;
	import flash.geom.Rectangle;

	public class OneMark extends Sprite {
		public static var MARK_SET_CLASS:String = 'onMarkSetClass';
		public static var COPY_OBJECT:String = 'onCopyObject';
		public static var GET_SETTINGS:String = 'onGetSettings';
		public static var REMOVE_MARK:String = 'onRemoveMark';
		
		private var Mark:MarkVidel;
		
		private var fillColor:uint = 0xFF0000;
		private var blockTime:int = 0;
		
		private var NumClass:int = new int;
		private var animAfterClick:Boolean = false;
		private var isDelete:Boolean = false;
		
		private var remContainer:Sprite;
		public var selectContainer:Sprite;
		private var boundsContainer:Sprite = new Sprite();
		private var isSelect:Boolean = false;
		//	Парметры для анимации
		private var animationToComplate:String = '';
		private var animationToMouseDown:String = '';
		public function OneMark(xml:XMLList, container:Sprite) { 
			super();
			remContainer = container;
			container.addChild(super);
			Mark = new MarkVidel();
			super.addChild(Mark);
			super.mouseChildren = false;
			NumClass = parseInt(xml.CLASS);
			Mark.field.text = NumClass.toString();
			super.x = parseFloat(xml.X);
			super.y = parseFloat(xml.Y);
			Mark.width = parseFloat(xml.WIDTH);
			Mark.height = parseFloat(xml.HEIGHT);
			//	Присваивание значания цвета переменной
			if(xml.COLOR.toString()!=''){
				this.fillColor = uint(xml.COLOR);
			}
			color = this.fillColor;
			if(xml.BLOCK.toString()!=''){
				blockTime = parseInt(xml.BLOCK.toString());
			}
			if(xml.ANIMATION.toString()=='true') animAfterClick = true;
			
			if(xml.STARTANIMATIONCOMPLATE.toString()!='') this.complateAnimation = xml.STARTANIMATIONCOMPLATE.toString();
			if(xml.STARTANIMATIONDOWN.toString()!='') this.downAnimation = xml.STARTANIMATIONDOWN.toString();
			
			super.addEventListener(MouseEvent.MOUSE_DOWN, MARK_MOUSE_DOWN);
			super.addEventListener(KeyboardEvent.KEY_DOWN, ON_KEY_DOWN);
		}
		public function set select(value:Boolean):void{
			if(isSelect == value) return;
			isSelect = value;
			if(value){
				selectContainer.addChild(super);
				selectContainer.addChild(boundsContainer);
				drawSelect();
			}else{
				boundsContainer.graphics.clear();
				selectContainer.removeChild(boundsContainer);
				remContainer.addChild(super);
			}
		}

		public function get select():Boolean{
			return isSelect;
		}
		public function drawSelect():void{
			boundsContainer.graphics.clear();
			var rect:Rectangle = super.getBounds(super.parent);
			var W:Number = rect.width + 4;
			var H:Number = rect.height + 4;
			Figure.insertCurve(boundsContainer, [[-W/2, -H/2],[W/2, -H/2],[W/2, H/2],[-W/2, H/2],[-W/2, -H/2]], 1, 1, 0x0000FF, 0);
			Figure.insertCircle(boundsContainer, 2.5, 1, 0.1, 0x000000, 1, 0xFFFFFF);
			//blackSelectContainer.rotation = this.blackR*22.5;
			boundsContainer.x = rect.x + W/2;
			boundsContainer.y = rect.y + H/2;
		}
		private function ON_KEY_DOWN(e:KeyboardEvent):void{
			switch(e.keyCode){
				case Keyboard.A:
					super.x = super.x - 1;
				break;
				case Keyboard.D:
					super.x = super.x + 1;
				break;
				case Keyboard.W:
					super.y = super.y - 1;
				break;
				case Keyboard.S:
					super.y = super.y + 1;
				break;
				case Keyboard.DELETE:
					isDelete = true;
					super.dispatchEvent(new Event(REMOVE_MARK));
				break;
				case Keyboard.C:
					if(e.ctrlKey) super.dispatchEvent(new Event(COPY_OBJECT));
				break;
			}
		}
		public function get remove():Boolean{
			return isDelete;
		}
		public function clear():void{
			super.removeEventListener(MouseEvent.MOUSE_DOWN, MARK_MOUSE_DOWN);
			super.removeEventListener(KeyboardEvent.KEY_DOWN, ON_KEY_DOWN);
			super.removeChild(Mark);
			super.parent.removeChild(super);
			Mark = null;
		}
		private function MARK_MOUSE_DOWN(e:MouseEvent):void{
			super.startDrag();
			DesignerMain.STAGE.addEventListener(MouseEvent.MOUSE_UP, MARK_MOUSE_UP);
			super.dispatchEvent(new Event(GET_SETTINGS));
		}
		private function MARK_MOUSE_UP(e:MouseEvent):void{
			super.stopDrag();
			DesignerMain.STAGE.removeEventListener(MouseEvent.MOUSE_UP, MARK_MOUSE_UP);
			super.dispatchEvent(new Event(GET_SETTINGS));
		}
		public function get mClass():int{
			return NumClass;
		}
		public function set mClass(value:int):void{
			NumClass = value;
			Mark.field.text = NumClass.toString();
			super.dispatchEvent(new Event(MARK_SET_CLASS));
		}
		public function get isAnimation():Boolean{
			return animAfterClick;
		}
		public function set isAnimation(value:Boolean):void{
			animAfterClick = value;
		}
		public function get block():int{
			return blockTime;
		}
		public function set block(value:int):void{
			blockTime = value;
		}
		public function get mWidth():Number{
			return Mark.width;
		}
		public function set mWidth(value:Number):void{
			Mark.width = value;
			if(this.isSelect) this.drawSelect();
		}
		public function get mHeight():Number{
			return Mark.height;
		}
		public function set mHeight(value:Number):void{
			Mark.height = value;
			if(this.isSelect) this.drawSelect();
		}
		public function set color(value:uint):void{
			fillColor = value;
			var colorTransform:ColorTransform = Mark.transform.colorTransform;
			colorTransform.color = value;
			Mark.transform.colorTransform = colorTransform; 
		}
		public function get color():uint{
			return fillColor;
		}
		
		//	Блок методов определяющий запуск анимации
		public function get complateAnimation():String{
			return animationToComplate;
		}
		public function set complateAnimation(value:String):void{
			animationToComplate = value;
		}
		public function get downAnimation():String{
			return animationToMouseDown;
		}
		public function set downAnimation(value:String):void{
			animationToMouseDown = value;
		}
		
		
		public function get listSettings():XMLList{
			var outXml:XMLList = new XMLList('<PACKAGE/>');
			outXml.@label = 'ОБЛАСТЬ ВЫДЕЛЕНИЯ';
			var widthList:XMLList = new XMLList('<FIELD label="ширина" type="number" variable="mWidth" width="40">' + this.mWidth.toString() + '</FIELD>');
			var heightList:XMLList = new XMLList('<FIELD label="высота" type="number" variable="mHeight" width="40">' + this.mHeight.toString() + '</FIELD>');
			
			var numList:XMLList = new XMLList('<FIELD label="номер класса" type="number" variable="mClass" width="40">' + this.mClass.toString() + '</FIELD>');
			var blockTimeList:XMLList = new XMLList('<FIELD label="время блокировки" type="number" variable="block" width="40">' + this.block.toString() + '</FIELD>');
			var animList:XMLList = new XMLList('<MARK label="анимация после клика по всем" variable="isAnimation">'+this.isAnimation.toString()+'</MARK>');
			
			var blockList:XMLList = new XMLList('<BLOCK label="размер"/>');
			blockList.appendChild(widthList);
			blockList.appendChild(heightList);
			outXml.appendChild(blockList);
			blockList = new XMLList('<BLOCK label="Параметры"/>');
			blockList.appendChild(numList);
			blockList.appendChild(blockTimeList);
			blockList.appendChild(animList);
			outXml.appendChild(blockList);
			
			var complateList:XMLList = new XMLList('<FIELD label="Завершение" type="string" variable="complateAnimation" width="100">' + this.complateAnimation + '</FIELD>');
			var downList:XMLList = new XMLList('<FIELD label="Нажатие" type="string" variable="downAnimation" width="100">' + this.downAnimation + '</FIELD>');
			blockList = new XMLList('<BLOCK label="Проигрывать анимацию"/>');
			blockList.appendChild(complateList);
			blockList.appendChild(downList);
			outXml.appendChild(blockList);
			return outXml;
		}
		public function get colorSettings():XMLList{
			var outXml:XMLList = new XMLList('<PACKAGE/>');
			outXml.appendChild(new XML('<COLOR label="fill" variable="color">' + this.color.toString() + '</COLOR>'));
			return outXml;
		}
		
		public function get listPosition():XMLList{
			var outXml:XMLList = new XMLList('<MARK/>');
			outXml.CLASS = mClass;
			outXml.X = super.x;
			outXml.Y = super.y;
			outXml.WIDTH = Mark.width;
			outXml.HEIGHT = Mark.height;
			outXml.COLOR = color;
			if(blockTime>0)	outXml.BLOCK = blockTime;
			if(isAnimation) outXml.ANIMATION = isAnimation;
			if(this.complateAnimation != '') outXml.STARTANIMATIONCOMPLATE = this.complateAnimation;
			if(this.downAnimation != '') outXml.STARTANIMATIONDOWN = this.downAnimation;
			return outXml;
		}
		public function get isCorrectPosition():Boolean{
			if(super.x<0 || super.x>DesignerMain.STAGE.width) return false;
			if(super.y<0 || super.x>DesignerMain.STAGE.height) return false;
			return true;
		}
		public function normalizePosition():void{
			if(super.x<0) super.x = 6;
			if(super.x>DesignerMain.STAGE.width) super.x = DesignerMain.STAGE.width-6;
			if(super.y<0) super.y = 6;
			if(super.y>DesignerMain.STAGE.height) super.y = DesignerMain.STAGE.height - 6;
		}
	}
}