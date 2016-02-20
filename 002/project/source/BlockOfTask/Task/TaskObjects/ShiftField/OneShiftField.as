package source.BlockOfTask.Task.TaskObjects.ShiftField {
	import flash.display.Sprite;
	import source.utils.Figure;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import source.PlayerLib.Library;
	import flash.utils.ByteArray;
	import source.BlockOfTask.Task.SeparatTask;
	
	public class OneShiftField extends Sprite{
		
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
		private var arrLine:Array = new Array();
		private var arrColumn:Array = new Array();
		
		private var rightButton:Boolean = false;
		private var bottomButton:Boolean = false;
		
		private var buttonIsReplace:Boolean = false;
		private var emptyField:Boolean = false;
		
		private var library:Library;
		public function OneShiftField(value:Sprite, xml:XMLList, library:Library) {
			super();
			this.library = library;
			super.addChild(background);
			wButton = bottomButtons.width;
			value.addChild(super);
			settings = xml;
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
			
			emptyField = xml.EMPTYFIELD.toString() == 'true';
			
			drawField();
			
			for each(var sample:XML in xml.FIELD){
				var content:ByteArray;
				if(sample.USERTAN.toString()!='') {
					if(sample.USERTAN.IMAGE.@name.toString()!=''){
						content = library.getFile(sample.USERTAN.IMAGE.@name.toString());
					}else{
						content = null;
					}
					(arrFields[parseInt(sample.@i)][parseInt(sample.@j)] as OneMaskField).xml(new XMLList(sample.USERTAN.toString()), content, sample.USERTAN.IMAGE.@name.toString());
				
				}
				if(sample.PICTURETAN.toString()!=''){
					if(sample.PICTURETAN.IMAGE.toString()!=''){
						content = library.getFile(sample.PICTURETAN.IMAGE.toString());
					}else{
						content = null;
					}
					(arrFields[parseInt(sample.@i)][parseInt(sample.@j)] as OneMaskField).xml(new XMLList(sample.PICTURETAN.toString()), content, sample.PICTURETAN.IMAGE.toString());
				}
				if(sample.LABEL.toString()!='')  (arrFields[parseInt(sample.@i)][parseInt(sample.@j)] as OneMaskField).xml(new XMLList(sample.LABEL.toString()));
				(arrFields[parseInt(sample.@i)][parseInt(sample.@j)] as OneMaskField).I = parseInt(sample.@i);
				(arrFields[parseInt(sample.@i)][parseInt(sample.@j)] as OneMaskField).J = parseInt(sample.@j);
			}
			if(xml.COLUMNREPLACE.toString()!='') this.cReplace = xml.COLUMNREPLACE.toString();
			if(xml.LINEREPLACE.toString()!='') this.lReplace = xml.LINEREPLACE.toString();
			if(xml.FULLREPLACE.toString()!='') fReplace = xml.FULLREPLACE.toString() == 'true';
			selectFirstActiveField();
		}
		private function selectFirstActiveField():void{
			var i:int;
			var j:int;
			for(i=0;i<this.numLine;i++){
				for(j=0;j<this.numColumn;j++){
					if(checkIndexInArray(this.arrLine, i) || checkIndexInArray(this.arrColumn, j)){
						(this.arrFields[i][j] as OneMaskField).select = true;
						return;
					}
				}
			}
		}
		private function drawField():void{
			//clearField();
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
					(arrFields[i][j] as OneMaskField).addEventListener(OneMaskField.SELECT_FIELD, CHECK_SELECT_FIELD);
					(arrFields[i][j] as OneMaskField).addEventListener(OneMaskField.REPLACE_RIGHT, REPLACE_RIGHT);
					(arrFields[i][j] as OneMaskField).addEventListener(OneMaskField.REPLACE_LEFT, REPLACE_LEFT);
					(arrFields[i][j] as OneMaskField).addEventListener(OneMaskField.REPLACE_BOTTOM, REPLACE_BOTTOM);
					(arrFields[i][j] as OneMaskField).addEventListener(OneMaskField.REPLACE_TOP, REPLACE_TOP);
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
				rightButtons.addEventListener(ButtonForField.REPLACE_BOTTOM, REPLACE_BOTTOM);
				rightButtons.addEventListener(ButtonForField.REPLACE_TOP, REPLACE_TOP);
			}
			
			if(bottomButton){
				super.addChild(bottomButtons);
				bottomButtons.y = this.hField - 12.5;
				bottomButtons.x = (this.wField-25)/2 + 2;
				if(bottomButtons.width > wField-30){
					bottomButtons.width = wField-30;
				}
				bottomButtons.addEventListener(ButtonForField.REPLACE_LEFT, REPLACE_LEFT);
				bottomButtons.addEventListener(ButtonForField.REPLACE_RIGHT, REPLACE_RIGHT);
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
			arrColumn = columnReplace.split(',');
			var arrReplace:Array = new Array();
			var arrObjects:Array = new Array();
			var index:int;
			var i:int;
			var j:int;
			var l:int;
			var k:int;
			var flag:Boolean;
			l = arrColumn.length;
			for(i=0;i<l;i++){
				while(arrReplace.length>0) arrReplace.shift();
				while(arrObjects.length>0) arrObjects.shift();
				index = parseInt(arrColumn[i])-1;
				if(index>=0 && index<this.numColumn){
					while(arrReplace.length<this.numLine){
						flag = true;
						k = Math.floor(Math.random()*numLine);
						for(j=0;j<arrReplace.length;j++){
							if(k == arrReplace[j]) flag = false;
						}
						if(flag) arrReplace.push(k);
					}
					for(j=0;j<arrReplace.length;j++){
						arrObjects.push(arrFields[arrReplace[j]][index]);
					}
					
					var decY:Number = 0;
					if(bottomButton) decY = 25;
					var h:Number = (hField - decY - (deltaY * (numLine+1)))/numLine;
					for(j=0;j<this.numLine;j++){
						arrFields[j][index] = arrObjects[j];
						arrFields[j][index].y = deltaY*(j + 1) + j*h;
					}
				}
			}
		}
		
		
		
		public function set lReplace(value:String):void{
			lineReplace = value;
			arrLine = this.lineReplace.split(',');
			var arrReplace:Array = new Array();
			var arrObjects:Array = new Array();
			var index:int;
			var i:int;
			var j:int;
			var l:int;
			var k:int;
			var flag:Boolean;
			l = arrLine.length;
			for(i=0;i<l;i++){
				while(arrReplace.length>0) arrReplace.shift();
				while(arrObjects.length>0) arrObjects.shift();
				index = parseInt(arrLine[i])-1;
				if(index>=0 && index<this.numLine){
					while(arrReplace.length<this.numColumn){
						flag = true;
						k = Math.floor(Math.random()*numColumn);
						for(j=0;j<arrReplace.length;j++){
							if(k == arrReplace[j]) flag = false;
						}
						if(flag) arrReplace.push(k);
					}
					for(j=0;j<arrReplace.length;j++){
						arrObjects.push(arrFields[index][arrReplace[j]]);
					}
					
					var decX:Number = 0;
					if(rightButton) decX = 25;
					var w:Number = (wField - decX - (deltaX * (numColumn+1)))/numColumn;
					for(j=0;j<this.numColumn;j++){
						arrFields[index][j] = arrObjects[j];
						arrFields[index][j].x = deltaX*(j + 1) + j*w;
					}
				}
			}
		}
		public function get cReplace():String{
			return columnReplace;
		}
		public function get lReplace():String{
			return lineReplace;
		}
		
		public function set fReplace(value:Boolean):void{
			fullReplace = value;
			if(value){
				var i:int;
				if(this.emptyField){
					for(i=0;i<numLine;i++){
						this.arrLine.push(i+1);
					}
					for(i=0;i<numColumn;i++){
						this.arrColumn.push(i+1);
					}
					replaceEven();
				}else{
					
					var str:String = '1';
					for(i=1;i<numLine;i++){
						str += ','+(i+1);
					}
					lReplace = str;
					str = '1';
					for(i=1;i<numColumn;i++){
						str += ','+(i+1);
					}
					cReplace = str;
				}
			}
		}
		private function replaceEven():void{
			var I:int;
			var J:int;
			var i:int;
			var j:int;
			var k:int;
			for(i=0;i<this.numLine;i++){
				for(j=0;j<this.numColumn;j++){
					if((this.arrFields[i][j] as OneMaskField).isEmpty){
						I = i;
						J = j;
					}
				}
			}
			var numIter:int = this.numLine * this.numColumn + Math.ceil(Math.random()*15);
			var object:Object;
			for(k=0;k<numIter;k++){
				object = getReplaceIndex(I, J);
				replaceTwoField(I, J, object.I, object.J);
				I = object.I;
				J = object.J;
			}
		}
		private function getReplaceIndex(i:int, j:int):Object{
			var I:Array = new Array();
			var J:Array = new Array();
			if(i!=0){
				I.push(i-1);
				J.push(j);
			}
			if(j!=0){
				I.push(i);
				J.push(j-1);
			}
			if(i!=numLine-1){
				I.push(i+1);
				J.push(j);
			}
			if(j!=numColumn-1){
				I.push(i);
				J.push(j+1);
			}
			var index:int = Math.floor(Math.random()*I.length);
			var outObject:Object = new Object();
			outObject.I = I[index];
			outObject.J = J[index];
			return outObject;
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
		
		private function REPLACE_BOTTOM(event:Event):void{
			var object:Object = selectIndex;
			if(object == null) return;
			buttonIsReplace = true;
			var I:int = object.I;
			var J:int = object.J
			if(!checkIndexInArray(this.arrColumn, J)) return;
			
			if(I<this.numLine-1) replaceTwoField(I, J, I+1, J);
			else replaceTwoField(I, J, 0, J);
			
		}
		private function REPLACE_TOP(event:Event):void{
			var object:Object = selectIndex;
			if(object == null) return;
			buttonIsReplace = true;
			var I:int = object.I;
			var J:int = object.J
			if(!checkIndexInArray(this.arrColumn, J)) return;
			
			if(I>0) replaceTwoField(I, J, I-1, J);
			else replaceTwoField(I, J, this.numLine-1, J);
		}
		private function REPLACE_LEFT(event:Event):void{
			var object:Object = selectIndex;
			if(object == null) return;
			buttonIsReplace = true;
			var I:int = object.I;
			var J:int = object.J;
			if(!checkIndexInArray(this.arrLine, I)) return;
			
			if(J>0) replaceTwoField(I, J, I, J-1);
			else replaceTwoField(I, J, I, this.numColumn-1);
		}
		private function REPLACE_RIGHT(event:Event):void{
			var object:Object = selectIndex;
			if(object == null) return;
			buttonIsReplace = true;
			var I:int = object.I;
			var J:int = object.J
			if(!checkIndexInArray(this.arrLine, I)) return;
			
			if(J<this.numColumn-1) replaceTwoField(I, J, I, J+1);
			else replaceTwoField(I, J, I, 0);
		}
		public function get selectIndex():Object{
			var i:int;
			var j:int;
			for(i=0;i<this.numLine;i++){
				for(j=0;j<this.numColumn;j++){
					if((arrFields[i][j] as OneMaskField).select){
						var object:Object = new Object();
						object.I = i;
						object.J = j;
						return object;
					}
				}
			}
			return null;
		}
		private function CHECK_SELECT_FIELD(event:Event):void{
			if(this.buttonIsReplace){
				removeSelect();
				this.buttonIsReplace = false;
			}
			if(fullReplace){
				(event.target as OneMaskField).select = !(event.target as OneMaskField).select;
				checkFullReplace();
				return;
			}
			var i:int;
			var j:int;
			if(this.arrColumn.length>0 || this.arrLine.length>0){
				for(i=0;i<this.numLine;i++){
					for(j=0;j<this.numColumn;j++){
						if((event.target as OneMaskField) == (arrFields[i][j] as OneMaskField)){
							trace(this + ': FIELD SELECT');
							if(checkIndexInArray(arrLine, i) || checkIndexInArray(arrColumn, j)){
								trace(this + ': FIELD true SELECT');
								(arrFields[i][j] as OneMaskField).select = !(arrFields[i][j] as OneMaskField).select;
								checkLineReplace(i,j);
								return;
							}
						}
					}
				}
			}
		}
		private function checkLineReplace(I:int, J:int):void{
			var i:int;
			var j:int;
			for(i=0;i<this.numLine;i++){
				for(j=0;j<this.numColumn;j++){
					if(i==I && j==J){
					}else{
						if((arrFields[i][j] as OneMaskField).select){
							if(i == I && checkIndexInArray(this.arrLine, i)){
								//	поменять местами
								replaceTwoField(i, j, I, J);
								//	обнулить все выделения
								removeSelect();
								return;
							}
							if(j == J && checkIndexInArray(this.arrColumn, j)){
								//	поменять местами
								replaceTwoField(i, j, I, J);
								//	обнулить все выделения
								removeSelect();
								return;
							}								
							//	обнулить выделение i,j поля
							(arrFields[i][j] as OneMaskField).select = false;
						}
					}
				}
			}
		}
		private function checkFullReplace():void{
			var i:int;
			var j:int;
			var indexSelect:Array = new Array();
			for(i=0;i<this.numLine;i++){
				for(j=0;j<this.numColumn;j++){
					if((arrFields[i][j] as OneMaskField).select){
						if(this.emptyField){
							if(!(arrFields[i][j] as OneMaskField).isEmpty){
								var obj:Object = this.findEmptyField(i, j);
								if(obj != null){
									replaceTwoField(i, j, obj.I, obj.J);
									this.removeSelect();
									return;
								}
							}
						}
						indexSelect.push([[i],[j]])
					}
				}
			}
			if(indexSelect.length<2) return;
			replaceTwoField(indexSelect[1][0], indexSelect[1][1], indexSelect[0][0], indexSelect[0][1]);
			removeSelect();
		}
		
		private function removeSelect():void{
			var i:int;
			var j:int;
			for(i=0;i<this.numLine;i++){
				for(j=0;j<this.numColumn;j++){
					(arrFields[i][j] as OneMaskField).select = false;
				}
			}
		}
		private function replaceTwoField(i1:int, j1:int, i2:int, j2:int):void{
			trace(this + ': REPLACE TWO FIELD');
			var x1:Number;
			var y1:Number;
			var x2:Number;
			var y2:Number;
			
			if(emptyField){
				if(!(arrFields[i1][j1] as OneMaskField).isEmpty && !(arrFields[i2][j2] as OneMaskField).isEmpty) {
					this.removeSelect();
					return;
				}
				if((Math.abs(i1-i2) == 1 && Math.abs(j1-j2) != 1) ||
				   (Math.abs(i1-i2) != 1 && Math.abs(j1-j2) == 1)){
					   if(Math.abs(i1-i2) == this.numLine-1 || Math.abs(j1-j2) == this.numColumn-1) return;
				   }else return;
			}
			
			x1 = (arrFields[i1][j1] as OneMaskField).x;
			y1 = (arrFields[i1][j1] as OneMaskField).y;
			
			x2 = (arrFields[i2][j2] as OneMaskField).x;
			y2 = (arrFields[i2][j2] as OneMaskField).y;
			
			var remField:OneMaskField = (arrFields[i1][j1] as OneMaskField);
			arrFields[i1][j1] = (arrFields[i2][j2] as OneMaskField);
			arrFields[i2][j2] = remField;
			
			(arrFields[i1][j1] as OneMaskField).x = x1;
			(arrFields[i1][j1] as OneMaskField).y = y1;
			
			(arrFields[i2][j2] as OneMaskField).x = x2;
			(arrFields[i2][j2] as OneMaskField).y = y2;
			
			super.dispatchEvent(new Event(SeparatTask.CHECK_TASK));
		}
		private function findEmptyField(I:int, J:int):Object{
			var outObject:Object = new Object();
			outObject.numEmpty = 0;
			if(I!=0){
				if((arrFields[I-1][J] as OneMaskField).isEmpty){
					outObject.numEmpty = outObject.numEmpty + 1;
					outObject.I = (I-1);
					outObject.J = J;
				}
			}
			if(J!=0){
				if((arrFields[I][J-1] as OneMaskField).isEmpty){
					outObject.numEmpty = outObject.numEmpty + 1;
					outObject.I = I;
					outObject.J = (J-1);
				}
			}
			if(I!=numLine-1){
				if((arrFields[I+1][J] as OneMaskField).isEmpty){
					outObject.numEmpty = outObject.numEmpty + 1;
					outObject.I = (I+1);
					outObject.J = J;
				}
			}
			if(J!=numColumn-1){
				if((arrFields[I][J+1] as OneMaskField).isEmpty){
					outObject.numEmpty = outObject.numEmpty + 1;
					outObject.I = I;
					outObject.J = (J+1);
				}
			}
			if(outObject.numEmpty != 1) return null;
			return outObject;
		}
		private function checkIndexInArray(array:Array, index:int):Boolean{
			var i:int;
			var l:int;
			l = array.length;
			for(i=0;i<l;i++){
				if(array[i]-1 == index) return true;
			}
			return false
		}
		
		
		
		public function get complate():Boolean{
			var i:int;
			var j:int;
			for(i=0;i<this.numLine;i++){
				for(j=0;j<this.numColumn;j++){
					if(!(arrFields[i][j] as OneMaskField).isEmpty){
						if(i != (arrFields[i][j] as OneMaskField).I || j != (arrFields[i][j] as OneMaskField).J) return false;
					}
				}
			}
			return true;
		}
		
		public function showAnswer():void{
			
		}
	}
}
