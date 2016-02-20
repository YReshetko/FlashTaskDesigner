package source.Task.TaskObjects.UserButton {
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.text.TextFieldAutoSize;
	import source.utils.Figure;
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.events.MouseEvent;
	import source.DesignerMain;
	import flash.events.Event;
	import flash.filters.BlurFilter;
	import flash.geom.Point;
	import flash.filters.GlowFilter;
	import source.Task.Animation.ObjectAnimation;
	import source.Task.TaskSystem;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	public class OneUserButton extends Sprite{
		public static var GET_SETTINGS:String = 'onGetSettings';
		public static var COPY_OBJECT:String = 'onCopyObject';
		public static var REMOVE_OBJECT:String = 'onRemoveObject';
		
		private var outBitmap:Bitmap;
		private var overBitmap:Bitmap;
		private var downBitmap:Bitmap;
		
		private var outColor:uint = 0xBEBEBE;
		private var overColor:uint = 0xACACAC;
		private var downColor:uint = 0x9B9B9B;
		
		private var fieldColor:uint = 0x000000;
		private var fieldSize:int = 14;
		
		private var lineAlpha:Number = 1;
		private var lineColor:uint = 0x696969;
		private var lineThick:Number = 1;
		private var fillAlpha:Number = 1;
		
		private var field:TextField;
		private var ID:int;
		private var buttonWidth:Number;
		private var buttonHeight:Number;
		private var xmlButton:XMLList;
		private var alignCenter:Boolean = true;
		
		//	Настройка фильтра размытия
		private var isBlur:Boolean = false;
		private var xBlur:Number = 4;
		private var yBlur:Number = 4;
		private var qBlur:Number = 1;
		//	Настройки фильтра свечения
		private var isGlow:Boolean = false;
		private var glowColor:uint = 0xFF00FF;
		private var glowAlpha:Number = 1;
		private var xGlow:Number = 6;
		private var yGlow:Number = 6;
		private var sGlow:Number = 2;
		private var qGlow:Number = 1;
		private var knockoutGlow:Boolean = false;
		
		private var objectAnimation:ObjectAnimation;
		public function OneUserButton(xml:XMLList, id:int, container:Sprite) {
			super();
			container.addChild(super);
			ID = id;
			objectAnimation = TaskSystem.animationController.getAnimation(super);
			initDefaultButton();
			if(xml!=null) setSettingsButton(xml);	
		}
		//	Инициализации кнопки по умолчанию
		private function initDefaultButton():void{
			field = new TextField();
			var format:TextFormat = new TextFormat();
			format.color = fieldColor;
			format.size = fieldSize;
			format.align = TextFormatAlign.LEFT;
			field.defaultTextFormat = format;
			field.autoSize = TextFieldAutoSize.LEFT;
			field.border = false;
			//field.borderColor = 0xFF0000;
			field.background = false;
			field.mouseEnabled = false;
			field.text = 'Кнопка ' + ID.toString();
			buttonWidth = field.width;
			buttonHeight = field.height;
			xmlButton = getDefaultXMLButton(field.width, field.height);
			drawOutForm(outColor);
			drawOverForm(overColor);
			drawDownForm(downColor);
			super.addChild(outBitmap);
			super.addChild(overBitmap);
			super.addChild(downBitmap);
			super.addChild(field);
			field.x = (super.width - field.width)/2;
			field.y = (super.height - field.height)/2;
			super.addEventListener(MouseEvent.MOUSE_OUT, BUTTON_MOUSE_OUT);
			super.addEventListener(MouseEvent.MOUSE_OVER, BUTTON_MOUSE_OVER);
			super.addEventListener(MouseEvent.MOUSE_DOWN, BUTTON_MOUSE_DOWN);
			super.addEventListener(KeyboardEvent.KEY_DOWN, BUTTON_KEY_DOWN);
			//super.addEventListener(MouseEvent.MOUSE_UP, BUTTON_MOUSE_OVER);
			BUTTON_MOUSE_OUT();
		}
		private function setSettingsButton(xml:XMLList):void{
			super.x = parseFloat(xml.@x);
			super.y = parseFloat(xml.@y);
			this.width = parseFloat(xml.@width);
			this.height = parseFloat(xml.@height);
			
			if(xml.COLOR.@out.toString()!='') this.colorOut = xml.COLOR.@out;
			if(xml.COLOR.@over.toString()!='') this.colorOver = xml.COLOR.@over;
			if(xml.COLOR.@down.toString()!='') this.colorDown = xml.COLOR.@down;
			
			if(xml.TEXT.toString()!=''){
				this.label = xml.TEXT.toString();
				this.alignCenter = xml.TEXT.@align.toString() == 'true';
				this.size = xml.TEXT.@size;
				this.bold = xml.TEXT.@bold.toString() == 'true';
				this.italic = xml.TEXT.@italic.toString() == 'true';
			}
			if(xml.BLUR.@x.toString()!=''){
				this.blurX = xml.BLUR.@x;
				this.blurY = xml.BLUR.@y;
				this.blurQ = xml.BLUR.@q;
				this.blur = true;
			}
			if(xml.GLOW.@alpha.toString()!=''){
				this.glowA = xml.GLOW.@alpha;
				this.glowX = xml.GLOW.@x;
				this.glowY = xml.GLOW.@y;
				this.glowS = xml.GLOW.@s;
				this.glowQ = xml.GLOW.@q;
				this.knockoutGlow = xml.GLOW.@knockout.toString()=='true';
				this.gColor = xml.GLOW.@color;
				this.glow = true;
			}
			if(xml.ANIMATION.@step.toString()!=''){
				this.objectAnimation.listPosition = xml.ANIMATION;
			}
		}
		//	Вывод XML листа кнопки по ширине и высоте
		private function getDefaultXMLButton(w:Number, h:Number):XMLList{
			var outXml:XMLList = new XMLList('<POINTS/>');
			outXml.appendChild(new XMLList('<POINT id="0" x="0" y="0"/>'));
			outXml.appendChild(new XMLList('<POINT id="1" x="'+w.toString()+'" y="0"/>'));
			outXml.appendChild(new XMLList('<POINT id="2" x="'+w.toString()+'" y="'+h.toString()+'"/>'));
			outXml.appendChild(new XMLList('<POINT id="3" x="0" y="'+h.toString()+'"/>'));
			outXml.appendChild(new XMLList('<POINT id="4" x="0" y="0"/>'));
			return outXml;
		}
		//	Отрисовка битмапы для мышки вне кнопки
		private function drawOutForm(color:uint):void{
			if(outBitmap!=null){
				if(super.contains(outBitmap)) super.removeChild(outBitmap);
				outBitmap = null;
			}
			var container:Sprite = new Sprite();
			var curveArr:Array = new Array();
			for each(var xml:XML in xmlButton.POINT){
				curveArr.push([parseFloat(xml.@x.toString()), parseFloat(xml.@y.toString())]);
			}
			Figure.insertCurve(container, curveArr, lineAlpha, lineThick, lineColor, fillAlpha, color);
			var bitmapData:BitmapData = new BitmapData(container.width, container.height, true, 0x00000000);
			bitmapData.draw(container, new Matrix());
			outBitmap = new Bitmap(bitmapData);
		}
		//	Отрисовка битмапы для мышки над кнопкой
		private function drawOverForm(color:uint):void{
			if(overBitmap!=null){
				if(super.contains(overBitmap)) super.removeChild(overBitmap);
				overBitmap = null;
			}
			var container:Sprite = new Sprite();
			var curveArr:Array = new Array();
			for each(var xml:XML in xmlButton.POINT){
				curveArr.push([parseFloat(xml.@x.toString()), parseFloat(xml.@y.toString())]);
			}
			Figure.insertCurve(container, curveArr, lineAlpha, lineThick, lineColor, fillAlpha, color);
			var bitmapData:BitmapData = new BitmapData(container.width, container.height, true, 0x00000000);
			bitmapData.draw(container, new Matrix());
			overBitmap = new Bitmap(bitmapData);
		}
		//	Отрисовка битмапы для мышки при нажатии на кнопку
		private function drawDownForm(color:uint):void{
			if(downBitmap!=null){
				if(super.contains(downBitmap)) super.removeChild(downBitmap);
				downBitmap = null;
			}
			var container:Sprite = new Sprite();
			var curveArr:Array = new Array();
			for each(var xml:XML in xmlButton.POINT){
				curveArr.push([parseFloat(xml.@x.toString()), parseFloat(xml.@y.toString())]);
			}
			Figure.insertCurve(container, curveArr, lineAlpha, lineThick, lineColor, fillAlpha, color);
			var bitmapData:BitmapData = new BitmapData(container.width, container.height, true, 0x00000000);
			bitmapData.draw(container, new Matrix());
			downBitmap = new Bitmap(bitmapData);
		}
		//	Переключение вида кнопки когда мышь вне кнопки
		private function BUTTON_MOUSE_OUT(event:MouseEvent = null):void{
			if(outBitmap != null) if(super.contains(outBitmap)) outBitmap.visible = true;
			if(overBitmap != null) if(super.contains(overBitmap)) overBitmap.visible = false;
			if(downBitmap != null) if(super.contains(downBitmap)) downBitmap.visible = false;
			super.setChildIndex(field, super.numChildren-1);
		}
		//	Переключение вида кнопки когда мышь над кнопкой
		private function BUTTON_MOUSE_OVER(event:MouseEvent = null):void{
			if(outBitmap != null) if(super.contains(outBitmap)) outBitmap.visible = false;
			if(overBitmap != null) if(super.contains(overBitmap)) overBitmap.visible = true;
			if(downBitmap != null) if(super.contains(downBitmap)) downBitmap.visible = false;
			super.setChildIndex(field, super.numChildren-1);
		}
		//	Переключение вида кнопки когда мышь нажата над кнопкой
		private function BUTTON_MOUSE_DOWN(event:MouseEvent = null):void{
			if(outBitmap != null) if(super.contains(outBitmap)) outBitmap.visible = false;
			if(overBitmap != null) if(super.contains(overBitmap)) overBitmap.visible = false;
			if(downBitmap != null) if(super.contains(downBitmap)) downBitmap.visible = true;
			super.setChildIndex(field, super.numChildren-1);
			DesignerMain.STAGE.addEventListener(MouseEvent.MOUSE_UP, BUTTON_MOUSE_UP);
			DesignerMain.STAGE.addEventListener(MouseEvent.MOUSE_MOVE, BUTTON_MOUSE_MOVE);
			
			super.dispatchEvent(new Event(GET_SETTINGS));
		}
		//	Начало перемещения кнопки
		private function BUTTON_MOUSE_MOVE(event:MouseEvent):void{
			DesignerMain.STAGE.addEventListener(MouseEvent.MOUSE_UP, BUTTON_MOUSE_UP);
			DesignerMain.STAGE.removeEventListener(MouseEvent.MOUSE_MOVE, BUTTON_MOUSE_MOVE);
			super.startDrag();
		}
		//	Остановка перемещения кнопки
		private function BUTTON_MOUSE_UP(event:MouseEvent):void{
			DesignerMain.STAGE.removeEventListener(MouseEvent.MOUSE_UP, BUTTON_MOUSE_UP);
			DesignerMain.STAGE.removeEventListener(MouseEvent.MOUSE_MOVE, BUTTON_MOUSE_MOVE);
			BUTTON_MOUSE_OVER();
			super.stopDrag();
		}
		
		private function BUTTON_KEY_DOWN(event:KeyboardEvent):void{
			switch(event.keyCode){
				case Keyboard.DELETE:
					super.dispatchEvent(new Event(REMOVE_OBJECT));
				break;
				case Keyboard.C:
					if(event.ctrlKey) super.dispatchEvent(new Event(COPY_OBJECT));
				break;
				case Keyboard.W:
					super.y = super.y - 1;
				break;
				case Keyboard.A:
					super.x = super.x - 1;
				break;
				case Keyboard.S:
					super.y = super.y + 1;
				break;
				case Keyboard.D:
					super.x = super.x + 1;
				break;
			}
		}
		/*
			Методы настройки кнопки
		*/
		override public function set width(value:Number):void{
			buttonWidth = value;
			redrawForm();
			
		}
		override public function get width():Number{
			return buttonWidth;
		}
		override public function set height(value:Number):void{
			buttonHeight = value;
			redrawForm();
		}
		override public function get height():Number{
			return buttonHeight;
		}
		//	Перерисовка форм кнопок
		private function redrawForm():void{
			xmlButton = getDefaultXMLButton(buttonWidth, buttonHeight);
			drawOutForm(outColor);
			drawOverForm(overColor);
			drawDownForm(downColor);
			super.addChild(outBitmap);
			super.addChild(overBitmap);
			super.addChild(downBitmap);
			super.setChildIndex(field, super.numChildren-1);
			textAlign = alignCenter;
			BUTTON_MOUSE_OUT();
			if(isGlow) glow = isGlow;
			if(isBlur) blur = isBlur;
		}
		
		public function set label(value:String):void{
			field.text = value;
			if(field.width>outBitmap.width) {
				buttonWidth = field.width;
				redrawForm();
			}
			if(field.height>outBitmap.height) {
				buttonHeight = field.height;
				redrawForm();
			}
			textAlign = alignCenter;
		}
		public function get label():String{
			return field.text;
		}
		public function get textAlign():Boolean{
			return alignCenter;
		}
		public function set textAlign(value:Boolean):void{
			alignCenter = value;
			if(alignCenter){
				field.x = (super.width - field.width)/2;
				field.y = (super.height - field.height)/2;
			}else{
				field.x = 0;
				field.y = (super.height - field.height)/2;
			}
		}
		
		
		public function set colorOut(value:uint):void{
			outColor = value;
			redrawForm();
		}
		public function get colorOut():uint{
			return outColor;
		}
		
		public function set colorOver(value:uint):void{
			overColor = value;
			redrawForm();
		}
		public function get colorOver():uint{
			return overColor;
		}
		public function set colorDown(value:uint):void{
			downColor = value;
			redrawForm();
		}
		public function get colorDown():uint{
			return downColor;
		}
		
		
		public function get blur():Boolean{
			return isBlur;
		}
		public function set blur(value:Boolean):void{
			isBlur = value;
			if(isBlur){
				var blurFilter:BlurFilter = new BlurFilter(xBlur, yBlur, qBlur);
				outBitmap.bitmapData.applyFilter(outBitmap.bitmapData, outBitmap.bitmapData.rect, new Point(), blurFilter);
				overBitmap.bitmapData.applyFilter(overBitmap.bitmapData, overBitmap.bitmapData.rect, new Point(), blurFilter);
				downBitmap.bitmapData.applyFilter(downBitmap.bitmapData, downBitmap.bitmapData.rect, new Point(), blurFilter);
				
			}else{
				redrawForm();
			}
		}
		public function set blurX(value:Number):void{
			xBlur = value;
			redrawForm();
		}
		public function get blurX():Number{
			return xBlur;
		}
		public function set blurY(value:Number):void{
			yBlur = value;
			redrawForm();
		}
		public function get blurY():Number{
			return yBlur;
		}
		public function set blurQ(value:Number):void{
			qBlur = value;
			redrawForm();
		}
		public function get blurQ():Number{
			return qBlur;
		}
		
		
		
		public function set glow(value:Boolean):void{
			isGlow = value;
			if(isGlow){
				var glowFilter:GlowFilter = new GlowFilter(glowColor, glowAlpha, xGlow, yGlow, sGlow, qGlow, true, knockoutGlow);
				outBitmap.bitmapData.applyFilter(outBitmap.bitmapData, outBitmap.bitmapData.rect, new Point(), glowFilter);
				overBitmap.bitmapData.applyFilter(overBitmap.bitmapData, overBitmap.bitmapData.rect, new Point(), glowFilter);
				downBitmap.bitmapData.applyFilter(downBitmap.bitmapData, downBitmap.bitmapData.rect, new Point(), glowFilter);
			}else{
				redrawForm();
			}
		}
		public function get glow():Boolean{
			return isGlow;
		}
		public function set gColor(value:uint):void{
			glowColor = value;
			redrawForm();
		}
		public function get gColor():uint{
			return glowColor;
		}
		
		public function set glowA(value:Number):void{
			glowAlpha = value;
			redrawForm();
		}
		public function get glowA():Number{
			return glowAlpha;
		}
		public function set glowX(value:Number):void{
			xGlow = value;
			redrawForm();
		}
		public function get glowX():Number{
			return xGlow;
		}
		public function set glowY(value:Number):void{
			yGlow = value;
			redrawForm();
		}
		public function get glowY():Number{
			return yGlow;
		}
		public function set glowS(value:Number):void{
			sGlow = value;
			redrawForm();
		}
		public function get glowS():Number{
			return sGlow;
		}
		public function set glowQ(value:Number):void{
			qGlow = value;
			redrawForm();
		}
		public function get glowQ():Number{
			return qGlow;
		}
		public function set glowKnockout(value:Boolean):void{
			knockoutGlow = value;
			redrawForm();
		}
		public function get glowKnockout():Boolean{
			return knockoutGlow;
		}
		public function set size(value:Number):void{
			var format:TextFormat = field.getTextFormat();
			format.size = value;
			field.setTextFormat(format);
			field.defaultTextFormat = format;
			label = field.text;
			redrawForm();
		}
		public function get size():Number{
			return field.getTextFormat().size as Number;
		}
		public function set bold(value:Boolean):void{
			var format:TextFormat = field.getTextFormat();
			format.bold = value;
			field.setTextFormat(format);
			field.defaultTextFormat = format;
			label = field.text;
			redrawForm();
		}
		public function get bold():Boolean{
			return field.getTextFormat().bold as Boolean;
		}
		public function set italic(value:Boolean):void{
			var format:TextFormat = field.getTextFormat();
			format.italic = value;
			field.setTextFormat(format);
			field.defaultTextFormat = format;
			label = field.text;
			redrawForm();
		}
		public function get italic():Boolean{
			return field.getTextFormat().italic as Boolean;
		}
		
		
		public function get animationButton():ObjectAnimation{
			return this.objectAnimation;
		}
		public function get listSettings():XMLList{
			var outXml:XMLList = new XMLList('<PACKAGE/>');
			outXml.@label = 'КНОПКА';
			var widthList:XMLList = new XMLList('<FIELD label="ширина" type="number" variable="width" width="40">' + this.width.toString() + '</FIELD>');
			var heightList:XMLList = new XMLList('<FIELD label="высота" type="number" variable="height" width="40">' + this.height.toString() + '</FIELD>');
			var blockList:XMLList = new XMLList('<BLOCK label="размер"/>');
			blockList.appendChild(widthList);
			blockList.appendChild(heightList);
			outXml.appendChild(blockList);
			var labelList:XMLList = new XMLList('<FIELD label=" текст" type="string" multiline="true" variable="label" width="200">' + this.label + '</FIELD>');
			var alignList:XMLList = new XMLList('<MARK label="по центру" variable="textAlign">'+this.textAlign.toString()+'</MARK>');
			var sizeList:XMLList = new XMLList('<FIELD label="размер" type="string" variable="size" width="40">' + this.size.toString() + '</FIELD>');
			var boldList:XMLList = new XMLList('<MARK label="жирный" variable="bold">'+this.bold.toString()+'</MARK>');
			var italicList:XMLList = new XMLList('<MARK label="наклонный" variable="italic">'+this.italic.toString()+'</MARK>');
			blockList = new XMLList('<BLOCK label="подпись"/>');
			blockList.appendChild(labelList);
			blockList.appendChild(alignList);
			blockList.appendChild(sizeList);
			blockList.appendChild(boldList);
			blockList.appendChild(italicList);
			outXml.appendChild(blockList);
			var blurList:XMLList = new XMLList('<MARK label="применить" variable="blur">'+this.blur.toString()+'</MARK>');
			var xBlurList:XMLList = new XMLList('<FIELD label="X" type="number" variable="blurX" width="40">' + this.blurX.toString() + '</FIELD>');
			var yBlurList:XMLList = new XMLList('<FIELD label="Y" type="number" variable="blurY" width="40">' + this.blurY.toString() + '</FIELD>');
			var qBlurList:XMLList = new XMLList('<FIELD label="Q" type="number" variable="blurQ" width="40">' + this.blurQ.toString() + '</FIELD>');
			blockList = new XMLList('<BLOCK label="фильтр размытия"/>');
			blockList.appendChild(blurList);
			blockList.appendChild(xBlurList);
			blockList.appendChild(yBlurList);
			blockList.appendChild(qBlurList);
			outXml.appendChild(blockList);
			var glowList:XMLList = new XMLList('<MARK label="применить" variable="glow">'+this.glow.toString()+'</MARK>');
			var aGlowList:XMLList = new XMLList('<FIELD label="прозрачность" type="number" variable="glowA" width="40">' + this.glowA.toString() + '</FIELD>');
			var xGlowList:XMLList = new XMLList('<FIELD label="X" type="number" variable="glowX" width="40">' + this.glowX.toString() + '</FIELD>');
			var yGlowList:XMLList = new XMLList('<FIELD label="Y" type="number" variable="glowY" width="40">' + this.glowY.toString() + '</FIELD>');
			var sGlowList:XMLList = new XMLList('<FIELD label="S" type="number" variable="glowS" width="40">' + this.glowS.toString() + '</FIELD>');
			var qGlowList:XMLList = new XMLList('<FIELD label="Q" type="number" variable="glowQ" width="40">' + this.glowQ.toString() + '</FIELD>');
			var knockOutList:XMLList = new XMLList('<MARK label="прозрачность внутренности" variable="glowKnockout">'+this.glowKnockout.toString()+'</MARK>');
			blockList = new XMLList('<BLOCK label="фильтр свечения"/>');
			blockList.appendChild(glowList);
			blockList.appendChild(aGlowList);
			blockList.appendChild(xGlowList);
			blockList.appendChild(yGlowList);
			blockList.appendChild(sGlowList);
			blockList.appendChild(qGlowList);
			blockList.appendChild(knockOutList);
			outXml.appendChild(blockList);
			var animationListXML:XMLList = new XMLList('<ANIMATION variable="animationButton"/>');
			blockList = new XMLList('<BLOCK label="Анимация"/>');
			blockList.appendChild(animationListXML);
			outXml.appendChild(blockList);
			return outXml;
		}
		public function get colorSettings():XMLList{
			var outXml:XMLList = new XMLList('<PACKAGE/>');
			outXml.appendChild(new XML('<COLOR label="out" variable="colorOut">' + this.colorOut.toString() + '</COLOR>'));
			outXml.appendChild(new XML('<COLOR label="over" variable="colorOver">' + this.colorOver.toString() + '</COLOR>'));
			outXml.appendChild(new XML('<COLOR label="down" variable="colorDown">' + this.colorDown.toString() + '</COLOR>'));
			outXml.appendChild(new XML('<COLOR label="glow" variable="gColor">' + this.gColor.toString() + '</COLOR>'));
			return outXml;
		}
		
		
		public function get listPosition():XMLList{
			var outXml:XMLList = new XMLList('<BUTTON/>');
			outXml.@x = super.x;
			outXml.@y = super.y;
			outXml.@width = this.width;
			outXml.@height = this.height;
			var colorList:XMLList = new XMLList('<COLOR/>');
			colorList.@out = this.colorOut;
			colorList.@over = this.colorOver;
			colorList.@down = this.colorDown;
			outXml.appendChild(colorList);
			outXml.appendChild(new XML('<TEXT><![CDATA['+this.label+']]></TEXT>'));
			outXml.TEXT.@align = this.alignCenter.toString()
			outXml.TEXT.@size = this.size.toString();
			outXml.TEXT.@bold = this.bold.toString();
			outXml.TEXT.@italic = this.italic.toString();
			if(this.blur){
				outXml.BLUR.@x = this.blurX.toString();
				outXml.BLUR.@y = this.blurY.toString();
				outXml.BLUR.@q = this.blurQ.toString();
			}
			if(this.glow){
				outXml.GLOW.@alpha = this.glowA.toString();
				outXml.GLOW.@x = this.glowX.toString();
				outXml.GLOW.@y = this.glowY.toString();
				outXml.GLOW.@s = this.glowS.toString();
				outXml.GLOW.@q = this.glowQ.toString();
				outXml.GLOW.@knockout = this.knockoutGlow.toString();
				outXml.GLOW.@color = this.gColor;
			}
			if(this.objectAnimation.hasAnimation){
				outXml.appendChild(this.objectAnimation.listPosition);
			}
			return outXml;
		}
	}
	
}
