package source.Task.TaskObjects.Label {
	import flash.display.Sprite;
	import flash.text.*;
	import flash.events.EventDispatcher;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import source.DesignerMain;
	import flash.events.TextEvent;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.events.FocusEvent;
	import flash.geom.Rectangle;
	import source.utils.Figure;
	import source.Task.TaskSettings.SampleSettings;
	import source.Task.Animation.ObjectAnimation;
	import source.Task.TaskSystem;
	import flash.utils.ByteArray;

	public class ExtendLabel extends EventDispatcher{
		public static var COPY_OBJECT:String = 'onCopyObject';
		public static var GET_SETTINGS:String = 'onGetSettings';
		public static var REMOVE_LABEL:String = 'onRemoveLabel';
		public static var CHECK_TAN:String = 'onCheckTan';
		private var field:TextField;
		private var fieldSprite:Sprite;
		private var field_X:int;
		private var field_Y:int;
		private var BlackTan:Sprite;
		private var black_X:int;
		private var black_Y:int;
		private var black_Alpha:int = 1;
		private var field_Type:String;
		private var TypeInput:String = 'Nothing';
		private var CorrectColor:uint = 0x00FF00;
		private var InCorrectColor:uint = 0xFF0000;
		private var Registr:Boolean = true;
		private var DefaultText:String = '';
		private var MaxChars:int = 0;
		private var Restrict:String = '';
		
		private var id:int;
		
		private var defaultTextColor:uint;
		
		private var textFormat:TextFormat = new TextFormat();
		
		private var DragAndDrop:Boolean = false;
		private var isDinamyc:Boolean = false;
		
		private var sTan:String = 'НЕТ';
		private var sBlock:int = 0;
		private var sShow:int = 0;
		
		private var vTan:String = 'НЕТ';
		private var vBlock:int = 0;
		private var vShow:int = 0;
		private var vVanish:int = 0;
		
		private var labelContainer:Sprite;
		private var colorContainer:Sprite;
		private var blackContainer:Sprite;
		
		private var isDelete:Boolean = false;
		
		private var useDefaultText:Boolean = false;
		private var trueText:String = '';
		
		private var remContainer:Sprite;
		public var selectContainer:Sprite;
		private var boundsContainer:Sprite = new Sprite();
		private var isSelect:Boolean = false;
		
		private var isDropBack:Boolean = false;
		private var isStartPosition:Boolean = false;
		
		private var checkLastSpace:Boolean = false;
		
		//	Класс отображения сравнения полей построчно
		private var checkPoints:CheckPoints;
		//	Индекс для запоминания выделения при табуляции
		private var selectionBeginIndex:int;
		//	Переменная ыключающая режим ввода Паскаль программы
		private var asPascal:Boolean = false;
		
		//	Анимационные объекты
		private var colorAnimation:ObjectAnimation;
		private var blackAnimation:ObjectAnimation;
		//	Парметры для анимации
		private var animationToComplate:String = '';
		private var animationToMouseDown:String = '';
		
		//	текстовые поля как переменные
		private var nameVariable:String = '';
		private var randomVariable:String = '';
		private var formulaVariable:String = '';
		
		public function ExtendLabel(lblXML:XMLList, labelContainer:Sprite, colorContainer:Sprite, blackContainer:Sprite) {
			this.labelContainer = labelContainer;
			this.colorContainer = colorContainer;
			this.blackContainer = blackContainer;
			setParametrs(lblXML);
		}
		public function clear():void{
			this.DragAndDrop = false;
			colorAnimation.removeAnimation();
			colorAnimation.removeObjectAnimation();
			blackAnimation.removeAnimation();
			blackAnimation.removeObjectAnimation();
			colorAnimation.removeEventListener(ObjectAnimation.START_RECORD, COLOR_START_RECORD);
			replaceField();
			this.fieldSprite.removeChild(field);
			this.labelContainer.removeChild(this.fieldSprite);
			fieldSprite.removeEventListener(MouseEvent.MOUSE_DOWN, FIELD_MOUSE_DOWN);
			fieldSprite.removeEventListener(MouseEvent.DOUBLE_CLICK, FIELD_DOUBLE_CLICK);
			fieldSprite.removeEventListener(KeyboardEvent.KEY_DOWN, FIELD_KEY_DOWN);
			field.removeEventListener(TextEvent.TEXT_INPUT, FIELD_TEXT_INPUT);
			field.removeEventListener(FocusEvent.FOCUS_IN, FIELD_FOCUS_IN);
			field = null;
			fieldSprite = null;
		}
		private function replaceField():void{
			if(dragAndDrop){
				drawBlackTan();
				this.colorContainer.addChild(this.fieldSprite);
				this.blackContainer.addChild(this.BlackTan);
				this.BlackTan.x = this.fieldSprite.x;
				this.BlackTan.y = this.fieldSprite.y;
				this.BlackTan.addEventListener(MouseEvent.MOUSE_DOWN, BLACK_MOUSE_DOWN);
				this.BlackTan.addEventListener(KeyboardEvent.KEY_DOWN, BLACK_KEY_DOWN);
			}else{
				this.labelContainer.addChild(this.fieldSprite);
				try
				{
					this.blackContainer.removeChild(this.BlackTan);
				}
				catch(e:ArgumentError){}
				this.BlackTan.removeEventListener(MouseEvent.MOUSE_DOWN, BLACK_MOUSE_DOWN);
				this.BlackTan.removeEventListener(KeyboardEvent.KEY_DOWN, BLACK_KEY_DOWN);
			}
		}
		private function drawBlackTan():void{
			BlackTan.graphics.clear();
			BlackTan.graphics.lineStyle(0.1,0x000000);
			BlackTan.graphics.beginFill(0x000000,1);
			BlackTan.graphics.drawRect(0,0,field.width,field.height);
			BlackTan.graphics.endFill();
		}
		private function BLACK_MOUSE_DOWN(e:MouseEvent):void{
			this.BlackTan.startDrag();
			DesignerMain.STAGE.addEventListener(MouseEvent.MOUSE_UP, BLACK_MOUSE_UP);
			super.dispatchEvent(new Event(GET_SETTINGS));
		}
		private function BLACK_MOUSE_UP(e:MouseEvent):void{
			this.BlackTan.stopDrag();
			DesignerMain.STAGE.removeEventListener(MouseEvent.MOUSE_UP, BLACK_MOUSE_UP);
		}
		public function reset():void{
			field.mouseEnabled = false;
			fieldSprite.mouseChildren = false;
			fieldSprite.addEventListener(MouseEvent.MOUSE_DOWN, FIELD_MOUSE_DOWN);
			fieldSprite.addEventListener(MouseEvent.DOUBLE_CLICK, FIELD_DOUBLE_CLICK);
			fieldSprite.addEventListener(KeyboardEvent.KEY_DOWN, FIELD_KEY_DOWN);
		}
		private function BLACK_KEY_DOWN(e:KeyboardEvent):void{
			switch(e.keyCode){
				case Keyboard.A:
					BlackTan.x -= 1;
				break;
				case Keyboard.D:
					BlackTan.x += 1;
				break;
				case Keyboard.W:
					BlackTan.y -= 1;
				break;
				case Keyboard.S:
					BlackTan.y += 1;
				break;
				case Keyboard.DELETE:
					isDelete = true;
					super.dispatchEvent(new Event(REMOVE_LABEL));
				break;
				case Keyboard.C:
					if(e.ctrlKey) super.dispatchEvent(new Event(COPY_OBJECT));
				break;
			}
		}
		public function removeTan():void{
			isDelete = true;
			super.dispatchEvent(new Event(REMOVE_LABEL));
		}
		private function FIELD_KEY_DOWN(e:KeyboardEvent):void{
			switch(e.keyCode){
				case Keyboard.A:
					fieldSprite.x -= 1;
				break;
				case Keyboard.D:
					fieldSprite.x += 1;
				break;
				case Keyboard.W:
					fieldSprite.y -= 1;
				break;
				case Keyboard.S:
					fieldSprite.y += 1;
				break;
				case Keyboard.DELETE:
					isDelete = true;
					super.dispatchEvent(new Event(REMOVE_LABEL));
				break;
				case Keyboard.C:
					if(e.ctrlKey) super.dispatchEvent(new Event(COPY_OBJECT));
				break;
			}
		}
		public function get remove():Boolean{
			return isDelete;
		}
		private function FIELD_MOUSE_DOWN(e:MouseEvent):void{
			fieldSprite.startDrag();
			DesignerMain.STAGE.addEventListener(MouseEvent.MOUSE_UP, FIELD_MOUSE_UP);
			super.dispatchEvent(new Event(GET_SETTINGS));
		}
		private function FIELD_MOUSE_UP(e:MouseEvent):void{
			fieldSprite.stopDrag();
			DesignerMain.STAGE.removeEventListener(MouseEvent.MOUSE_UP, FIELD_MOUSE_UP);
			super.dispatchEvent(new Event(CHECK_TAN));
		}
		private function FIELD_DOUBLE_CLICK(e:MouseEvent):void{
			field.mouseEnabled = true;
			fieldSprite.mouseChildren = true;
			fieldSprite.removeEventListener(MouseEvent.MOUSE_DOWN, FIELD_MOUSE_DOWN);
			fieldSprite.removeEventListener(MouseEvent.DOUBLE_CLICK, FIELD_DOUBLE_CLICK);
			fieldSprite.removeEventListener(KeyboardEvent.KEY_DOWN, FIELD_KEY_DOWN);
			trace(this + ': DOUBLE CLICK');
		}
		private function FIELD_TEXT_INPUT(e:TextEvent):void{
			var timer:Timer = new Timer(10, 1);
			timer.addEventListener(TimerEvent.TIMER, CORRECT_SIZE);
			timer.start();
			super.dispatchEvent(new Event(GET_SETTINGS));
		}
		private function CORRECT_SIZE(e:TimerEvent = null):void{
			//	Проверяем был ли введён до этого символ табуляции
			if(selectionBeginIndex!=-1){
				//	Устанавливаем курсор назад в поле
				DesignerMain.STAGE.focus = field;
				//	Устанавливаем курсор в поле на старую позицию
				field.setSelection(selectionBeginIndex, selectionBeginIndex);
				//	Снимаем запоминание индекса 
				selectionBeginIndex = -1;
			}
			//	Перепроверяем текст на наличие насанкционированных символов табуляции
			if(field.text.indexOf('\u0009')!=-1){
				var i:int;
				var l:int;
				l = field.text.length;
				for(i=0;i<l;i++){
					//	Если проверяемый символ равен табуляции
					if(field.text.charAt(i) == '\u0009'){
						//	Устанавливаем вместо табуляции 
						field.replaceText(i, i+1, '        ');
						i=i+8;
					}
				}
			}
			if(field.textWidth>field.width){
				field.autoSize = getTypeAutoSize();
				field.width += 15;
			}
			if(field.textHeight>field.height){
				field.autoSize = getTypeAutoSize();
				field.width += 15;
			}
			if(checkPoints!=null){
				checkPoints.lines = field.numLines;
				checkPoints.height = field.height;
			}
			drawBlackTan();
			field.x = 0;
			field.y = 0;
			if(this.isSelect) this.drawSelect();
			if(this.pascal) SelectAsPascal();
			//super.dispatchEvent(new Event(SampleSettings.CHANGE_LIST));
		}
		private function getTypeAutoSize():String{
			var str:String = new String;
			switch(field.getTextFormat().align){
				case 'left':
				str = TextFieldAutoSize.LEFT;
				break;
				case 'center':
				str = TextFieldAutoSize.CENTER;
				break;
				case 'right':
				str = TextFieldAutoSize.RIGHT;
				break;
			}
			return str;
		}
		private function FIELD_FOCUS_IN(e:FocusEvent):void{
			super.dispatchEvent(new Event(GET_SETTINGS));
			field.addEventListener(FocusEvent.FOCUS_OUT, FIELD_FOCUS_OUT);
			field.addEventListener(KeyboardEvent.KEY_DOWN, FIEL_IN_KEY_DOWN);
		}
		private function FIEL_IN_KEY_DOWN(e:KeyboardEvent):void{
			switch(e.keyCode){
				case 8:
				case 46:
				FIELD_TEXT_INPUT(null);
			}
			selectionBeginIndex = -1;
			if(e.keyCode == Keyboard.TAB){
				field.replaceText(field.selectionBeginIndex, field.selectionEndIndex, '        ');
				selectionBeginIndex = field.selectionEndIndex+8;
				FIELD_TEXT_INPUT(null);
			}
		}
		private function FIELD_FOCUS_OUT(e:FocusEvent):void{
			field.removeEventListener(FocusEvent.FOCUS_OUT, FIELD_FOCUS_OUT);
			field.removeEventListener(KeyboardEvent.KEY_DOWN, FIEL_IN_KEY_DOWN);
		}
		
		
		public function set select(value:Boolean):void{
			trace(this + ': SELECT IS = ' + value);
			if(isSelect == value) return;
			isSelect = value;
			if(value){
				selectContainer.addChild(fieldSprite);
				selectContainer.addChild(boundsContainer);
				drawSelect();
			}else{
				boundsContainer.graphics.clear();
				selectContainer.removeChild(boundsContainer);
				labelContainer.addChild(fieldSprite);
			}
		}

		public function get select():Boolean{
			return isSelect;
		}
		public function drawSelect():void{
			boundsContainer.graphics.clear();
			var rect:Rectangle = fieldSprite.getBounds(fieldSprite.parent);
			var W:Number = rect.width + 4;
			var H:Number = rect.height + 4;
			Figure.insertCurve(boundsContainer, [[-W/2, -H/2],[W/2, -H/2],[W/2, H/2],[-W/2, H/2],[-W/2, -H/2]], 1, 1, 0x0000FF, 0);
			Figure.insertCircle(boundsContainer, 2.5, 1, 0.1, 0x000000, 1, 0xFFFFFF);
			//blackSelectContainer.rotation = this.blackR*22.5;
			boundsContainer.x = rect.x + W/2 - 2;
			boundsContainer.y = rect.y + H/2 - 2;
		}
		public function set blackR(value:Number):void{
			
		}
		public function get blackR():Number{
			return 0;
		}
		public function set colorR(value:Number):void{}
		public function get colorR():Number{
			return 0;
		}
		private function setParametrs(paramXML:XMLList):void{
			field = new TextField();
			field.text = paramXML.TEXT.toString();
			field.type = TextFieldType.INPUT;
			field.addEventListener(TextEvent.TEXT_INPUT, FIELD_TEXT_INPUT);
			field.addEventListener(FocusEvent.FOCUS_IN, FIELD_FOCUS_IN);
			this.BlackTan = new Sprite();
			fieldSprite = new Sprite();
			fieldSprite.addChild(field);
			fieldSprite.doubleClickEnabled = true;
			
			colorAnimation = TaskSystem.animationController.getAnimation(fieldSprite);
			colorAnimation.addEventListener(ObjectAnimation.START_RECORD, COLOR_START_RECORD);
			colorAnimation.classObject = this;
			blackAnimation = TaskSystem.animationController.getAnimation(BlackTan);
			
			
			this.pascal = paramXML.ASPASCAL.toString()=='true';
			
			fieldSprite.x = parseInt(paramXML.X.toString());
			fieldSprite.y = parseInt(paramXML.Y.toString());
			
			this.border = paramXML.BORDER.toString() == "true";
			this.borderColor = uint(paramXML.BORDERCOLOR.toString());
			
			this.background = paramXML.BACKGROUND.toString() == "true";
			this.backgroundColor= uint(paramXML.BACKGROUNDCOLOR.toString())
			
			this.multiline = true;
			
			this.size = parseFloat(paramXML.SIZE.toString());
			this.bold = paramXML.BOLD.toString() == "true";
			this.italic = paramXML.ITALIC.toString() == "true";
			this.color = uint(paramXML.TEXTCOLOR.toString());
			this.align = paramXML.ALIGN.toString();
			this.font = paramXML.FONT.toString();
			
			if(paramXML.VARIABLE.toString()!='') this.variable = paramXML.VARIABLE.toString();
			if(paramXML.RANDOM.toString()!='') this.random = paramXML.RANDOM.toString();
			if(paramXML.FORMULA.toString()!='') this.formula = paramXML.FORMULA.toString();
			
			this.typeField = paramXML.TYPE.@name.toString();
			
			this.height = parseInt(paramXML.HEIGHT.toString());
			this.width = parseInt(paramXML.WIDTH.toString());
			
			if(paramXML.STARTANIMATIONCOMPLATE.toString()!='') this.complateAnimation = paramXML.STARTANIMATIONCOMPLATE.toString();
			if(paramXML.STARTANIMATIONDOWN.toString()!='') this.downAnimation = paramXML.STARTANIMATIONDOWN.toString();
			
			if(this.typeField == "INPUT"){
				this.typeInput = paramXML.TYPE.TYPEINPUT.toString();
				correctColor = uint(parseInt(paramXML.TYPE.CORRECTCOLOR));
				inCorrectColor = uint(parseInt(paramXML.TYPE.INCORRECTCOLOR));
				registr = paramXML.TYPE.REGISTR.toString() == "true";
				if(paramXML.TYPE.MULTILINE.toString()!=''){
					this.multiline = paramXML.TYPE.MULTILINE.toString()=='true';
				}
				defaultText = paramXML.TYPE.DEFAULTTEXT.toString();
				this.MaxChars = parseInt(paramXML.TYPE.MAXLENGTH.toString());
				this.restrict = paramXML.TYPE.RESTRICT.toString();
				if(paramXML.TYPE.LASTSPACE.toString()!='') this.lastSpace = paramXML.TYPE.LASTSPACE.toString()=='true';
			}
			this.dragAndDrop = paramXML.TYPE.DRAGANDDROP.@tan.toString() == 'true';
			if(paramXML.TYPE.ANIMATION.toString()!='') this.listAnimationColor = paramXML.TYPE.ANIMATION;
			if(this.typeField == "STATIC" && this.dragAndDrop){
				this.BlackTan.x = parseFloat(paramXML.TYPE.DRAGANDDROP.X);
				this.BlackTan.y = parseFloat(paramXML.TYPE.DRAGANDDROP.Y);
				black_Alpha = parseInt(paramXML.TYPE.DRAGANDDROP.ALPHA);
				if(paramXML.TYPE.DRAGANDDROP.ISDINAMYC.toString()!='')this.dinamyc = paramXML.TYPE.DRAGANDDROP.ISDINAMYC.toString()=='true';
				
				if(paramXML.TYPE.DRAGANDDROP.ISDROPBACK.toString()!='')this.dropBack = paramXML.TYPE.DRAGANDDROP.ISDROPBACK.toString()=='true';
				if(paramXML.TYPE.DRAGANDDROP.ISSTARTPOS.toString()!='')this.startPosition = paramXML.TYPE.DRAGANDDROP.ISSTARTPOS.toString()=='true';
				if(paramXML.TYPE.DRAGANDDROP.ANIMATION.toString()!='') this.listAnimationBlack = paramXML.TYPE.DRAGANDDROP.ANIMATION
				this.alpha = this.alpha;
			}
			
			if(paramXML.SHOWING.@action == "true"){
				if(paramXML.SHOWING.TAN == "BlackTan"){
					this.setShowing('ЧЁРНЫЙ', parseInt(paramXML.SHOWING.BLOCKTIME), parseInt(paramXML.SHOWING.SHOWTIME));
				}else{
					this.setShowing('ЦВЕТНОЙ', parseInt(paramXML.SHOWING.BLOCKTIME), parseInt(paramXML.SHOWING.SHOWTIME));
				}
			}
			if(paramXML.VANISHING.@action == "true"){
				if(paramXML.VANISHING.TAN == "BlackTan"){
					this.setVanishing('ЧЁРНЫЙ' ,parseInt(paramXML.VANISHING.BLOCKTIME), parseInt(paramXML.VANISHING.SHOWFROM), parseInt(paramXML.VANISHING.SHOWHOW));
				}else{
					this.setVanishing('ЦВЕТНОЙ' ,parseInt(paramXML.VANISHING.BLOCKTIME), parseInt(paramXML.VANISHING.SHOWFROM), parseInt(paramXML.VANISHING.SHOWHOW));
				}
			}
			if(paramXML.CORRECTTEXT.@isUse.toString()=='true'){
				useDefault = true;
				trueDefText = paramXML.CORRECTTEXT.toString();
			}else{
				trueDefText = paramXML.CORRECTTEXT.toString();
			}
		}
		private function COLOR_START_RECORD(event:Event):void{
			this.reset();
		}
		/*
			БЛОК ПЕРЕРИСОВКИ ТЕКСТА КАК В ПАСКАЛЕ
		*/
		private function SelectAsPascal():void{
			var pascalWord:Array = new Array("program", "var", "array", "array[", "begin",
											 "end", "end.", "end;", "if", "then", "else",
											 "for", "do", "while");
			var textFormat:TextFormat = field.getTextFormat();
			var i:int;
			var j:int;
			var startInd:int;
			var stopInd:int;
			var str:String = "";
			var simpleStr:String = ",.;[";
			startInd = 0;
			for(i=0;i<field.text.length;i++){
				if(field.text.charCodeAt(i) == 32||field.text.charCodeAt(i) == 13||i==field.text.length-1){
					if(i==field.text.length-1){
						if(field.text.charCodeAt(i) != 32 && field.text.charCodeAt(i) != 13){
							str += field.text.charAt(i);
							stopInd = i+1;
						}
					}else{
						stopInd = i;
					}
					for(j=0;j<pascalWord.length;j++){
						if(equalString(pascalWord[j],str,true)){
							textFormat.color = 0xFFFFFF;
							//if(simpleStr.indexOf(str.charAt(str.length-1))==-1){
								//try{
									//field.setTextFormat(textFormat,startInd,stopInd);
								//}catch(e:RangeError){/*trace("RangeError1")*/}
							//}else{
								//field.setTextFormat(textFormat,startInd,stopInd/*-1*/);
							//}
							try{
								field.setTextFormat(textFormat,startInd,stopInd);
							}catch(e:RangeError){
								field.setTextFormat(textFormat,startInd,stopInd-1);
							}
							break;
						}
						if(j == pascalWord.length-1){
							textFormat.color = this.color;
							try{
								field.setTextFormat(textFormat,startInd,stopInd);
							}catch(e:RangeError){/*trace("RangeError2")*/}
						}
					}
					str = "";
					startInd = i+1;
				}else{
					str += field.text.charAt(i);
				}
			}
			var numAmper:int = 0;
			for(i=0;i<field.text.length;i++){
				if(field.text.charAt(i) == "'"){
					++numAmper;
					switch(numAmper){
						case 1:
							startInd = i;
						break;
						case 2:
							stopInd = i+1;
							textFormat.color = 0x00CC00;
							field.setTextFormat(textFormat,startInd,stopInd);
							numAmper = 0;
						break;
					}
				}
				if(i == field.text.length-1 && numAmper == 1){
					stopInd = i+1;
					textFormat.color = 0x00CC00;
					field.setTextFormat(textFormat,startInd,stopInd);
				}
			}
		}
		
		//	Проверка двух строк с учётом/без учёта регистра
		private function equalString(str1:String, str2:String,reg:Boolean):Boolean{
			var flag:Boolean = true;
			var i:int;
			if(str1.length == str2.length){
				if(reg){
					var arrBigLetter:String = "ABCDEFGHIJKLMNOPQRSTUVWXYZАБВГДЕЁЖЗИЙКЛМНОПРСТУФХЦЧШЩЪЫЬЭЮЯ";
					var arrSmalLetter:String = "abcdefghijklmnopqrstuvwxyzабвгдеёжзийклмнопрстуфхцчшщъыьэюя";
					var indBig1:int;
					var indBig2:int;
					var indSmal1:int;
					var indSmal2:int;
					var rem1:int;
					var rem2:int;
					for(i=0;i<str1.length;i++){
						indBig1 = arrBigLetter.indexOf(str1.charAt(i));
						indSmal1 = arrSmalLetter.indexOf(str1.charAt(i));
						indBig2 = arrBigLetter.indexOf(str2.charAt(i));
						indSmal2 = arrSmalLetter.indexOf(str2.charAt(i));
						if(indBig1!=-1 || indSmal1!=-1){
							rem1 = -1; rem2 = -1;
							if(indBig1 != -1){ rem1 = indBig1};
							if(indSmal1 != -1){ rem1 = indSmal1};
							
							if(indBig2 != -1){ rem2 = indBig2};
							if(indSmal2 != -1){ rem2 = indSmal2};
							if(rem1 != rem2){
								flag = false;
								break;
							}
						}else{
							if(str1.charAt(i) != str2.charAt(i)){
								flag = false;
								break;
							}
						}
					}
				}else{
					if(str1 != str2){
						flag = false;
					}
				}
			}else{
				flag = false;
			}
			return flag;
		}
		/*
			===================================================================
		*/
		
		public function get colorX():Number{
			return fieldSprite.x;
		}
		public function get colorY():Number{
			return fieldSprite.y;
		}
		public function get blackX():Number{
			return BlackTan.x;
		}
		public function get blackY():Number{
			return BlackTan.y;
		}
		public function set width(value:Number):void{
			field.autoSize = TextFieldAutoSize.NONE;
			field.width = value;
			if(dragAndDrop) this.drawBlackTan();
			trace(this + ': VALUE = ' + value + '; FIWLD WIDTH = ' + field.width)
			if(this.isSelect) this.drawSelect();
		}
		public function get width():Number{
			return field.width;
		}
		public function set height(value:Number):void{
			field.autoSize = TextFieldAutoSize.NONE;
			field.height = value;
			if(dragAndDrop) this.drawBlackTan();
			if(this.isSelect) this.drawSelect();
			
		}
		public function get height():Number{
			return field.height;
		}
		public function get tanColor():Sprite{
			return fieldSprite;
		}
		public function get tanBlack():Sprite{
			return this.BlackTan;
		}
		public function get content():ByteArray{
			return null;
		}
		public function get fileName():String{
			return '';
		}
		public function set labelGroup(value:String):void{
			
		}
		public function set typeField(value:String):void{
			if(value == '') value = 'STATIC';
			if(field_Type == value) return;
			field_Type = value;
 			if(field_Type!='INPUT'){
				if(TypeInput == 'Lines'){
					if(checkPoints!=null){
						fieldSprite.removeChild(checkPoints);
						checkPoints.clear();
						checkPoints = null;
					}
				}
			}else{
				if(TypeInput == 'Lines'){
					checkPoints = new CheckPoints(field.numLines, field.height);
					fieldSprite.addChild(checkPoints);
				}
			}
			super.dispatchEvent(new Event(SampleSettings.CHANGE_LIST));
		}
		public function get typeField():String{
			return field_Type;
		}
		public function set dragAndDrop(value:Boolean):void{
			DragAndDrop = value;
			this.replaceField();
			if(!DragAndDrop){
				this.colorAnimation.removeAnimation();
			}
			super.dispatchEvent(new Event(SampleSettings.CHANGE_LIST));
		}
		public function get dragAndDrop():Boolean{
			return DragAndDrop;
		}
		public function set border(value:Boolean):void{
			field.border = value;
		}
		public function get border():Boolean{
			return field.border;
		}
		public function set borderColor(value:uint):void{
			field.borderColor = value;
		}
		public function get borderColor():uint{
			return field.borderColor;
		}
		public function set background(value:Boolean):void{
			field.background = value;
		}
		public function get background():Boolean{
			return field.background;
		}
		public function set backgroundColor(value:uint):void{
			field.backgroundColor = value;
		}
		public function get backgroundColor():uint{
			return field.backgroundColor;
		}
		public function set multiline(value:Boolean):void{
			field.multiline = value;
		}
		public function get multiline():Boolean{
			return field.multiline;
		}
		public function set size(value:Number):void{
			textFormat.size = value;
			applyTextFormat();
		}
		public function get size():Number{
			return textFormat.size as Number;
		}
		public function get pascal():Boolean{
			return asPascal;
		}
		public function set pascal(value:Boolean):void{
			asPascal = value;
			if(asPascal){
				this.backgroundColor = 0x0000CC;
				this.color = 0xFFFF00;
				this.font = "LucidaConsole";
				bold = true;
				size = 20;
				SelectAsPascal();
			}else{
				this.color = 0xFFFF00;
			}
		}
		public function set bold(value:Boolean):void{
			textFormat.bold = value;
			applyTextFormat();
		}
		public function get bold():Boolean{
			return textFormat.bold;
		}
		public function set italic(value:Boolean):void{
			textFormat.italic = value;
			applyTextFormat()
		}
		public function get italic():Boolean{
			return textFormat.italic;
		}
		public function set align(value:String):void{
			if(value == '') value = 'left';
			textFormat.align = value;
			applyTextFormat();
		}
		public function get align():String{
			return textFormat.align;
		}
		public function set color(value:uint):void{
			textFormat.color = value;
			applyTextFormat();
		}
		public function get color():uint{
			return textFormat.color as uint;
		}
		public function set font(value:String):void{
			if(value == "LucidaConsole"){
				var _font:Font = new LucidaConsole();
				textFormat.font = _font.fontName;
			}else{
				textFormat.font = value;
			}
			applyTextFormat();
		}
		public function get font():String{
			return textFormat.font;
		}
		public function get text():String{
			return field.text;
		}
		
		private function applyTextFormat():void{
			field.setTextFormat(textFormat);
			field.defaultTextFormat = textFormat;
			CORRECT_SIZE();
		}
		
		
		//	Параметры для поля ввода
		public function set typeInput(value:String):void{
			if(TypeInput == value) return;
			TypeInput = value;
			if(TypeInput == 'Lines'){
				checkPoints = new CheckPoints(field.numLines, field.height);
				fieldSprite.addChild(checkPoints);
			}else{
				if(checkPoints!=null){
					fieldSprite.removeChild(checkPoints);
					checkPoints.clear();
					checkPoints = null;
				}
			}
		}
		public function get typeInput():String{
			return TypeInput;
		}
		public function set correctColor(value:uint):void{
			CorrectColor = value;
		}
		public function get correctColor():uint{
			return CorrectColor;
		}
		public function set inCorrectColor(value:uint):void{
			InCorrectColor = value;
		}
		public function get inCorrectColor():uint{
			return InCorrectColor;
		}
		public function set registr(value:Boolean):void{
			Registr = value;
		}
		public function get registr():Boolean{
			return Registr;
		}
		public function set defaultText(value:String):void{
			DefaultText = value;
		}
		public function get defaultText():String{
			return DefaultText;
		}
		public function set maxChars(value:int):void{
			MaxChars = value;
		}
		public function get maxChars():int{
			return MaxChars;
		}
		public function set restrict(value:String):void{
			Restrict = value;
		}
		public function get restrict():String{
			return Restrict;
		}
		public function set alpha(value:Boolean):void{
			if(value) {
				black_Alpha = 0;
				this.BlackTan.alpha = 0.2;
			}
			else {
				black_Alpha = 1;
				this.BlackTan.alpha = 1;
			}
		}
		public function get alpha():Boolean{
			if(black_Alpha == 1) return false;
			return true;
		}
		public function set dinamyc(value:Boolean):void{
			isDinamyc = value;
		}
		public function get dinamyc():Boolean{
			return isDinamyc;
		}
		
		
		public function set dropBack(value:Boolean):void{
			isDropBack = value;
		}
		public function get dropBack():Boolean{
			return isDropBack;
		}
		public function set startPosition(value:Boolean):void{
			isStartPosition = value;
		}
		public function get startPosition():Boolean{
			return isStartPosition;
		}
		public function set lastSpace(value:Boolean):void{
			checkLastSpace = value;
		}
		public function get lastSpace():Boolean{
			return checkLastSpace;
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
		
		public function set ID(value:int):void{
			id = value;
		}
		public function get ID():int{
			return id;
		}
		
		public function set useDefault(value:Boolean):void{
			useDefaultText = value;
			if(trueText!='' && value){
				this.field.text = trueDefText;
				FIELD_TEXT_INPUT(null);
			}
		}
		public function get useDefault():Boolean{
			return useDefaultText;
		}
		public function set trueDefText(value:String):void{
			trueText = value;
			if(useDefault) {
				this.field.text = value;
				FIELD_TEXT_INPUT(null);
			}
		}
		public function get trueDefText():String{
			return trueText;
		}
		
		//	Блок методов взаимодействия внешних систем с анимацией
		public function get animationColorTan():ObjectAnimation{
			return this.colorAnimation;
		}
		public function get animationBlackTan():ObjectAnimation{
			return blackAnimation;
		}
		
		public function get listAnimationColor():XMLList{
			if(colorAnimation.hasAnimation) return colorAnimation.listPosition;
			return null;
		}
		public function set listAnimationColor(value:XMLList):void{
			if(colorAnimation!=null) colorAnimation.listPosition = value;
		}
		public function get listAnimationBlack():XMLList{
			if(blackAnimation.hasAnimation) return blackAnimation.listPosition;
			return null;
		}
		public function set listAnimationBlack(value:XMLList):void{
			if(blackAnimation!=null) blackAnimation.listPosition = value;
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
		
		
		public function set variable(value:String):void{
			nameVariable = value;
		}
		public function get variable():String{
			return nameVariable;
		}
		public function set random(value:String):void{
			randomVariable = value;
		}
		public function get random():String{
			return randomVariable;
		}
		public function set formula(value:String):void{
			formulaVariable = value;
		}
		public function get formula():String{
			return formulaVariable;
		}
		
		public function get simpleSettings():XMLList{
			var outXml:XMLList = new XMLList('<PACKAGE/>');
			outXml.@label = 'НАДПИСЬ';
			var widthList:XMLList = new XMLList('<FIELD label="ширина" type="number" variable="width" width="40">' + this.width.toString() + '</FIELD>');
			var heightList:XMLList = new XMLList('<FIELD label="высота" type="number" variable="height" width="40">' + this.height.toString() + '</FIELD>');			
			
			var blockList:XMLList = new XMLList('<BLOCK label="размер надписи"/>');
			blockList.appendChild(widthList);
			blockList.appendChild(heightList);
			outXml.appendChild(blockList);
			
			
			var additionalXml:XMLList = new XMLList('<CHECK/>');
			additionalXml.@variable = 'font';
			additionalXml.appendChild(new XML('<DATA>Times New Roman</DATA>'));
			additionalXml.appendChild(new XML('<DATA>LucidaConsole</DATA>'));
			additionalXml.appendChild(new XML('<DATA>Arial</DATA>'));
			additionalXml.appendChild(new XML('<CURRENTDATA>' + this.font + '</CURRENTDATA>'));
			widthList = new XMLList('<FIELD label="размер шрифта" type="number" variable="size" width="40">' + this.size.toString() + '</FIELD>');
			blockList = new XMLList('<BLOCK label="шрифт"/>');
			var pascalXMLList:XMLList = new XMLList('<MARK label="Паскаль" variable="pascal">'+this.pascal.toString()+'</MARK>');
			blockList.appendChild(additionalXml);
			blockList.appendChild(widthList);
			blockList.appendChild(pascalXMLList);
			outXml.appendChild(blockList);
			
			widthList = new XMLList('<MARK label="жирный" variable="bold">'+this.bold.toString()+'</MARK>');
			heightList = new XMLList('<MARK label="наклонный" variable="italic">'+this.italic.toString()+'</MARK>');			
			
			additionalXml = new XMLList('<CHECK/>');
			additionalXml.@variable = 'align';
			additionalXml.appendChild(new XML('<DATA>left</DATA>'));
			additionalXml.appendChild(new XML('<DATA>center</DATA>'));
			additionalXml.appendChild(new XML('<DATA>right</DATA>'));
			additionalXml.appendChild(new XML('<CURRENTDATA>' + this.align + '</CURRENTDATA>'));

			blockList = new XMLList('<BLOCK label="--"/>');
			blockList.appendChild(widthList);
			blockList.appendChild(heightList);
			blockList.appendChild(additionalXml);
			outXml.appendChild(blockList);
			
			widthList = new XMLList('<MARK label="рамка" variable="border">'+this.border.toString()+'</MARK>');
			heightList = new XMLList('<MARK label="фон" variable="background">'+this.background.toString()+'</MARK>');	
			blockList = new XMLList('<BLOCK label="оформление"/>');
			blockList.appendChild(widthList);
			blockList.appendChild(heightList);
			outXml.appendChild(blockList);
			
			
			var variableList:XMLList = new XMLList('<FIELD label="переменная" type="string" variable="variable" width="40">' + this.variable + '</FIELD>');
			var randomList:XMLList = new XMLList('<FIELD label="случайное" type="string" variable="random" width="40">' + this.random + '</FIELD>');
			var formulaList:XMLList = new XMLList('<FIELD label="формула" type="string" variable="formula" width="40">' + this.formula + '</FIELD>');
			blockList = new XMLList('<BLOCK label="вычисление"/>');
			blockList.appendChild(variableList);
			blockList.appendChild(randomList);
			blockList.appendChild(formulaList);
			outXml.appendChild(blockList);
			
			
			additionalXml = new XMLList('<CHECK/>');
			additionalXml.@variable = 'typeField';
			additionalXml.appendChild(new XML('<DATA>STATIC</DATA>'));
			additionalXml.appendChild(new XML('<DATA>DINAMIC</DATA>'));
			additionalXml.appendChild(new XML('<DATA>INPUT</DATA>'));
			additionalXml.appendChild(new XML('<CURRENTDATA>' + this.typeField + '</CURRENTDATA>'));
			blockList = new XMLList('<BLOCK label="тип поля"/>');
			blockList.appendChild(additionalXml);
			outXml.appendChild(blockList);
			
			var showingXml:XMLList = new XMLList('<CHECK/>');
			showingXml.@variable = 'showTan';
			showingXml.appendChild(new XML('<DATA>НЕТ</DATA>'));
			showingXml.appendChild(new XML('<DATA>ЦВЕТНОЙ</DATA>'));
			showingXml.appendChild(new XML('<DATA>ЧЁРНЫЙ</DATA>'));
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
			vanishingXml.appendChild(new XML('<DATA>ЦВЕТНОЙ</DATA>'));
			vanishingXml.appendChild(new XML('<DATA>ЧЁРНЫЙ</DATA>'));
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
		public function get staticSettings():XMLList{
			var outXml:XMLList = this.simpleSettings;
			var widthList:XMLList = new XMLList('<MARK label="тан" variable="dragAndDrop">'+this.dragAndDrop.toString()+'</MARK>');
			var blockList:XMLList = new XMLList('<BLOCK label="настройки тана"/>');
			blockList.appendChild(widthList);
			if(this.dragAndDrop){
				var heightList:XMLList = new XMLList('<MARK label="прозрачность" variable="alpha">'+this.alpha+'</MARK>');
				var dinamycList:XMLList = new XMLList('<MARK label="динамический" variable="dinamyc">'+this.dinamyc+'</MARK>');
				blockList.appendChild(heightList);
				blockList.appendChild(dinamycList);
				outXml.appendChild(blockList);
				blockList = new XMLList('<BLOCK label="постановка"/>');
				var dropList:XMLList = new XMLList('<MARK label="Не блокировать" variable="dropBack">'+this.dropBack.toString()+'</MARK>');
				var startPosList:XMLList = new XMLList('<MARK label="На стартовую позицию" variable="startPosition">'+this.startPosition.toString()+'</MARK>');
				blockList.appendChild(dropList);
				blockList.appendChild(startPosList);
			}
			outXml.appendChild(blockList);
			var animationColorXML:XMLList = new XMLList('<ANIMATION variable="animationColorTan"/>');
			blockList = new XMLList('<BLOCK label="анимация надписи"/>');
			blockList.appendChild(animationColorXML);
			outXml.appendChild(blockList);
			if(this.dragAndDrop){
				var animationBlackXML:XMLList = new XMLList('<ANIMATION variable="animationBlackTan"/>');
				blockList = new XMLList('<BLOCK label="анимация чёрного"/>');
				blockList.appendChild(animationBlackXML);
				outXml.appendChild(blockList);
			}
			return outXml;
		}
		public function get dynamicSettings():XMLList{
			var outXml:XMLList = this.simpleSettings;
			var animationColorXML:XMLList = new XMLList('<ANIMATION variable="animationColorTan"/>');
			var blockList:XMLList = new XMLList('<BLOCK label="анимация надписи"/>');
			blockList.appendChild(animationColorXML);
			outXml.appendChild(blockList);
			return outXml;
		}
		public function get inputSettings():XMLList{
			trace(this + ': GET INPUT');
			var outXml:XMLList = this.simpleSettings;
			var animationColorXML:XMLList = new XMLList('<ANIMATION variable="animationColorTan"/>');
			blockList = new XMLList('<BLOCK label="анимация надписи"/>');
			blockList.appendChild(animationColorXML);
			outXml.appendChild(blockList);
			var additionalXml:XMLList = new XMLList('<CHECK/>');
			additionalXml.@variable = 'typeInput';
			additionalXml.appendChild(new XML('<DATA>Nothing</DATA>'));
			additionalXml.appendChild(new XML('<DATA>EverySymbol</DATA>'));
			additionalXml.appendChild(new XML('<DATA>AllIncorrect</DATA>'));
			additionalXml.appendChild(new XML('<DATA>FullLength</DATA>'));
			additionalXml.appendChild(new XML('<DATA>AllCorrect</DATA>'));
			additionalXml.appendChild(new XML('<DATA>NotInput</DATA>'));
			additionalXml.appendChild(new XML('<DATA>Lines</DATA>'));
			additionalXml.appendChild(new XML('<DATA>AsPascal</DATA>'));
			additionalXml.appendChild(new XML('<CURRENTDATA>' + this.typeInput + '</CURRENTDATA>'));
			var lastSpaceXML:XMLList = new XMLList('<MARK label="учитывать пробелы в конце" variable="lastSpace">'+this.lastSpace.toString()+'</MARK>');
			var blockList:XMLList = new XMLList('<BLOCK label="обработка ввода"/>');
			blockList.appendChild(additionalXml);
			blockList.appendChild(lastSpaceXML);
			outXml.appendChild(blockList);
			
			var defaultTextList:XMLList = new XMLList('<FIELD label="Текст по умолчанию" type="string" variable="defaultText" width="250"><![CDATA[' + this.defaultText.toString() + ']]></FIELD>');
			var correctSymbolList:XMLList = new XMLList('<FIELD label="Допустимые символы" type="string" variable="restrict" width="40"><![CDATA[' + this.restrict.toString() + ']]></FIELD>');
			blockList = new XMLList('<BLOCK label="формат ввода"/>');
			blockList.appendChild(defaultTextList);
			blockList.appendChild(correctSymbolList);
			outXml.appendChild(blockList);
			
			var maxLengthList:XMLList = new XMLList('<FIELD label="длина строки" type="string" variable="maxChars" width="40">' + this.maxChars.toString() + '</FIELD>');
			var registrList:XMLList = new XMLList('<MARK label="учитывать регистр" variable="registr">'+this.registr.toString()+'</MARK>');
			var multilineList:XMLList = new XMLList('<MARK label="многострочность" variable="multiline">'+this.multiline.toString()+'</MARK>');
			blockList = new XMLList('<BLOCK/>');
			blockList.appendChild(maxLengthList);
			blockList.appendChild(registrList);
			blockList.appendChild(multilineList);
			outXml.appendChild(blockList);
			
			var trueMarkList:XMLList = new XMLList('<MARK label=" " variable="useDefault">'+this.useDefault.toString()+'</MARK>');
			var trueFieldList:XMLList = new XMLList('<FIELD label=" " type="string" variable="trueDefText" align="left" multiline="true" width="350" height="150"><![CDATA[' + this.trueDefText + ']]></FIELD>');
			blockList = new XMLList('<BLOCK label="Текст редактирования"/>');
			blockList.appendChild(trueMarkList);
			blockList.appendChild(trueFieldList);
			outXml.appendChild(blockList);
			
			
			return outXml;
		}
		public function get baseColorList():XMLList{
			var outXml:XMLList = new XMLList('<PACKAGE/>');
			outXml.appendChild(new XML('<COLOR label="fill" variable="backgroundColor">' + this.backgroundColor.toString() + '</COLOR>'));
			outXml.appendChild(new XML('<COLOR label="line" variable="borderColor">' + this.borderColor.toString() + '</COLOR>'));
			outXml.appendChild(new XML('<COLOR label="text" variable="color">' + this.color.toString() + '</COLOR>'));
			return outXml;
		}
		public function get otherColorSettings():XMLList{
			var outXml:XMLList = this.baseColorList;
			outXml.appendChild(new XML('<COLOR label="верный цвет" variable="correctColor">' + this.correctColor.toString() + '</COLOR>'));
			outXml.appendChild(new XML('<COLOR label="не верный цвет" variable="inCorrectColor">' + this.inCorrectColor.toString() + '</COLOR>'));
			return outXml;
		}
		
		public function get isCorrectPosition():Boolean{
			if(colorContainer.x<0 || colorContainer.x>DesignerMain.STAGE.width) return false;
			if(colorContainer.y<0 || colorContainer.x>DesignerMain.STAGE.height) return false;
			if(blackContainer.x<0 || blackContainer.x>DesignerMain.STAGE.width) return false;
			if(blackContainer.y<0 || blackContainer.x>DesignerMain.STAGE.height) return false;
			if(labelContainer.x<0 || labelContainer.x>DesignerMain.STAGE.width) return false;
			if(labelContainer.y<0 || labelContainer.x>DesignerMain.STAGE.height) return false;
			return true;
		}
		public function normalizePosition():void{
			if(colorContainer.x<0) colorContainer.x = 6;
			if(colorContainer.x>DesignerMain.STAGE.width) colorContainer.x = DesignerMain.STAGE.width-6;
			if(colorContainer.y<0) colorContainer.y = 6;
			if(colorContainer.y>DesignerMain.STAGE.height) colorContainer.y = DesignerMain.STAGE.height - 6;
			
			if(blackContainer.x<0) blackContainer.x = 6;
			if(blackContainer.x>DesignerMain.STAGE.width) blackContainer.x = DesignerMain.STAGE.width-6;
			if(blackContainer.y<0) blackContainer.y = 6;
			if(blackContainer.y>DesignerMain.STAGE.height) blackContainer.y = DesignerMain.STAGE.height - 6;
			
			if(labelContainer.x<0) labelContainer.x = 6;
			if(labelContainer.x>DesignerMain.STAGE.width) labelContainer.x = DesignerMain.STAGE.width-6;
			if(labelContainer.y<0) labelContainer.y = 6;
			if(labelContainer.y>DesignerMain.STAGE.height) labelContainer.y = DesignerMain.STAGE.height - 6;
		}
	}
}