package source.BlockOfTask.Task.TaskObjects.CheckBox{
	
	public class FieldFormat {
		private var fieldBG:Boolean = true;
		private var fieldBGColor:uint = 0xFFFFFF;
		private var fieldBorder:Boolean = true;
		private var fieldBorderColor:uint = 0x000000;
		private var fieldSize:Number = 12;
		private var fieldFont:String = 'Arial';
		private var fieldTextColor:uint = 0x000000;
		private var fieldAlign:String = 'left';
		
		public function FieldFormat() {}
		
		public function get background():Boolean{
			return fieldBG;
		}
		public function set background(value:Boolean):void{
			fieldBG = value;
		}
		
		public function get backgroundColor():uint{
			return fieldBGColor;
		}
		public function set backgroundColor(value:uint):void{
			fieldBGColor = value;
		}
		
		public function get border():Boolean{
			return fieldBorder;
		}
		public function set border(value:Boolean):void{
			fieldBorder = value;
		}
		
		public function get borderColor():uint{
			return fieldBorderColor;
		}
		public function set borderColor(value:uint):void{
			fieldBorderColor = value;
		}
		
		public function get size():Number{
			return fieldSize;
		}
		public function set size(value:Number):void{
			fieldSize = value;
		}
		
		public function get font():String{
			return fieldFont;
		}
		public function set font(value:String):void{
			fieldFont = value;
		}
		public function get textColor():uint{
			return fieldTextColor;
		}
		public function set textColor(value:uint):void{
			fieldTextColor = value;
		}
		public function get align():String{
			return fieldAlign;
		}
		public function set align(value:String):void{
			fieldAlign = value;
		}
		
		public function get format():XMLList{
			var outList:XMLList = new XMLList("<FORMAT/>");
			outList.FONT = this.font;
			outList.SIZE = this.size.toString();
			outList.TEXTCOLOR = "0x" + this.textColor.toString(16);
			outList.BORDER = this.border.toString();
			outList.BORDERCOLOR = "0x" + this.borderColor.toString(16);
			outList.BACKGROUND = this.background.toString();
			outList.BACKGROUNDCOLOR = "0x" + this.backgroundColor.toString(16);
			return outList;
		}
		public function set format(value:XMLList):void{
			this.font = value.FONT.toString();
			this.size = parseFloat(value.SIZE.toString());
			this.textColor = uint(value.TEXTCOLOR.toString());
			this.border = value.BORDER.toString()=="true";
			this.background = value.BACKGROUND.toString()=="true";
			this.borderColor = uint(value.BORDERCOLOR.toString());
			this.backgroundColor = uint(value.BACKGROUNDCOLOR.toString());
		}
		
	}
	
}
