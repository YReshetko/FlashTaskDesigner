package source.Task.TaskObjects.CheckBox {
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import source.DesignerMain;
	import flash.geom.Rectangle;
	import flash.ui.Keyboard;
	import source.utils.Figure;
	
	public class CheckBoxClass extends Sprite{
		public static var REMOVE_TABLE:String = 'onRemoveTable';
		public static var COPY_OBJECT:String = 'onCopyObject';
		public static var GET_SETTINGS:String = 'onGetSettings';
		private var arrayBox:Array = new Array();
		private var deltaArr:Array;
		private var dragID:int;
		private var tableLabel:MoveLabel;
		private var choice:Boolean = false;
		
		private var remContainer:Sprite;
		public var selectContainer:Sprite;
		private var boundsContainer:Sprite = new Sprite();
		private var isSelect:Boolean = false;
		
		private var fieldFormat:FieldFormat = new FieldFormat();
		
		//	Переменые определяющие запуск другой анимации
		private var animationToComplate:String = '';
		private var animationToMouseDown:String = '';
		
		public function CheckBoxClass(xmlList:XMLList, container:Sprite) {
			super();
			container.addChild(super);
			remContainer = container;
			addBoxes(xmlList);
			super.x = xmlList.@x;
			super.y = xmlList.@y;
			if(xmlList.STARTANIMATIONCOMPLATE.toString() != '') this.complateAnimation = xmlList.STARTANIMATIONCOMPLATE.toString();
			if(xmlList.STARTANIMATIONDOWN.toString() != '') this.downAnimation = xmlList.STARTANIMATIONDOWN.toString();
			tableLabel = new MoveLabel();
			super.addChild(tableLabel);
			tableLabel.alpha = 0.2;
			tableLabel.addEventListener(MouseEvent.MOUSE_DOWN, TABLE_MOUSE_DOWN);
			tableLabel.addEventListener(MouseEvent.MOUSE_OVER, TABLE_MOUSE_OVER);
			tableLabel.addEventListener(MouseEvent.MOUSE_OUT, TABLE_MOUSE_OUT);
			tableLabel.addEventListener(KeyboardEvent.KEY_DOWN, TABLE_KEY_DOWN);
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
		private function addBoxes(xml:XMLList):void{
			var ID:int;
			oneSelect = (xml.CHOICE.toString() == 'true');
			if(xml.FORMAT.toString()!="") this.fieldFormat.format = xml.FORMAT;
			for each(var sample:XML in xml.BOX){
				trace(this + 'IN XML = ' + sample);
				ID = arrayBox.length;
				arrayBox.push(new OneBox(this.fieldFormat));
				arrayBox[ID].x = parseFloat(sample.@x);
				arrayBox[ID].y = parseFloat(sample.@y);
				if(sample.@width.toString()!="") arrayBox[ID].w = parseFloat(sample.@width);
				if(sample.@height.toString()!="") arrayBox[ID].h = parseFloat(sample.@height);
				arrayBox[ID].settings = sample;
				arrayBox[ID].addEventListener(OneBox.START_DRAG, BOX_START_DRAG);
				arrayBox[ID].addEventListener(OneBox.STOP_DRAG, BOX_STOP_DRAG);
				arrayBox[ID].addEventListener(OneBox.DRAG_DOWN, BOX_DRAG_DOWN);
				arrayBox[ID].addEventListener(OneBox.DRAG_LEFT, BOX_DRAG_LEFT);
				arrayBox[ID].addEventListener(OneBox.DRAG_RIGHT, BOX_DRAG_RIGHT);
				arrayBox[ID].addEventListener(OneBox.DRAG_UP, BOX_DRAG_UP);
				arrayBox[ID].addEventListener(OneBox.DELETE, BOX_DELETE);
				arrayBox[ID].addEventListener(OneBox.BOX_SELECT, ONE_BOX_SELECT);
				arrayBox[ID].addEventListener(OneBox.COPY_BOX, ONE_BOX_COPY);
				super.addChild(arrayBox[ID]);
			}
			this.applyFormat();
		}
		public function reset():void{
			var i:int;
			var l:int;
			l = arrayBox.length;
			for(i=0;i<l;i++){
				arrayBox[i].close();
			}
		}
		private function BOX_START_DRAG(event:Event):void{
			var rect:Rectangle = new Rectangle(0, 0, 4000, 4000);
			event.target.startDrag(false, rect);
		}
		private function BOX_STOP_DRAG(event:Event):void{
			event.target.stopDrag();
		}
		private function BOX_DRAG_DOWN(event:Event):void{
			event.target.y += 1;
		}
		private function BOX_DRAG_UP(event:Event):void{
			if(event.target.y-1<0) event.target.y = 0;
			else event.target.y -= 1;
		}
		private function BOX_DRAG_LEFT(event:Event):void{
			if(event.target.x-1<0) event.target.x = 0;
			else event.target.x -= 1;
		}
		private function BOX_DRAG_RIGHT(event:Event):void{
			event.target.x += 1;
		}
		private function BOX_DELETE(event:Event):void{
			var i:int;
			var l:int;
			l = arrayBox.length;
			for(i=0;i<l;i++){
				if(event.target == arrayBox[i]){
					arrayBox[i].removeEventListener(OneBox.START_DRAG, BOX_START_DRAG);
					arrayBox[i].removeEventListener(OneBox.STOP_DRAG, BOX_STOP_DRAG);
					arrayBox[i].removeEventListener(OneBox.DRAG_DOWN, BOX_DRAG_DOWN);
					arrayBox[i].removeEventListener(OneBox.DRAG_LEFT, BOX_DRAG_LEFT);
					arrayBox[i].removeEventListener(OneBox.DRAG_RIGHT, BOX_DRAG_RIGHT);
					arrayBox[i].removeEventListener(OneBox.DRAG_UP, BOX_DRAG_UP);
					arrayBox[i].removeEventListener(OneBox.DELETE, BOX_DELETE);
					arrayBox[i].removeEventListener(OneBox.COPY_BOX, ONE_BOX_COPY);
					super.removeChild(arrayBox[i]);
					arrayBox.splice(i,1);
					return;
				}
			}
		}
		private function TABLE_KEY_DOWN(e:KeyboardEvent):void{
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
					super.dispatchEvent(new Event(REMOVE_TABLE));
				break;
				case Keyboard.C:
					if(e.ctrlKey) super.dispatchEvent(new Event(COPY_OBJECT));
				break;
			}
		}
		private function TABLE_MOUSE_DOWN(e:MouseEvent):void{
			super.startDrag();
			DesignerMain.STAGE.addEventListener(MouseEvent.MOUSE_UP, TABLE_MOUSE_UP);
			super.dispatchEvent(new Event(GET_SETTINGS));
		}
		private function TABLE_MOUSE_UP(e:MouseEvent):void{
			super.stopDrag();
			DesignerMain.STAGE.removeEventListener(MouseEvent.MOUSE_UP, TABLE_MOUSE_UP);
		}
		private function TABLE_MOUSE_OVER(e:MouseEvent):void{
			tableLabel.alpha = 1;
		}
		private function TABLE_MOUSE_OUT(e:MouseEvent):void{
			tableLabel.alpha = 0.2;
		}
		private function ONE_BOX_SELECT(event:Event):void{
			if(!choice) return;
			var i:int;
			var l:int;
			l = arrayBox.length;
			var flag:Boolean = true;
			for(i=0;i<l;i++){
				if(event.target!=arrayBox[i]){
					arrayBox[i].select = false;
				}
			}
		}
		private function ONE_BOX_COPY(event:Event):void{
			var X:int;
			var Y:int;
			X = event.target.x + 15;
			Y = event.target.y + 15;
			var sample:XML = new XML(event.target.listPosition);
			var ID:int = arrayBox.length;
			arrayBox.push(new OneBox(this.fieldFormat));
			arrayBox[ID].x = X;
			arrayBox[ID].y = Y;
			if(sample.@width.toString()!="") arrayBox[ID].w = parseFloat(sample.@width);
			if(sample.@height.toString()!="") arrayBox[ID].h = parseFloat(sample.@height);
			arrayBox[ID].settings = sample;
			arrayBox[ID].addEventListener(OneBox.START_DRAG, BOX_START_DRAG);
			arrayBox[ID].addEventListener(OneBox.STOP_DRAG, BOX_STOP_DRAG);
			arrayBox[ID].addEventListener(OneBox.DRAG_DOWN, BOX_DRAG_DOWN);
			arrayBox[ID].addEventListener(OneBox.DRAG_LEFT, BOX_DRAG_LEFT);
			arrayBox[ID].addEventListener(OneBox.DRAG_RIGHT, BOX_DRAG_RIGHT);
			arrayBox[ID].addEventListener(OneBox.DRAG_UP, BOX_DRAG_UP);
			arrayBox[ID].addEventListener(OneBox.DELETE, BOX_DELETE);
			arrayBox[ID].addEventListener(OneBox.BOX_SELECT, ONE_BOX_SELECT);
			arrayBox[ID].addEventListener(OneBox.COPY_BOX, ONE_BOX_COPY);
			super.addChild(arrayBox[ID]);
			arrayBox[ID].applyFormat()
		}
		
		
		public function get type():String{
			return arrayBox[0].boxType;
		}
		public function set type(value:String):void{
			var i:int;
			var l:int;
			l = arrayBox.length;
			for(i=0;i<l;i++){
				arrayBox[i].boxType = value;
				arrayBox[i].correctSize();
			}
			if(this.isSelect) drawSelect();
		}
		public function set oneSelect(value:Boolean):void{
			choice = value;
			if(!value) return;
			var i:int;
			var l:int;
			l = arrayBox.length;
			var flag:Boolean = true;
			for(i=0;i<l;i++){
				if(arrayBox[i].select){
					if(flag) flag = false;
					else arrayBox[i].select = false;
				}
			}
			this.type = 'round';
		}
		public function get oneSelect():Boolean{
			return choice;
		}
		
		
		
		public function get background():Boolean{
			return this.fieldFormat.background;
		}
		public function set background(value:Boolean):void{
			this.fieldFormat.background = value;
			applyFormat();
		}
		
		public function get backgroundColor():uint{
			return this.fieldFormat.backgroundColor;
		}
		public function set backgroundColor(value:uint):void{
			this.fieldFormat.backgroundColor = value;
			applyFormat();
		}
		
		public function get border():Boolean{
			return this.fieldFormat.border;
		}
		public function set border(value:Boolean):void{
			this.fieldFormat.border = value;
			applyFormat();
		}
		
		public function get borderColor():uint{
			return this.fieldFormat.borderColor;
		}
		public function set borderColor(value:uint):void{
			this.fieldFormat.borderColor = value;
			applyFormat();
		}
		
		public function get size():Number{
			return this.fieldFormat.size;
		}
		public function set size(value:Number):void{
			this.fieldFormat.size = value;
			applyFormat();
		}
		
		public function get font():String{
			return this.fieldFormat.font;
		}
		public function set font(value:String):void{
			this.fieldFormat.font = value;
			applyFormat();
		}
		
		
		public function get textColor():uint{
			return this.fieldFormat.textColor;
		}
		public function set textColor(value:uint):void{
			this.fieldFormat.textColor = value;
			applyFormat();
		}
		public function get align():String{
			return this.fieldFormat.align;
		}
		public function set align(value:String):void{
			this.fieldFormat.align = value;
			applyFormat();
		}
		public function applyFormat():void{
			var i:int;
			var l:int;
			l = arrayBox.length;
			for(i=0;i<l;i++){
				arrayBox[i].applyFormat();
			}
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
			outXml.@label = 'ВЫБОР ОТВЕТОВ';
			
			var additionalXml:XMLList = new XMLList('<CHECK/>');
			additionalXml.@variable = 'type';
			additionalXml.appendChild(new XML('<DATA>classic</DATA>'));
			additionalXml.appendChild(new XML('<DATA>round</DATA>'));
			additionalXml.appendChild(new XML('<DATA>text</DATA>'));
			additionalXml.appendChild(new XML('<CURRENTDATA>' + this.type + '</CURRENTDATA>'));
			var blockList:XMLList = new XMLList('<BLOCK label="тип полей"/>');
			blockList.appendChild(additionalXml);
			outXml.appendChild(blockList);
			
			var animList:XMLList = new XMLList('<MARK label="один верный ответ" variable="oneSelect">'+this.oneSelect.toString()+'</MARK>');
			blockList = new XMLList('<BLOCK label="тип выбора"/>');
			blockList.appendChild(animList);
			outXml.appendChild(blockList);
			
			var borderList:XMLList = new XMLList('<MARK label="рамка" variable="border">'+this.border.toString()+'</MARK>');
			var backgroundList:XMLList = new XMLList('<MARK label="фон" variable="background">'+this.background.toString()+'</MARK>');
			var sizeList:XMLList = new XMLList('<FIELD label="размер шрифта" type="number" variable="size" width="40">' + this.size.toString() + '</FIELD>');
			blockList = new XMLList('<BLOCK label="поле"/>');
			blockList.appendChild(borderList);
			blockList.appendChild(backgroundList);
			blockList.appendChild(sizeList);
			outXml.appendChild(blockList);
			
			var fontList:XMLList = new XMLList('<CHECK/>');
			fontList.@variable = 'font';
			fontList.appendChild(new XML('<DATA>Times New Roman</DATA>'));
			fontList.appendChild(new XML('<DATA>LucidaConsole</DATA>'));
			fontList.appendChild(new XML('<DATA>Arial</DATA>'));
			fontList.appendChild(new XML('<CURRENTDATA>' + this.font + '</CURRENTDATA>'));
			
			/*var alignList:XMLList = new XMLList('<CHECK/>');
			alignList.@variable = 'align';
			alignList.appendChild(new XML('<DATA>left</DATA>'));
			alignList.appendChild(new XML('<DATA>center</DATA>'));
			alignList.appendChild(new XML('<DATA>right</DATA>'));
			alignList.appendChild(new XML('<CURRENTDATA>' + this.align + '</CURRENTDATA>'));*/
			
			blockList = new XMLList('<BLOCK label="шрифт"/>');
			blockList.appendChild(fontList);
			/*blockList.appendChild(alignList);*/
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
			outXml.appendChild(new XML('<COLOR label="fill" variable="backgroundColor">' + this.backgroundColor.toString() + '</COLOR>'));
			outXml.appendChild(new XML('<COLOR label="line" variable="borderColor">' + this.borderColor.toString() + '</COLOR>'));
			outXml.appendChild(new XML('<COLOR label="text" variable="textColor">' + this.textColor.toString() + '</COLOR>'));
			return outXml;
		}
		
		public function get listPosition():XMLList{
			var outXml:XMLList = new XMLList('<CHOICEBOX/>');
			outXml.@x = super.x;
			outXml.@y = super.y;
			outXml.CHOICE = oneSelect.toString();
			outXml.appendChild(fieldFormat.format);
			if(this.complateAnimation != '') outXml.STARTANIMATIONCOMPLATE = this.complateAnimation;
			if(this.downAnimation != '') outXml.STARTANIMATIONDOWN = this.downAnimation;
			var i:int;
			var l:int;
			l = arrayBox.length;
			for(i=0;i<l;i++){
				outXml.appendChild(arrayBox[i].listPosition);
			}
			return outXml;
		}
		public function get isCorrectPosition():Boolean{
			if(super.x<0 || super.x>DesignerMain.STAGE.width) return false;
			if(super.y<0 || super.y>DesignerMain.STAGE.height) return false;
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
