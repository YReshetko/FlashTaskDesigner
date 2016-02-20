package source.BlockOfTask.Task.TaskObjects.Label {
	import flash.display.Sprite;
	import flash.text.*;
	import flash.events.EventDispatcher;
	import flash.events.KeyboardEvent;
	import flash.events.Event;
	import source.MainPlayer;
	import flash.events.MouseEvent;
	import source.BlockOfTask.Task.Animation.ObjectAnimation;

	public class ExtendLabel extends Sprite{
		public static var TAB_DOWN:String = 'onTabDown';
		
		private var field:TextField;
		private var fieldSprite:Sprite;
		private var field_X:int;
		private var field_Y:int;
		private var BlackTan:Sprite;
		private var black_X:int;
		private var black_Y:int;
		private var black_Alpha:int;
		private var field_Type:String;
		private var typeInput:String;
		private var CorrectColor:uint;
		private var InCorrectColor:uint;
		private var registr:Boolean;
		private var defaultText:String;
		
		private var id:int;
		
		private var defoultTextColor:uint;
		
		private var textFormat:TextFormat = new TextFormat();
		
		private var rightInputText:String;
		
		private var DragAndDrop:Boolean = false;
		private var isDinamyc:Boolean = false;
		private var blackFree:Boolean = true;
		private var colorStand:Boolean = false;
		
		private var isDropBack:Boolean = false;
		private var isStartPosition:Boolean = false;
		private var remBlackTan:LabelClass;
		
		private var pojavl:int;
		private var pojavl_block:int;
		private var pojavl_show:int;
		private var ischezn:int;
		private var ischezn_block:int;
		private var ischezn_show:int;
		private var ischezn_timeShow:int;
		
		
		private var trueText:String = '';
		public var useTrueText:Boolean = false;
		
		private var checkLastSpace:Boolean = false;
		
		public var checkPoints:CheckPoints;
		
		public var asPascal:Boolean = false;
		//	Объекты анимации танов
		private var colorAnimation:ObjectAnimation;
		private var blackAnimation:ObjectAnimation;
		
		private var colorXmlAnimation:XMLList;
		private var blackXmlAnimation:XMLList;
		
		public var animationToComplate:String = '';
		public var animationToDown:String = '';
		public var currentLabel:String = '';
		//	Переменные для формул
		private var labelVariable:String = '';
		private var labelRandom:String = '';
		private var labelFormula:String = '';
		public function ExtendLabel(lblXML:XMLList) {
			pojavl = 0;pojavl_block=0;pojavl_show=0;
			ischezn = 0;ischezn_block=0;ischezn_show=0;ischezn_timeShow=0;
			setParametrs(lblXML);
		}
		private function setParametrs(paramXML:XMLList):void{
			//trace(this + 'in XML = ' + paramXML);
			field = new TextField();
			fieldSprite = new Sprite;
			fieldSprite.addChild(field);
			asPascal = paramXML.ASPASCAL.toString() == 'true';
			field.height = parseInt(paramXML.HEIGHT);
			field.width = parseInt(paramXML.WIDTH);
			field_X = parseInt(paramXML.X);
			field_Y = parseInt(paramXML.Y);
			field.border = paramXML.BORDER.toString() == "true";
			if(field.border){
				field.borderColor = paramXML.BORDERCOLOR;
			}
			field.background = paramXML.BACKGROUND.toString() == "true";
			if(field.background){
				field.backgroundColor = paramXML.BACKGROUNDCOLOR;
			}
			field.multiline = true;
			textFormat.size = paramXML.SIZE;
			textFormat.bold = paramXML.BOLD.toString() == "true";
			textFormat.italic = paramXML.ITALIC.toString() == "true";
			textFormat.color = parseInt(paramXML.TEXTCOLOR);
			defoultTextColor = uint(parseInt(paramXML.TEXTCOLOR));
			try{
				textFormat.align = paramXML.ALIGN;
			}catch(e:ArgumentError){
				textFormat.align = "left";
			}
			var _font:Font;
			switch(paramXML.FONT.toString()){
				case 'LucidaConsole':
					_font = new LucidaConsole();
					textFormat.font = _font.fontName;
				break;
				case 'Times New Roman':
					_font = new TimesNewRoman();
					textFormat.font = _font.fontName;
				break;
				case 'Arial':
					_font = new Arial();
					textFormat.font = _font.fontName;
				break;
				default:
					textFormat.font = paramXML.FONT.toString();
			}
			
			/*if(paramXML.FONT == "LucidaConsole"){
				var _font:Font = new LucidaConsole();
				textFormat.font = _font.fontName;
			}else{
				textFormat.font = paramXML.FONT.toString();
			}*/
			field.setTextFormat(textFormat);
			field.defaultTextFormat = textFormat;
			rightInputText = paramXML.TEXT;
			
			if(paramXML.STARTANIMATIONCOMPLATE.toString()!='') animationToComplate = paramXML.STARTANIMATIONCOMPLATE.toString();
			if(paramXML.STARTANIMATIONDOWN.toString()!='') animationToDown = paramXML.STARTANIMATIONDOWN.toString();
			
			if(paramXML.TYPE.@name == "INPUT"){
				field_Type = "INPUT";
				field.type = TextFieldType.INPUT;
				setTypeInput(paramXML.TYPE.TYPEINPUT);
				CorrectColor = uint(parseInt(paramXML.TYPE.CORRECTCOLOR));
				InCorrectColor = uint(parseInt(paramXML.TYPE.INCORRECTCOLOR));
				registr = paramXML.TYPE.REGISTR.toString() == "true";
				if(paramXML.TYPE.MULTILINE.toString()!=''){
					field.multiline = (paramXML.TYPE.MULTILINE.toString()=='true');
					if(!field.multiline){
						field.addEventListener(KeyboardEvent.KEY_DOWN, FIELD_KEY_DOWN_ENTER);
					}
				}
				defaultText = paramXML.TYPE.DEFAULTTEXT;
				try{
					field.maxChars = parseInt(paramXML.TYPE.MAXLENGTH);
					field.restrict = paramXML.TYPE.RESTRICT.toString();
					if(field.restrict == "" || field.restrict == "null"){
						field.restrict = null;
					}
				}catch(e:ArgumentError){};
				if(paramXML.CORRECTTEXT.@isUse.toString()=='true'){
					rightInputText = paramXML.CORRECTTEXT;
					field.text = paramXML.TEXT;
					useTrueText = true;
				}
				if(paramXML.TYPE.LASTSPACE.toString()!='') checkLastSpace = paramXML.TYPE.LASTSPACE.toString()=='true';
			}
			if(paramXML.TYPE.@name == "STATIC" && paramXML.TYPE.DRAGANDDROP.@tan == "true"){
				field_Type = "STATIC";
				field.type = TextFieldType.DYNAMIC;
				field.mouseEnabled = false;
				DragAndDrop = true;
				black_X = paramXML.TYPE.DRAGANDDROP.X;
				black_Y = paramXML.TYPE.DRAGANDDROP.Y;
				black_Alpha = parseInt(paramXML.TYPE.DRAGANDDROP.ALPHA);
				this.dinamyc = paramXML.TYPE.DRAGANDDROP.ISDINAMYC.toString()=='true';
				this.dropBack = paramXML.TYPE.DRAGANDDROP.ISDROPBACK.toString()=='true';
				this.startPosition = paramXML.TYPE.DRAGANDDROP.ISSTARTPOS.toString()=='true';
			}else{
				if(paramXML.TYPE.@name == "STATIC"){
					field_Type = "STATIC";
					field.type = TextFieldType.DYNAMIC
					fieldSprite.mouseChildren = false;
					fieldSprite.mouseEnabled = false;
				}
			}
			if(paramXML.TYPE.@name == "DINAMIC"){
				field_Type = "DINAMIC";
				field.type = TextFieldType.DYNAMIC;
			}
			if(paramXML.SHOWING.@action == "true"){
				if(paramXML.SHOWING.TAN == "BlackTan"){
					setPojavl([1,parseInt(paramXML.SHOWING.BLOCKTIME), parseInt(paramXML.SHOWING.SHOWTIME)]);
				}else{
					setPojavl([2,parseInt(paramXML.SHOWING.BLOCKTIME), parseInt(paramXML.SHOWING.SHOWTIME)]);
				}
			}
			if(paramXML.VANISHING.@action == "true"){
				if(paramXML.VANISHING.TAN == "BlackTan"){
					setIschezn([1,parseInt(paramXML.VANISHING.BLOCKTIME), parseInt(paramXML.VANISHING.SHOWFROM), parseInt(paramXML.VANISHING.SHOWHOW)]);
				}else{
					setIschezn([2,parseInt(paramXML.VANISHING.BLOCKTIME), parseInt(paramXML.VANISHING.SHOWFROM), parseInt(paramXML.VANISHING.SHOWHOW)]);
				}
			}
			colorXmlAnimation = null;
			blackXmlAnimation = null;
			if(paramXML.TYPE.ANIMATION.toString()!='') colorXmlAnimation = paramXML.TYPE.ANIMATION;
			if(DragAndDrop) if(paramXML.TYPE.DRAGANDDROP.ANIMATION.toString()!='') blackXmlAnimation = paramXML.TYPE.DRAGANDDROP.ANIMATION;
			
			if(paramXML.VARIABLE.toString()!='') labelVariable = paramXML.VARIABLE.toString();
			if(paramXML.RANDOM.toString()!='') labelRandom = paramXML.RANDOM.toString();
			if(paramXML.FORMULA.toString()!='') labelFormula = paramXML.FORMULA.toString();
		}
		public function getTypeField():String{
			return field_Type;
		}
		public function setTypeInput(value:String):void{
			typeInput = value;
		}
		public function initLinesChecker():void{
			if(typeInput == 'Lines'){
				var arrLines:Array = this.getRightText().split('\r');
				checkPoints = new CheckPoints(arrLines.length, field.height);
				fieldSprite.addChild(checkPoints);
			}
		}
		public function getTypeInput():String{
			return typeInput;
		}
		public function getColor():Array{
			return new Array(CorrectColor, InCorrectColor);
		}
		public function gerDefTextColor():uint{
			return defoultTextColor;
		}
		public function get tanColor():Sprite{
			return this.fieldSprite;
		}
		public function get tanBlack():Sprite{
			return new Sprite();
		}
		public function addFieldAsLabel(spr:Sprite):void{
			spr.addChild(fieldSprite);
			fieldSprite.x = field_X;
			fieldSprite.y = field_Y;
			if(colorXmlAnimation!=null) this.listColorAnimation = colorXmlAnimation;
		}
		public function addFieldAsTan(sprColor:Sprite, sprBlack:Sprite):void{
			BlackTan = new Sprite;
			BlackTan.graphics.lineStyle(0.1,0x000000);
			BlackTan.graphics.beginFill(0x000000,1);
			BlackTan.graphics.drawRect(0,0,field.width,field.height);
			BlackTan.graphics.endFill();
			sprColor.addChild(fieldSprite);
			fieldSprite.x = field_X;
			fieldSprite.y = field_Y;
			sprBlack.addChild(BlackTan);
			BlackTan.x = black_X;
			BlackTan.y = black_Y;
			BlackTan.alpha = black_Alpha;
			field.text = rightInputText;
			if(colorXmlAnimation!=null) this.listColorAnimation = colorXmlAnimation;
			if(blackXmlAnimation!=null) this.listBlackAnimation = blackXmlAnimation;
		}
		public function getTextField():TextField{
			return field;
		}
		public function getSpriteField():Sprite{
			return fieldSprite;
		}
		public function getSpriteBlack():Sprite{
			return BlackTan;
		}
		public function getDragAndDrop():Boolean{
			return DragAndDrop;
		}
		public function getRightText():String{
			return rightInputText;
		}
		public function setRightText(value:String):void{
			rightInputText = value;
		}
		public function getRegistr():Boolean{
			return registr;
		}
		public function getDefaultText():String{
			return defaultText;
		}
		public function getTextFormat():TextFormat{
			return textFormat;
		}
		public function get lastSpace():Boolean{
			return this.checkLastSpace;
		}
		public function getPojavl():Array{
			var arr:Array = new Array();
			arr.push(pojavl);
			arr.push(pojavl_block);
			arr.push(pojavl_show);
			return arr;
		}
		private function setPojavl(arr:Array):void{
			pojavl = arr[0];
			pojavl_block =arr[1];
			pojavl_show = arr[2];
		}
		public function getIschezn():Array{
			var arr:Array = new Array();
			arr.push(ischezn);
			arr.push(ischezn_block);
			arr.push(ischezn_show);
			arr.push(ischezn_timeShow);
			return arr;
		}
		private function setIschezn(arr:Array):void{
			ischezn = arr[0];
			ischezn_block =arr[1];
			ischezn_show = arr[2];
			ischezn_timeShow = arr[3];
		}
		private function FIELD_KEY_DOWN_ENTER(e:KeyboardEvent):void{
			if(e.keyCode==13){
				super.dispatchEvent(new Event(TAB_DOWN));
			}
		}
		public function get Multiline():Boolean{
			return field.multiline;
		}
		public function set ID(value:int):void{
			id = value;
		}
		public function get ID():int{
			return id;
		}
		public function get stand():Boolean{
			return this.colorStand;
		}
		public function set stand(value:Boolean):void{
			this.colorStand = value;
			if(value) {
				this.fieldSprite.mouseEnabled = false;
				if(isDropBack){
					this.fieldSprite.mouseEnabled = true;
					this.fieldSprite.addEventListener(MouseEvent.MOUSE_DOWN, COLOR_TAN_MOUSE_DOWN);
				}
			}
		}
		private function COLOR_TAN_MOUSE_DOWN(event:MouseEvent):void{
			this.fieldSprite.removeEventListener(MouseEvent.MOUSE_DOWN, COLOR_TAN_MOUSE_DOWN);
			this.colorStand = false;
			remBlackTan.free = true;
			remBlackTan = null;
		}
		public function get free():Boolean{
			return this.blackFree;
		}
		public function set free(value:Boolean):void{
			this.blackFree = value;
		}
		public function set dinamyc(value:Boolean):void{
			isDinamyc = value;
			if(value){
				this.colorStand = true;
				this.blackFree = false;
			}
		}
		public function get dinamyc():Boolean{
			return isDinamyc;
		}
		public function set startPosition(value:Boolean):void{
			isStartPosition = value;
		}
		public function get startPosition():Boolean{
			return isStartPosition;
		}
		public function StartPosition():void{
			if(startPosition){
				fieldSprite.x = field_X;
				fieldSprite.y = field_Y;
			}
		}
		public function set dropBack(value:Boolean):void{
			isDropBack = value;
		}
		public function get dropBack():Boolean{
			return isDropBack;
		}
		public function set recBlackTan(value:LabelClass):void{
			remBlackTan = value;
		}
		public function get text():String{
			return field.text;
		}
		public function set text(value:String):void{
			field.text = value;
		}
		public function get wField():Number{
			return this.fieldSprite.width;
		}
		public function get hField():Number{
			return this.fieldSprite.height;
		}
		public function inFocus():void{
			MainPlayer.STAGE.focus = field;
		}
		public function get animationColor():uint{
			return field.textColor;
		}
		public function set animationColor(value:uint):void{
			field.textColor = value;
		}
		
		//	Методы работы по формулам
		public function get variable():String{
			return this.labelVariable;
		}
		public function get random():String{
			return this.labelRandom;
		}
		public function get formula():String{
			return this.labelFormula;
		}
		public function get isRandom():Boolean{
			if(random=='') return false;
			return true;
		}
		/*
			ГРУППА МЕТОДОВ РАБОТЫ С АНИМАЦИЕЙ
		*/
		public function set listColorAnimation(value:XMLList):void{
			colorAnimation = new ObjectAnimation(new Sprite(), fieldSprite, this);
			colorAnimation.addEventListener(ObjectAnimation.END_ANIMATION, END_COLOR_ANIMATION);
			colorAnimation.listPosition = value;
		}
		public function set listBlackAnimation(value:XMLList):void{
			blackAnimation = new ObjectAnimation(new Sprite(), BlackTan);
			blackAnimation.addEventListener(ObjectAnimation.END_ANIMATION, END_BLACK_ANIMATION);
			blackAnimation.listPosition = value;
		}
		private function END_COLOR_ANIMATION(event:Event):void{
			colorAnimation.removeAnimation();
			colorAnimation = null;
		}
		private function END_BLACK_ANIMATION(event:Event):void{
			blackAnimation.removeAnimation();
			blackAnimation = null;
		}
		
		public function startLabelAnimation(value:String):void{
			if(colorAnimation != null){
				if(colorAnimation.label == value) {
					if(colorAnimation.address==0){
						colorAnimation.startAnimation();
					}else{
						colorAnimation.address = colorAnimation.address - 1;
					}
				}
			}
			if(blackAnimation != null){
				if(blackAnimation.label == value) {
					if(blackAnimation.address == 0){
						blackAnimation.startAnimation();
					}else{
						blackAnimation.address = blackAnimation.address - 1;
					}
				}
			}
		}
		
		
	}
}