package source.EnvKonstraktion {
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import source.EnvKonstraktion.AddidtionTools.Primitive;
	import source.EnvKonstraktion.AddidtionTools.Numbers;
	import source.EnvKonstraktion.AddidtionTools.SelectMenu;
	import source.EnvKonstraktion.AddidtionTools.Classic;
	
	public class ToolsPanel extends Sprite{
		public static var TOOL_SELECT:String = 'onToolSelect';
		
		private var classikTan:ClassikTanToolBut = new ClassikTanToolBut();
		
		private var label:InputFieldToolBut = new InputFieldToolBut();
		private var mark:MarkToolBut = new MarkToolBut();
		private var field:FieldToolBut = new FieldToolBut();
		
		private var line:LineToolBut = new LineToolBut();
		private var table:TableToolBut = new TableToolBut();
		private var point:PointToolBut = new PointToolBut();
		private var groupField:GroupFieldBut = new GroupFieldBut();
		
		private var check:CheckToolBut = new CheckToolBut();
		
		private var palitra:PalitraToolBut = new PalitraToolBut();
		private var primitive:Primitive = new Primitive();
		private var numbers:Numbers = new Numbers();
		private var classic:Classic = new Classic();
		private var button:ButtomToolBut = new ButtomToolBut();
		
		//private var cordinate:CordinateToolBut = new CordinateToolBut();
		
		private var paintpanel:CordinateToolBut = new CordinateToolBut();
		
		private var shiftField:ShiftFieldToolBut = new ShiftFieldToolBut();
		private var comand:String = 'select';
		public function ToolsPanel() {
			super();
			addBut();
			initListeners();
		}
		private function addBut():void{
			super.addChild(classikTan);
			super.addChild(primitive);
			super.addChild(numbers);
			super.addChild(classic);
			classic.x = classic.y = 5;
			
			primitive.x = classic.x + classic.width + 2;
			numbers.x = primitive.x + primitive.width + 2;
			classikTan.x = numbers.x + numbers.width - 5;
			numbers.y = primitive.y = classikTan.y = classic.y;
			classikTan.visible = false;
			super.addChild(label);
			super.addChild(mark);
			super.addChild(field);
			super.addChild(check);
			label.x = 5;
			mark.x = label.x + label.width + 2;
			field.x = mark.x + mark.width + 2;
			check.x = field.x + field.width + 2;
			check.y = label.y = mark.y = field.y = classic.y + classic.height + 2;
			
			super.addChild(line);
			super.addChild(table);
			super.addChild(point);
			super.addChild(groupField);
			line.x = 5;
			table.x = line.x + line.width + 2;
			point.x = table.x + table.width + 2;
			groupField.x = point.x + point.width + 2;
			groupField.y = line.y = table.y = point.y = label.y + label.height + 2;
			
			
			super.addChild(palitra);
			super.addChild(shiftField);
			super.addChild(button);
			super.addChild(paintpanel);
			palitra.x = 5;
			paintpanel.y = shiftField.y = button.y = palitra.y = line.y + line.height + 2;
			shiftField.x = palitra.x + palitra.width + 2;
			button.x = shiftField.x + shiftField.width + 2;
			paintpanel.x = button.x + button.width + 2;
			resetAllBut();
		}
		private function resetAllBut():void{
			//classikTan.gotoAndStop(1);
			label.gotoAndStop(1);
			mark.gotoAndStop(1);
			field.gotoAndStop(1);
			line.gotoAndStop(1);
			table.gotoAndStop(1);
			point.gotoAndStop(1);
			check.gotoAndStop(1);
			groupField.gotoAndStop(1);
			button.gotoAndStop(1);
			shiftField.gotoAndStop(1);
			paintpanel.gotoAndStop(1);
		}
		public function initListeners():void{
			classikTan.addEventListener(MouseEvent.MOUSE_DOWN, CLASSIC_MOUSE_DOWN);
			label.addEventListener(MouseEvent.MOUSE_DOWN, LABEL_MOUSE_DOWN);
			mark.addEventListener(MouseEvent.MOUSE_DOWN, MARK_MOUSE_DOWN);
			field.addEventListener(MouseEvent.MOUSE_DOWN, FIELD_MOUSE_DOWN);
			line.addEventListener(MouseEvent.MOUSE_DOWN, LINE_MOUSE_DOWN);
			table.addEventListener(MouseEvent.MOUSE_DOWN, TABLE_MOUSE_DOWN);
			point.addEventListener(MouseEvent.MOUSE_DOWN, POINT_MOUSE_DOWN);
			check.addEventListener(MouseEvent.MOUSE_DOWN, CHECK_MOUSE_DOWN);
			groupField.addEventListener(MouseEvent.MOUSE_DOWN, GROUP_FIELD_MOUSE_DOWN);
			button.addEventListener(MouseEvent.MOUSE_DOWN, BUTTON_MOUSE_DOWN);
			shiftField.addEventListener(MouseEvent.MOUSE_DOWN, SHIFT_FIELD_MOUSE_DOWN);
			paintpanel.addEventListener(MouseEvent.MOUSE_DOWN, CORDINATE_MOUSE_DOWN);
			
			palitra.addEventListener(MouseEvent.MOUSE_DOWN, PALITRA_MOUSE_DOWN);
			primitive.addEventListener(SelectMenu.TOOL_SELECT, PRIMITIVE_MOUSE_DOWN);
			numbers.addEventListener(SelectMenu.TOOL_SELECT, NUMBERS_MOUSE_DOWN);
			classic.addEventListener(SelectMenu.TOOL_SELECT, CLASSIC_NEW_MOUSE_DOWN);
		}
		private function CLASSIC_MOUSE_DOWN(e:MouseEvent):void{
			comand = 'addClassicTan';
			super.dispatchEvent(new Event(TOOL_SELECT));
		}
		private function PALITRA_MOUSE_DOWN(e:MouseEvent):void{
			comand = 'addPalitra';
			super.dispatchEvent(new Event(TOOL_SELECT));
		}
		private function PRIMITIVE_MOUSE_DOWN(event:Event):void{
			comand = primitive.command;
			super.dispatchEvent(new Event(TOOL_SELECT));
		}
		private function NUMBERS_MOUSE_DOWN(event:Event):void{
			comand = numbers.command;
			super.dispatchEvent(new Event(TOOL_SELECT));
		}
		private function CLASSIC_NEW_MOUSE_DOWN(event:Event):void{
			comand = classic.command;
			super.dispatchEvent(new Event(TOOL_SELECT));
		}
		private function LABEL_MOUSE_DOWN(e:MouseEvent):void{
			selectButton('label');
		}
		private function MARK_MOUSE_DOWN(e:MouseEvent):void{
			selectButton('mark');
		}
		private function FIELD_MOUSE_DOWN(e:MouseEvent):void{
			selectButton('field');
		}
		private function LINE_MOUSE_DOWN(e:MouseEvent):void{
			selectButton('line');
		}
		private function TABLE_MOUSE_DOWN(e:MouseEvent):void{
			selectButton('table');
		}
		private function POINT_MOUSE_DOWN(e:MouseEvent):void{
			selectButton('point');
		}
		private function CHECK_MOUSE_DOWN(event:MouseEvent):void{
			selectButton('check');
		}
		private function GROUP_FIELD_MOUSE_DOWN(event:MouseEvent):void{
			selectButton('groupField');
		}
		private function BUTTON_MOUSE_DOWN(event:MouseEvent):void{
			selectButton('button');
		}
		private function SHIFT_FIELD_MOUSE_DOWN(event:MouseEvent):void{
			selectButton('shiftField');
		}
		private function CORDINATE_MOUSE_DOWN(event:MouseEvent):void{
			//selectButton('cordinate');
			selectButton('paintpanel');
		}
		
		private function selectButton(str:String):void{
			if(this[str].currentFrame == 2){
				resetAllBut();
				comand = 'select';
			}else{
				resetAllBut();
				this[str].gotoAndStop(2);
				comand = str;
			}
			super.dispatchEvent(new Event(TOOL_SELECT));
		}
		public function get currentComand():String{
			return comand;
		}
	}
	
}
