package source.Task.TaskObjects.Table {
	import flash.display.Sprite;
	import flash.geom.*;
	import flash.events.MouseEvent;
	import source.DesignerMain;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import source.utils.Figure;
	import source.Task.Animation.ObjectAnimation;
	import source.Task.TaskSystem;

	public class OneTable extends Sprite {
		public static var COPY_OBJECT:String = 'onCopyObject';
		public static var TRANSFORM:String = 'onTransform';
		public static var CLASS_CHANGE:String = 'onClassChange';
		public static var GET_SETTINGS:String = 'onGetSettings';
		public static var REMOVE_TABLE:String = 'onRemoveTable';
		private var entarArea:Boolean = false;
		private var numLine:int;
		private var numColumn:int;
		private var thick:int;
		private var Width:Number;
		private var Height:Number;
		private var tableLabel:MoveLabel;
		private var lineColor:uint = 0x000000;
		
		private var adhereDifferences:Boolean = false;
		private var classDifferences:int = 0;
		private var classHelp:Boolean = false;
		private var isDelete:Boolean = false;
		
		private var remContainer:Sprite;
		public var selectContainer:Sprite;
		private var boundsContainer:Sprite = new Sprite();
		private var isSelect:Boolean = false;
		
		private var objectAnimation:ObjectAnimation;
		private var currentXml:XMLList;
		
		private var frameSelect:Boolean = false;
		public function OneTable(xml:XMLList, container:Sprite) { 
			super();
			currentXml = xml;
			remContainer = container;
			container.addChild(super);
			tableLabel = new MoveLabel();
			super.addChild(tableLabel);
			tableLabel.alpha = 0.2;
			tableLabel.addEventListener(MouseEvent.MOUSE_DOWN, TABLE_MOUSE_DOWN);
			tableLabel.addEventListener(MouseEvent.MOUSE_OVER, TABLE_MOUSE_OVER);
			tableLabel.addEventListener(MouseEvent.MOUSE_OUT, TABLE_MOUSE_OUT);
			tableLabel.addEventListener(KeyboardEvent.KEY_DOWN, TABLE_KEY_DOWN);
			
			objectAnimation = TaskSystem.animationController.getAnimation(super);
			objectAnimation.classObject = this;
			
			super.x = parseFloat(xml.X);
			super.y = parseFloat(xml.Y);
			Width = parseFloat(xml.WIDTH);
			Height = parseFloat(xml.HEIGHT);
			if(xml.THICK.toString() != '')thick = parseInt(xml.THICK);
			else thick = 2;
			if(xml.COLOR.toString() != '')lineColor = xml.COLOR;
			else lineColor = 0x000000;
			if(xml.LINE.toString()!='') numLine = parseInt(xml.LINE);
			else numLine = 1;
			if(xml.COLUMN.toString()!='') numColumn = parseInt(xml.COLUMN);
			else numColumn = 1;
			trace(this + ': OUT NUM LINE = ' + numLine);
			if(numLine<1){
				trace(this + ': NUM LINE = ' + numLine);
				numLine = 1;
				trace(this + ': NUM LINE = ' + numLine);
			}
			trace(this + ': OUT NUM COLUMN = ' + numColumn);
			if(numColumn<1){
				trace(this + ': NUM COLUMN = ' + numColumn);
				numColumn = 1;
				trace(this + ': NUM COLUMN = ' + numColumn);
			}
			drawTable();
			this.isArea = xml.ENTERAREA.toString()=='true';
			if(xml.FRAME.toString()!='') isFrame = xml.FRAME.toString()=='true';
			if(xml.ANIMATION.@step.toString()!=''){
				this.listAnimation = xml.ANIMATION as XMLList;
			}
		}
		public function checkDiff():void{
			if(currentXml.DIFF.toString()!=''){
				this.isAdhere = true;
				this.isClass = parseInt(currentXml.DIFF.NUMCLASS.toString());
				this.isHelp = currentXml.DIFF.HELP.toString()=='true';
			}
			
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
			boundsContainer.x = rect.x + W/2 - 2;
			boundsContainer.y = rect.y + H/2 - 2;
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
					isDelete = true;
					if(this.objectAnimation!=null) this.objectAnimation.removeAnimation();
					if(this.objectAnimation!=null) this.objectAnimation.removeObjectAnimation();
					super.dispatchEvent(new Event(REMOVE_TABLE));
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
			tableLabel.removeEventListener(MouseEvent.MOUSE_DOWN, TABLE_MOUSE_DOWN);
			tableLabel.removeEventListener(MouseEvent.MOUSE_OVER, TABLE_MOUSE_OVER);
			tableLabel.removeEventListener(MouseEvent.MOUSE_OUT, TABLE_MOUSE_OUT);
			tableLabel.removeEventListener(KeyboardEvent.KEY_DOWN, TABLE_KEY_DOWN);
			super.removeChild(tableLabel)
			tableLabel = null;
			super.parent.removeChild(super);
		}
		private function drawTable():void{
			super.graphics.clear();
			super.graphics.lineStyle(thick, lineColor);
			crRamka(super, 0 ,0, Width, Height);
			crStroki(super, 0, 0, Width, Height, numLine);
			crStolbci(super, 0, 0, Width, Height, numColumn);
		}
		private function crRamka(tab:Object,_X:Number,_Y:Number,_W:Number,_H:Number):void{
			tab.graphics.moveTo(_X,_Y);
			tab.graphics.lineTo(_X+_W,_Y);
			tab.graphics.lineTo(_X+_W,_Y+_H);
			tab.graphics.lineTo(_X,_Y+_H);
			tab.graphics.lineTo(_X,_Y);
		}
		private function crStroki(tab:Object,_X:Number,_Y:Number,_W:Number,_H:Number,_Str:int):void{
			for(var i:int=1;i<_Str;i++){
				tab.graphics.moveTo(_X,_Y+((_H/_Str)*i));
				tab.graphics.lineTo(_X+_W,_Y+((_H/_Str)*i));
			}
		}
		private function crStolbci(tab:Object,_X:Number,_Y:Number,_W:Number,_H:Number,_Stl:int):void{
			for(var i:int=1;i<_Stl;i++){
				tab.graphics.moveTo(_X+((_W/_Stl)*i),_Y);
				tab.graphics.lineTo(_X+((_W/_Stl)*i),_Y+_H);
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
		
		public function get tableWidth():Number{
			return Width;
		}
		public function set tableWidth(value:Number):void{
			Width = value;
			drawTable();
			if(this.isSelect) this.drawSelect();
		}
		
		public function get tableHeight():Number{
			return Height;
		}
		public function set tableHeight(value:Number):void{
			Height = value;
			drawTable();
			if(this.isSelect) this.drawSelect();
		}
		
		public function get tableThick():int{
			return thick;
		}
		public function set tableThick(value:int):void{
			thick = value;
			drawTable();
			if(this.isSelect) this.drawSelect();
		}
		
		public function get tableLine():int{
			return numLine;
		}
		public function set tableLine(value:int):void{
			numLine = value;
			if(numLine<1)numLine = 1;
			drawTable();
			if(this.isSelect) this.drawSelect();
		}
		
		public function get tableColumn():int{
			return numColumn;
		}
		public function set tableColumn(value:int):void{
			numColumn = value;
			if(numColumn<1)numColumn = 1;
			drawTable();
			if(this.isSelect) this.drawSelect();
		}
		
		public function get isArea():Boolean{
			return entarArea;
		}
		public function set isArea(value:Boolean):void{
			entarArea = value;
		}
		public function set color(value:uint):void{
			lineColor = value;
			drawTable();
		}
		public function get color():uint{
			return lineColor;
		}
		public function set isAdhere(value:Boolean):void{
			adhereDifferences = value;
			super.dispatchEvent(new Event(TRANSFORM));
		}
		public function get isAdhere():Boolean{
			return adhereDifferences;
		}
		public function set isClass(value:int):void{
			classDifferences = value;
			super.dispatchEvent(new Event(CLASS_CHANGE));
		}
		
		public function get isClass():int{
			return classDifferences;
		}
		public function set isHelp(value:Boolean):void{
			classHelp = value;
		}
		public function get isHelp():Boolean{
			return classHelp;
		}
		
		public function set isFrame(value:Boolean):void{
			frameSelect = value;
		}
		public function get isFrame():Boolean{
			return frameSelect;
		}
		
		public function get animation():ObjectAnimation{
			return this.objectAnimation;
		}
		public function get listAnimation():XMLList{
			if(objectAnimation.hasAnimation) return objectAnimation.listPosition;
			return null;
		}
		public function set listAnimation(value:XMLList):void{
			if(objectAnimation!=null) objectAnimation.listPosition = value;
		}
		public function get listSettings():XMLList{
			var outXml:XMLList = new XMLList('<PACKAGE/>');
			outXml.@label = 'ТАБЛИЦА';
			var widthList:XMLList = new XMLList('<FIELD label="ширина" type="number" variable="tableWidth" width="40">' + this. tableWidth.toString() + '</FIELD>');
			var heightList:XMLList = new XMLList('<FIELD label="высота" type="number" variable="tableHeight" width="40">' + this.tableHeight.toString() + '</FIELD>');			
			
			var blockList:XMLList = new XMLList('<BLOCK label="размер таблицы"/>');
			blockList.appendChild(widthList);
			blockList.appendChild(heightList);
			outXml.appendChild(blockList);

			widthList = new XMLList('<FIELD label="число строк" type="number" variable="tableLine" width="40">' + this.tableLine.toString() + '</FIELD>');
			heightList = new XMLList('<FIELD label="число столбцов" type="number" variable="tableColumn" width="40">' + this.tableColumn.toString() + '</FIELD>');			
			blockList = new XMLList('<BLOCK label="количество ячеек"/>');
			blockList.appendChild(widthList);
			blockList.appendChild(heightList);
			outXml.appendChild(blockList);
			
			widthList = new XMLList('<FIELD label="толщина линий" type="number" variable="tableThick" width="40">' + this.tableThick.toString() + '</FIELD>');
			heightList = new XMLList('<MARK label="использовать как область внесения" variable="isArea">'+this.isArea.toString()+'</MARK>');			
			blockList = new XMLList('<BLOCK label="общие настройки"/>');
			blockList.appendChild(widthList);
			blockList.appendChild(heightList);
			outXml.appendChild(blockList);
			
			var frameList:XMLList = new XMLList('<MARK label="рамка" variable="isFrame">'+this.isFrame.toString()+'</MARK>');
			blockList = new XMLList('<BLOCK label="надстройка"/>');
			blockList.appendChild(frameList);
			outXml.appendChild(blockList);
			
			var adhereXml:XMLList = new XMLList('<MARK label="привязка к облястям выделения" variable="isAdhere">'+this.isAdhere.toString()+'</MARK>');
			var classXml:XMLList = new XMLList('<FIELD label="класс таблицы" type="number" variable="isClass" width="40">' + this.isClass.toString() + '</FIELD>');
			var helpXml:XMLList = new XMLList('<MARK label="подсказка" variable="isHelp">'+this.isHelp.toString()+'</MARK>');
			blockList = new XMLList('<BLOCK label="настройка сравнения"/>');
			blockList.appendChild(adhereXml);
			blockList.appendChild(classXml);
			blockList.appendChild(helpXml);
			outXml.appendChild(blockList);
			
			var animationObjectXML:XMLList = new XMLList('<ANIMATION variable="animation"/>');
			blockList = new XMLList('<BLOCK label="анимация таблицы"/>');
			blockList.appendChild(animationObjectXML);
			outXml.appendChild(blockList);
			
			return outXml;
		}
		public function get colorSettings():XMLList{
			var outXml:XMLList = new XMLList('<PACKAGE/>');
			outXml.appendChild(new XML('<COLOR label="line" variable="color">' + this.color.toString() + '</COLOR>'));
			return outXml;
		}
		
		public function get listPosition():XMLList{
			var outXml:XMLList = new XMLList('<TABLE/>');
			outXml.X = super.x;
			outXml.Y = super.y;
			outXml.WIDTH = tableWidth;
			outXml.HEIGHT = tableHeight;
			outXml.THICK = this.thick;
			outXml.COLOR = lineColor;
			outXml.LINE = tableLine;
			outXml.COLUMN = tableColumn;
			outXml.ENTERAREA = isArea;
			outXml.FRAME = isFrame;
			if(this.isAdhere){
				outXml.DIFF.NUMCLASS = this.isClass;
				outXml.DIFF.HELP = this.isHelp;
			}
			if(listAnimation!=null){
				outXml.appendChild(listAnimation);
			}
			return outXml;
		}
	}
}