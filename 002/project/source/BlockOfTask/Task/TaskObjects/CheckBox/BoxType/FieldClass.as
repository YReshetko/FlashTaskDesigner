﻿package source.BlockOfTask.Task.TaskObjects.CheckBox.BoxType {
	import flash.display.Sprite;
	import flash.text.TextField;
	import source.BlockOfTask.Task.TaskObjects.CheckBox.FieldFormat;
	import flash.text.TextFormat;
	import source.utils.Components.Field;
	
	public class FieldClass extends Sprite{
		internal var field:Field = new Field();
		public function FieldClass() {
			super();
		}
		
		public function set applyFormat(value:FieldFormat):void{
			//field.autoSize = value.align;
			field.border = value.border;
			field.borderColor = value.borderColor;
			field.background = value.background;
			field.backgroundColor = value.backgroundColor;
			field.textColor = value.textColor;
			field.align = value.align;
			field.size = value.size;
			field.font = value.font;
			field.y = -field.height/2;
		}
		public function get hField():Number{
			return field.height;
		}
		public function get wField():Number{
			return field.width;
		}
		public function set hField(value:Number):void{
			field.height = value;
		}
		public function set wField(value:Number):void{
			field.width = value;
		}
		public function get textWidth():Number{
			return field.textWidth;
		}
		public function get textHeight():Number{
			return field.textHeight;
		}
		

	}
	
}
