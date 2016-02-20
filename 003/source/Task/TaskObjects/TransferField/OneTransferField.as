package source.Task.TaskObjects.TransferField {
	import flash.display.Sprite;
	import flash.text.*;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import source.DesignerMain;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import flash.geom.Rectangle;
	import source.utils.Figure;

	public class OneTransferField extends EventDispatcher{
		public static var COPY_OBJECT:String = 'onCopyObject';
		public static var GET_SETTINGS:String = 'onGetSettings';
		public static var REMOVE_FIELD:String = 'onRemoveField';
		private var field		:TextField 	= new TextField();	//	текстовое поле для отображения значений
		private var textFormat	:TextFormat = new TextFormat();	//	формат текстового поля
		private var AllZnach	:String = '';
		private var VernZnach	:String = '';					//	верное значение
		private var Devider		:String = ',';					//	Разделитель
		private var fieldContainer:Sprite = new Sprite();
		private var isDelete:Boolean = false;
		
		private var sTan:String = 'НЕТ';
		private var sBlock:int = 0;
		private var sShow:int = 0;
		
		private var vTan:String = 'НЕТ';
		private var vBlock:int = 0;
		private var vShow:int = 0;
		private var vVanish:int = 0;
		
		private var remContainer:Sprite;
		public var selectContainer:Sprite;
		private var boundsContainer:Sprite = new Sprite();
		private var isSelect:Boolean = false;
		
		private var isRandom:Boolean = false;
		private var isQuestion:Boolean = false;
		//	Парметры для анимации
		private var animationToComplate:String = '';
		private var animationToMouseDown:String = '';
		public function OneTransferField(xml:XMLList, container:Sprite) {//	Элемент класса строится по полученной матрице 
			super();
			remContainer = container;
			container.addChild(fieldContainer);
			var dopArr:Array = new Array;
			textFormat.color = 0x000000;//	цвет текста только чёрный
			textFormat.size = parseFloat(xml.HEIGHT)/1.5;//	размер шрифта
			textFormat.align = "center";//	выравнивание по центру
			fieldContainer.x = parseFloat(xml.X);//	смещение объекта в контенере на необходимые координаты
			fieldContainer.y = parseFloat(xml.Y);
			field.background = true;//	устанавливаем фон текста
			if(xml.BGCOLOR.toString()!='') field.backgroundColor = xml.BGCOLOR;
			else field.backgroundColor = 0x99CC00;
			if(xml.TEXTCOLOR.toString() !='') this.textColor = xml.TEXTCOLOR;
			
			
			field.width = parseFloat(xml.WIDTH);//	устанавливаем размер элемента класса
			field.height = parseFloat(xml.HEIGHT);
			field.type = TextFieldType.DYNAMIC;//	делаем поле динамическим
			
			fieldContainer.addChild(field);//	добавляем в экземпляр класса текстовое поле
			field.mouseEnabled = false;//	блокируем реакцию на курсор
			field.setTextFormat(textFormat);//	назначаем формат тексту
			field.defaultTextFormat = textFormat;
			fieldContainer.addChild(field);
			if(xml.DEVIDER.toString()!='') this.devider = xml.DEVIDER;
			for each(var sample:XML in xml.ALLVARIANTS.elements()){
				AllZnach += sample.toString()+ devider;
			}
			AllZnach = AllZnach.substring(0, AllZnach.length-1);
			correctVariant = xml.TRUEVARIANT.toString()//	устанавливаем верное значение
			if(xml.SHOWING.toString()!=''){
				if(xml.SHOWING.TAN.toString()=='BLACK'){
					setShowing('ЕСТЬ', parseInt(xml.SHOWING.BLOCK), parseInt(xml.SHOWING.SHOW) );
				}
			}
			if(xml.VANISHING.toString()!=''){
				if(xml.VANISHING.TAN.toString()=='BLACK'){
					setVanishing('ЕСТЬ', parseInt(xml.VANISHING.BLOCK), parseInt(xml.VANISHING.SHOW), parseInt(xml.VANISHING.VANISH));
				}
			}
			//if(MatrZnach.length!=0)field.appendText(MatrZnach[0]);//	записываем в текст 0-ое значение массива
			
			if(xml.RANDOM.toString()!='') this.random = xml.RANDOM.toString() == 'true';
			if(xml.QUESTION.toString()!='') this.question = xml.QUESTION.toString() == 'true';
			
			if(xml.STARTANIMATIONCOMPLATE.toString()!='') this.complateAnimation = xml.STARTANIMATIONCOMPLATE.toString();
			if(xml.STARTANIMATIONDOWN.toString()!='') this.downAnimation = xml.STARTANIMATIONDOWN.toString();
			
			
			fieldContainer.mouseChildren = false;
			fieldContainer.addEventListener(MouseEvent.MOUSE_DOWN, FIELD_MOUSE_DOWN);
			fieldContainer.addEventListener(KeyboardEvent.KEY_DOWN, FIELD_KEY_DOWN);
		}
		public function set select(value:Boolean):void{
			if(isSelect == value) return;
			isSelect = value;
			if(value){
				selectContainer.addChild(fieldContainer);
				selectContainer.addChild(boundsContainer);
				drawSelect();
			}else{
				boundsContainer.graphics.clear();
				selectContainer.removeChild(boundsContainer);
				remContainer.addChild(fieldContainer);
			}
		}

		public function get select():Boolean{
			return isSelect;
		}
		public function drawSelect():void{
			boundsContainer.graphics.clear();
			var rect:Rectangle = fieldContainer.getBounds(fieldContainer.parent);
			var W:Number = rect.width + 4;
			var H:Number = rect.height + 4;
			Figure.insertCurve(boundsContainer, [[-W/2, -H/2],[W/2, -H/2],[W/2, H/2],[-W/2, H/2],[-W/2, -H/2]], 1, 1, 0x0000FF, 0);
			Figure.insertCircle(boundsContainer, 2.5, 1, 0.1, 0x000000, 1, 0xFFFFFF);
			//blackSelectContainer.rotation = this.blackR*22.5;
			boundsContainer.x = rect.x + W/2 - 2;
			boundsContainer.y = rect.y + H/2 - 2;
		}
		private function FIELD_KEY_DOWN(event:KeyboardEvent):void{
			switch(event.keyCode){
				case Keyboard.A:
					fieldContainer.x -= 1;
				break;
				case Keyboard.D:
					fieldContainer.x += 1;
				break;
				case Keyboard.W:
					fieldContainer.y -= 1;
				break;
				case Keyboard.S:
					fieldContainer.y += 1;
				break;
				case Keyboard.DELETE:
					isDelete = true;
					super.dispatchEvent(new Event(REMOVE_FIELD));
				break;
				case Keyboard.C:
					if(event.ctrlKey) super.dispatchEvent(new Event(COPY_OBJECT));
				break;
			}
		}
		public function get remove():Boolean{
			return isDelete;
		}
		public function clear():void{
			fieldContainer.removeEventListener(MouseEvent.MOUSE_DOWN, FIELD_MOUSE_DOWN);
			fieldContainer.removeEventListener(KeyboardEvent.KEY_DOWN, FIELD_KEY_DOWN);
			fieldContainer.removeChild(field);
			fieldContainer.parent.removeChild(fieldContainer);
			field = null;
			fieldContainer = null;
		}
		private function FIELD_MOUSE_DOWN(e:MouseEvent):void{
			fieldContainer.startDrag();
			DesignerMain.STAGE.addEventListener(MouseEvent.MOUSE_UP, FIELD_MOUSE_UP);
			super.dispatchEvent(new Event(GET_SETTINGS));
		}
		private function FIELD_MOUSE_UP(e:MouseEvent):void{
			fieldContainer.stopDrag();
			DesignerMain.STAGE.removeEventListener(MouseEvent.MOUSE_UP, FIELD_MOUSE_UP);
		}
		public function get containerX():Number{
			return fieldContainer.x
		}
		public function get containerY():Number{
			return fieldContainer.y
		}
		public function set width(value:Number):void{
			field.width = value;
			if(this.isSelect) this.drawSelect();
		}
		public function get width():Number{
			return field.width;
		}
		public function set height(value:Number):void{
			field.height = value;
			textFormat.size = value/1.5;
			field.setTextFormat(textFormat);
			field.defaultTextFormat = textFormat;
			if(this.isSelect) this.drawSelect();
		}
		public function get height():Number{
			return field.height;
		}
		public function set correctVariant(value:String):void{
			VernZnach = value;
			field.text = value;
		}
		public function get correctVariant():String{
			return VernZnach;
		}
		public function set allVariant(value:String):void{
			AllZnach = value;
		}
		public function get allVariant():String{
			return AllZnach;
		}
		public function set devider(value:String):void{
			Devider = value;
		}
		public function get devider():String{
			return Devider;
		}
		public function set color(value:uint):void{
			field.backgroundColor = value;
		}
		public function get color():uint{
			return field.backgroundColor;
		}
		public function set textColor(value:uint):void{
			textFormat.color = value;
			field.setTextFormat(textFormat);
			field.defaultTextFormat = textFormat;
		}
		public function get textColor():uint{
			return textFormat.color as uint;
		}
		
		
		public function setShowing(tan:String, block:int, show:int):void{
			showTan = tan;
			showBlock = block;
			showShow = show;
		}
		public function setVanishing(tan:String, block:int, show:int, vanish:int):void{
			vanishTan = tan;
			vanishBlock = block;
			vanishShow = show;
			vanishVanish = vanish;
		}
		
		public function set showTan(value:String):void{
			sTan = value;
		}
		public function get showTan():String{
			return sTan;
		}
		public function set showBlock(value:int):void{
			sBlock = value;
		}
		public function get showBlock():int{
			return sBlock;
		}
		public function set showShow(value:int):void{
			sShow = value;
		}
		public function get showShow():int{
			return sShow;
		}
		
		
		public function set vanishTan(value:String):void{
			vTan = value;
		}
		public function get vanishTan():String{
			return vTan;
		}
		public function set vanishBlock(value:int):void{
			vBlock = value;
		}
		public function get vanishBlock():int{
			return vBlock;
		}
		public function set vanishShow(value:int):void{
			vShow = value;
		}
		public function get vanishShow():int{
			return vShow;
		}
		public function set vanishVanish(value:int):void{
			vVanish = value;
		}
		public function get vanishVanish():int{
			return vVanish;
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
		
		public function set random(value:Boolean):void{
			isRandom = value;
		}
		public function set question(value:Boolean):void{
			isQuestion = value;
		}
		public function get random():Boolean{
			return isRandom;
		}
		public function get question():Boolean{
			return isQuestion;
		}
		public function get listSettings():XMLList{
			var outXml:XMLList = new XMLList('<PACKAGE/>');
			outXml.@label = 'ПЕРЕЧИСЛЯЕМОЕ ПОЛЕ';
			var widthList:XMLList = new XMLList('<FIELD label="ширина" type="number" variable="width" width="40">' + this.width.toString() + '</FIELD>');
			var heightList:XMLList = new XMLList('<FIELD label="высота" type="number" variable="height" width="40">' + this.height.toString() + '</FIELD>');			
			
			var blockList:XMLList = new XMLList('<BLOCK label="размер поля"/>');
			blockList.appendChild(widthList);
			blockList.appendChild(heightList);
			outXml.appendChild(blockList);
			
			widthList = new XMLList('<FIELD label="все варианты" type="string" variable="allVariant" width="400">' + this.allVariant + '</FIELD>');
			blockList = new XMLList('<BLOCK label="значения поля"/>');
			blockList.appendChild(widthList);
			outXml.appendChild(blockList);
			heightList = new XMLList('<FIELD label="верный" type="string" variable="correctVariant" width="150">' + this.correctVariant + '</FIELD>');			
			var deviderXMLList:XMLList = new XMLList('<FIELD label="разделитель" type="string" variable="devider" width="20">' + this.devider + '</FIELD>');
			blockList = new XMLList('<BLOCK label="---"/>');
			blockList.appendChild(heightList);
			blockList.appendChild(deviderXMLList);
			outXml.appendChild(blockList);
			
			var randomXml:XMLList = new XMLList('<MARK label="случайная выдача вариантов" variable="random">'+this.random.toString()+'</MARK>');
			var questionXml:XMLList = new XMLList('<MARK label="вопросительный знак" variable="question">'+this.question.toString()+'</MARK>');
			blockList = new XMLList('<BLOCK label="---"/>');
			blockList.appendChild(randomXml);
			blockList.appendChild(questionXml);
			outXml.appendChild(blockList);
			
			var showingXml:XMLList = new XMLList('<CHECK/>');
			showingXml.@variable = 'showTan';
			showingXml.appendChild(new XML('<DATA>НЕТ</DATA>'));
			showingXml.appendChild(new XML('<DATA>ЕСТЬ</DATA>'));
			showingXml.appendChild(new XML('<CURRENTDATA>' + this.showTan + '</CURRENTDATA>'));
			var showBlockList:XMLList = new XMLList('<FIELD label="блокировать" type="number" variable="showBlock" width="40">' + this.showBlock.toString() + '</FIELD>');
			var showShowList:XMLList = new XMLList('<FIELD label="показать" type="number" variable="showShow" width="40">' + this.showShow.toString() + '</FIELD>');
			blockList = new XMLList('<BLOCK label="появление"/>');
			blockList.appendChild(showingXml);
			blockList.appendChild(showBlockList);
			blockList.appendChild(showShowList);
			outXml.appendChild(blockList);
			
			
			var vanishingXml:XMLList = new XMLList('<CHECK/>');
			vanishingXml.@variable = 'vanishTan';
			vanishingXml.appendChild(new XML('<DATA>НЕТ</DATA>'));
			vanishingXml.appendChild(new XML('<DATA>ЕСТЬ</DATA>'));
			vanishingXml.appendChild(new XML('<CURRENTDATA>' + this.vanishTan + '</CURRENTDATA>'));
			var vanishingBlockList:XMLList = new XMLList('<FIELD label="блокировать" type="number" variable="vanishBlock" width="40">' + this.vanishBlock.toString() + '</FIELD>');
			var vanishingShowList:XMLList = new XMLList('<FIELD label="показать" type="number" variable="vanishShow" width="40">' + this.vanishShow.toString() + '</FIELD>');
			var vanishingVanishList:XMLList = new XMLList('<FIELD label="убрать" type="number" variable="vanishVanish" width="40">' + this.vanishVanish.toString() + '</FIELD>');
			blockList = new XMLList('<BLOCK label="исчезновение"/>');
			blockList.appendChild(vanishingXml);
			blockList.appendChild(vanishingBlockList);
			blockList.appendChild(vanishingShowList);
			blockList.appendChild(vanishingVanishList);
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
			outXml.appendChild(new XML('<COLOR label="text" variable="textColor">' + this.textColor.toString() + '</COLOR>'));
			return outXml;
		}
		
		public function get listPosition():XMLList{
			var outXml:XMLList = new XMLList('<CHECKBOX/>');
			
			outXml.X = fieldContainer.x;
			outXml.Y = fieldContainer.y;
			
			outXml.BGCOLOR = '0x' + field.backgroundColor.toString(16);
			outXml.TEXTCOLOR = '0x' + this.textColor.toString(16);
			
			outXml.WIDTH = field.width;
			outXml.HEIGHT = field.height;
			
			var varXml:XMLList = new XMLList('<ALLVARIANTS/>');
			var varArr:Array = AllZnach.split(Devider);
			var i:int;
			var l:int;
			l = varArr.length;
			for(i=0;i<l;i++){
				varXml.appendChild(new XML('<VARIANT id="'+i+'"><![CDATA['+varArr[i]+']]></VARIANT>'));
			}
			outXml.appendChild(varXml);
			outXml.appendChild(new XML('<TRUEVARIANT><![CDATA['+VernZnach+']]></TRUEVARIANT>'));
			outXml.DEVIDER = this.devider;
			if(this.showTan != 'НЕТ'){
				outXml.SHOWING.TAN = 'BLACK';
				outXml.SHOWING.BLOCK = this.showBlock;
				outXml.SHOWING.SHOW = this.showShow;
			}
			if(this.vanishTan != 'НЕТ'){
				outXml.VANISHING.TAN = 'BLACK';
				outXml.VANISHING.BLOCK = this.vanishBlock;
				outXml.VANISHING.SHOW = this.vanishShow;
				outXml.VANISHING.VANISH = this.vanishVanish;
			}
			
			outXml.RANDOM = this.random.toString();
			outXml.QUESTION = this.question.toString();
			
			if(this.complateAnimation != '') outXml.STARTANIMATIONCOMPLATE = this.complateAnimation;
			if(this.downAnimation != '') outXml.STARTANIMATIONDOWN = this.downAnimation;
			return outXml;
		}
		public function get isCorrectPosition():Boolean{
			if(fieldContainer.x<0 || fieldContainer.x>DesignerMain.STAGE.width) return false;
			if(fieldContainer.y<0 || fieldContainer.x>DesignerMain.STAGE.height) return false;
			return true;
		}
		public function normalizePosition():void{
			if(fieldContainer.x<0) fieldContainer.x = 6;
			if(fieldContainer.x>DesignerMain.STAGE.width) fieldContainer.x = DesignerMain.STAGE.width-6;
			if(fieldContainer.y<0) fieldContainer.y = 6;
			if(fieldContainer.y>DesignerMain.STAGE.height) fieldContainer.y = DesignerMain.STAGE.height - 6;
		}
	}
}