package source.Task.TaskObjects.ShiftField {
	import flash.display.Sprite;
	import source.utils.Figure;
	import flash.events.MouseEvent;
	import source.DesignerMain;
	import flash.events.Event;
	
	public class OneShiftField extends Sprite{
		public static var GET_SETTINGS:String = 'onGetSettings';
		private var numLine:int = 1;
		private var numColumn:int = 1;
		private var deltaX:Number = 3;
		private var deltaY:Number = 3;
		
		private var wField:Number = 100;
		private var hField:Number = 100;
		
		private var arrFields:Array = new Array();
		private var background:Sprite = new Sprite();
		
		private var wButton:Number;
		
		private var rightButtons:ButtonForField = new ButtonForField('right');
		private var bottomButtons:ButtonForField = new ButtonForField('bottom');
		
		private var columnReplace:String = '';
		private var lineReplace:String = '';
		private var fullReplace:Boolean = false;
		
		private var replaceWithEmptyField:Boolean = false;
		
		private var rightButton:Boolean = false;
		private var bottomButton:Boolean = false;
		public function OneShiftField(value:Sprite, xml:XMLList = null) {
			super();
			super.addChild(background);
			wButton = bottomButtons.width;
			initListeners();
			value.addChild(super);
			settings = xml;
		}
		private function initListeners():void{
			background.addEventListener(MouseEvent.MOUSE_DOWN, FIELD_MOUSE_DOWN);
			//rightButtons.addEventListener(ButtonForField.REPLACE_BOTTOM, REPLACE_BOTTOM);
			//rightButtons.addEventListener(ButtonForField.REPLACE_TOP, REPLACE_TOP);
			
			//bottomButtons.addEventListener(ButtonForField.REPLACE_LEFT, REPLACE_LEFT);
			//bottomButtons.addEventListener(ButtonForField.REPLACE_RIGHT, REPLACE_RIGHT);
		}
		public function set settings(xml:XMLList):void{
			if(xml.@x.toString()!='') super.x = parseFloat(xml.@x.toString());
			if(xml.@y.toString()!='') super.y = parseFloat(xml.@y.toString());
			if(xml.@width.toString()!='') wField = parseFloat(xml.@width.toString());
			if(xml.@height.toString()!='') hField = parseFloat(xml.@height.toString());
			
			if(xml.NUMLINE.toString()!='') numLine = parseInt(xml.NUMLINE.toString());
			if(xml.NUMCOLUMN.toString()!='') numColumn = parseInt(xml.NUMCOLUMN.toString());
			
			if(xml.RIGHTBUTTON.toString()) this.rightButton = xml.RIGHTBUTTON.toString() == 'true';
			if(xml.BOTTOMBUTTON.toString()) this.bottomButton = xml.BOTTOMBUTTON.toString() == 'true';
			
			if(xml.COLUMNREPLACE.toString()!='') this.cReplace = xml.COLUMNREPLACE.toString();
			if(xml.LINEREPLACE.toString()!='') this.lReplace = xml.LINEREPLACE.toString();
			fReplace = xml.FULLREPLACE.toString() == 'true';
			emptyField = xml.EMPTYFIELD.toString() == 'true';
			drawField();
			
			for each(var sample:XML in xml.FIELD){
				if(sample.USERTAN.toString()!='') (arrFields[parseInt(sample.@i)][parseInt(sample.@j)] as OneMaskField).xml(new XMLList(sample.USERTAN.toString()));
				if(sample.LABEL.toString()!='')  (arrFields[parseInt(sample.@i)][parseInt(sample.@j)] as OneMaskField).xml(new XMLList(sample.LABEL.toString()));
			}
		}
		private function drawField():void{
			clearField();
			super.graphics.clear();
			Figure.insertRect(background, wField, hField, 1, 1, 0x4B4B4B);
			var i:int;
			var j:int;
			var w:Number;
			var h:Number;
			var decX:Number = 0;
			var decY:Number = 0;
			if(rightButton) decX = 25;
			if(bottomButton) decY = 25;
			w = (wField - decX - (deltaX * (numColumn+1)))/numColumn;
			h = (hField - decY - (deltaY * (numLine+1)))/numLine;
			for(i=0;i<numLine;i++){
				arrFields.push(new Array());
				for(j=0;j<numColumn;j++){
					if(arrFields[i][j] == null || arrFields[i][j] == undefined) arrFields[i][j] = new OneMaskField();
					super.addChild(arrFields[i][j] as OneMaskField);
					(arrFields[i][j] as OneMaskField).width = w;
					(arrFields[i][j] as OneMaskField).height = h;
					(arrFields[i][j] as OneMaskField).x = deltaX*(j + 1) + j*w;
					(arrFields[i][j] as OneMaskField).y = deltaY*(i + 1) + i*h;
				}
			}
			if(rightButton){
				super.addChild(rightButtons);
				rightButtons.x = this.wField - 12.5;
				rightButtons.y = (this.hField-25)/2 + 2;
				if(rightButtons.width > hField-30){
					rightButtons.width = hField-30;
				}
				rightButtons.rotation = -90;
			}
			if(bottomButton){
				super.addChild(bottomButtons);
				bottomButtons.y = this.hField - 12.5;
				bottomButtons.x = (this.wField-25)/2 + 2;
				if(bottomButtons.width > wField-30){
					bottomButtons.width = wField-30;
				}
			}
		}
		private function clearField():void{
			/*var i,j,l:int;
			if(arrFields.length!=0) l = arrFields[0].length;
			
			for(i=0;i<arrFields.length;i++){
				for(j=0;j<l;j++){
					if(super.contains(arrFields[i][j] as OneMaskField)) super.removeChild(arrFields[i][j] as OneMaskField);
				}
			}*/
			/*while(arrFields.length>0){
				while((arrFields[0] as Array).length>0){
					if(super.contains(arrFields[0][0] as OneMaskField)) super.removeChild(arrFields[0][0] as OneMaskField);
					(arrFields[0] as Array).shift();
				}
				arrFields.shift();
			}*/
			while(super.numChildren!=1){
				super.removeChild(super.getChildAt(1));
			}
			if(super.contains(rightButtons)){
				rightButtons.rotation = 0;
				rightButtons.width = wButton;
			}
			if(super.contains(bottomButtons)){
				bottomButtons.width = wButton;
			}
		}
		private function FIELD_MOUSE_DOWN(event:MouseEvent):void{
			DesignerMain.STAGE.addEventListener(MouseEvent.MOUSE_UP, FIELD_MOUSE_UP);
			super.dispatchEvent(new Event(GET_SETTINGS));
			super.startDrag();
		}
		private function FIELD_MOUSE_UP(event:MouseEvent):void{
			DesignerMain.STAGE.removeEventListener(MouseEvent.MOUSE_UP, FIELD_MOUSE_UP);
			super.stopDrag();
		}
		public function set child(value:*):void{
			var remSprite:Sprite = value.tanColor;
			var i:int;
			var j:int;
			var inXml:XMLList;
			var content:*;
			var name:String;
			for(i=0;i<numLine;i++){
				for(j=0;j<numColumn;j++){
					if(remSprite.hitTestObject(arrFields[i][j] as OneMaskField)){
						inXml = value.listPosition;
						content = value.content;
						name = value.fileName;
						switch (inXml.name().toString()){
							case 'PICTURETAN':
							case 'USERTAN':
								inXml.BLACK.X = inXml.COLOR.X = parseFloat(inXml.WIDTH)/2;
								inXml.BLACK.Y = inXml.COLOR.Y = parseFloat(inXml.HEIGHT)/2;
							break;
							case 'LABEL':
								inXml.X = 0;
								inXml.Y = 0;
							break;
						}
						
						(arrFields[i][j] as OneMaskField).xml(inXml, content, name);
						value.removeTan();
						return;
					}
				}
			}
		}
		override public function set width(value:Number):void{
			this.wField = value;
			drawField();
		}
		override public function get width():Number{
			return this.wField;
		}
		override public function set height(value:Number):void{
			this.hField = value;
			drawField();
		}
		override public function get height():Number{
			return this.hField;
		}
		public function set lines(value:int):void{
			this.numLine = value;
			drawField();
		}
		public function get lines():int{
			return this.numLine;
		}
		public function set columns(value:int):void{
			this.numColumn = value;
			drawField();
		}
		public function get columns():int{
			return this.numColumn;
		}
		public function set cReplace(value:String):void{
			columnReplace = value;
		}
		public function set lReplace(value:String):void{
			lineReplace = value;
		}
		public function get cReplace():String{
			return columnReplace;
		}
		public function get lReplace():String{
			return lineReplace;
		}
		public function set fReplace(value:Boolean):void{
			fullReplace = value;
		}
		public function get fReplace():Boolean{
			return fullReplace;
		}
		public function set rightPanel(value:Boolean):void{
			this.rightButton = value;
			drawField();
		}
		public function get rightPanel():Boolean{
			return this.rightButton;
		}
		public function set bottomPanel(value:Boolean):void{
			this.bottomButton = value;
			drawField();
		}
		public function get bottomPanel():Boolean{
			return this.bottomButton;
		}
		
		public function set emptyField(value:Boolean):void{
			replaceWithEmptyField = value;
		}
		public function get emptyField():Boolean{
			return replaceWithEmptyField;
		}
		public function get listSettings():XMLList{
			var outXml:XMLList = new XMLList('<PACKAGE/>');
			outXml.@label = 'ПОЛЕ ПЕРЕСТАНОВКИ';
			var widthList:XMLList = new XMLList('<FIELD label="ширина" type="number" variable="width" width="40">' + this.width.toString() + '</FIELD>');
			var heightList:XMLList = new XMLList('<FIELD label="высота" type="number" variable="height" width="40">' + this.height.toString() + '</FIELD>');
			var blockList:XMLList = new XMLList('<BLOCK label="размер"/>');
			blockList.appendChild(widthList);
			blockList.appendChild(heightList);
			outXml.appendChild(blockList);
			
			var linesList:XMLList = new XMLList('<FIELD label="число строк" type="number" variable="lines" width="40">' + this.lines.toString() + '</FIELD>');
			var columnsList:XMLList = new XMLList('<FIELD label="число столбцов" type="number" variable="columns" width="40">' + this.columns.toString() + '</FIELD>');
			blockList = new XMLList('<BLOCK label="ячейки"/>');
			blockList.appendChild(linesList);
			blockList.appendChild(columnsList);
			outXml.appendChild(blockList);
			
			var columnReplaceList:XMLList = new XMLList('<FIELD label="строк" type="string" variable="lReplace" width="200">' + this.lReplace + '</FIELD>');
			var lineReplaceList:XMLList = new XMLList('<FIELD label="столбцов" type="string" variable="cReplace" width="200">' + this.cReplace + '</FIELD>');
			var fullReplaceList:XMLList = new XMLList('<MARK label="все ячейки" variable="fReplace">'+this.fReplace.toString()+'</MARK>');
			var emptyFieldList:XMLList = new XMLList('<MARK label="только с пустым полем" variable="emptyField">'+this.emptyField.toString()+'</MARK>');
			
			
			blockList = new XMLList('<BLOCK label="перестановки"/>');
			blockList.appendChild(fullReplaceList);
			blockList.appendChild(columnReplaceList);
			blockList.appendChild(lineReplaceList);
			blockList.appendChild(emptyFieldList);
			
			
			outXml.appendChild(blockList);
			
			var rightList:XMLList = new XMLList('<MARK label="кнопки сбоку" variable="rightPanel">'+this.rightPanel.toString()+'</MARK>');
			var bottomList:XMLList = new XMLList('<MARK label="кнопки внизу" variable="bottomPanel">'+this.bottomPanel.toString()+'</MARK>');
			blockList = new XMLList('<BLOCK label="кнопки управления"/>');
			blockList.appendChild(rightList);
			blockList.appendChild(bottomList);
			outXml.appendChild(blockList);
			
			return outXml;
		}
		public function get listPosition():XMLList{
			var outXml:XMLList = new XMLList('<SHIFTFIELD/>');
			
			outXml.@x = super.x;
			outXml.@y = super.y;
			outXml.@width = super.width;
			outXml.@height = super.height;
			outXml.NUMLINE = numLine.toString();
			outXml.NUMCOLUMN = numColumn.toString();
			
			outXml.RIGHTBUTTON = this.rightButton.toString();
			outXml.BOTTOMBUTTON = this.bottomButton.toString();
			
			if(this.cReplace!='') outXml.COLUMNREPLACE = this.cReplace;
			if(this.lReplace!='') outXml.LINEREPLACE = this.lReplace;
			outXml.FULLREPLACE = fReplace.toString();
			
			outXml.EMPTYFIELD = emptyField.toString();
			
			var xml:XMLList;
			var i:int;
			var j:int;
			for(i=0;i<numLine;i++){
				for(j=0;j<numColumn;j++){
					xml = (arrFields[i][j] as OneMaskField).listPosition;
					xml.@i = i;
					xml.@j = j;
					outXml.appendChild(xml);
				}
			}
			
			return outXml;
		}
	}
	
}
