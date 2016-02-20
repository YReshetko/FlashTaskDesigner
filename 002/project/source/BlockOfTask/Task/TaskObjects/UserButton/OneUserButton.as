package source.BlockOfTask.Task.TaskObjects.UserButton {
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
	import source.MainPlayer;
	import flash.events.Event;
	import flash.filters.BlurFilter;
	import flash.geom.Point;
	import flash.filters.GlowFilter;
	import source.BlockOfTask.Task.Animation.ObjectAnimation;
	
	public class OneUserButton extends Sprite{
		public static var GET_SETTINGS:String = 'onGetSettings';
		
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
			objectAnimation = new ObjectAnimation(container, super);
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
			MainPlayer.STAGE.addEventListener(MouseEvent.MOUSE_UP, BUTTON_MOUSE_UP);
		}
		//	Остановка перемещения кнопки
		private function BUTTON_MOUSE_UP(event:MouseEvent):void{
			MainPlayer.STAGE.removeEventListener(MouseEvent.MOUSE_UP, BUTTON_MOUSE_UP);
			BUTTON_MOUSE_OVER();
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
		public function set colorOver(value:uint):void{
			overColor = value;
			redrawForm();
		}
		public function set colorDown(value:uint):void{
			downColor = value;
			redrawForm();
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
		public function set blurY(value:Number):void{
			yBlur = value;
			redrawForm();
		}
		public function set blurQ(value:Number):void{
			qBlur = value;
			redrawForm();
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
		public function set gColor(value:uint):void{
			glowColor = value;
			redrawForm();
		}
		public function set glowA(value:Number):void{
			glowAlpha = value;
			redrawForm();
		}
		public function set glowX(value:Number):void{
			xGlow = value;
			redrawForm();
		}
		public function set glowY(value:Number):void{
			yGlow = value;
			redrawForm();
		}
		public function set glowS(value:Number):void{
			sGlow = value;
			redrawForm();
		}
		public function set glowQ(value:Number):void{
			qGlow = value;
			redrawForm();
		}
		public function set glowKnockout(value:Boolean):void{
			knockoutGlow = value;
			redrawForm();
		}
		public function set size(value:Number):void{
			var format:TextFormat = field.getTextFormat();
			format.size = value;
			field.setTextFormat(format);
			field.defaultTextFormat = format;
			label = field.text;
			redrawForm();
		}
		public function set bold(value:Boolean):void{
			var format:TextFormat = field.getTextFormat();
			format.bold = value;
			field.setTextFormat(format);
			field.defaultTextFormat = format;
			label = field.text;
			redrawForm();
		}
		public function set italic(value:Boolean):void{
			var format:TextFormat = field.getTextFormat();
			format.italic = value;
			field.setTextFormat(format);
			field.defaultTextFormat = format;
			label = field.text;
			redrawForm();
		}
		
		public function startLabelAnimation(value:String):void{
			if(this.objectAnimation != null){
				if(this.objectAnimation.label == value) {
					if(this.objectAnimation.address==0){
						this.objectAnimation.startAnimation();
					}else{
						this.objectAnimation.address = this.objectAnimation.address - 1;
					}
				}
			}
		}
	}
	
}
