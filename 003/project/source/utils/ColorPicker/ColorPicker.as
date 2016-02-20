package source.utils.ColorPicker {
	import flash.display.Sprite;
	import flash.events.Event;
	import source.utils.ColorPicker.addSettings.SaverSettings;
	
	public class ColorPicker extends Sprite{
		public static var COLOR_CHANGE:String = 'onColorChange';
		private var saverSettings:SaverSettings;
		private var simplePicker:PickerPanel;
		private var difficultPicker:DifficultPicker;
		private var textPicker:TextPicker;
		public function ColorPicker() {
			super();
			initSaverSettings();
			initSimplePanel();
			initDifficultPanel();
			initTextPicker();
		}
		public function set container(value:Sprite):void{
			value.addChild(super);
		}
		private function initSaverSettings():void{
			saverSettings = new SaverSettings();
			super.addChild(saverSettings);
			saverSettings.addEventListener(SaverSettings.CHANGE_SELECT, CHANGE_LABEL_SELECT);
		}
		private function initSimplePanel():void{
			simplePicker = new PickerPanel();
			super.addChild(simplePicker);
			simplePicker.x = 105;
			simplePicker.addEventListener(COLOR_CHANGE, PICKER_COLOR_CHANGE);
		}
		private function initDifficultPanel():void{
			difficultPicker = new DifficultPicker();
			super.addChild(difficultPicker);
			difficultPicker.y = simplePicker.y + simplePicker.height + 15;
			difficultPicker.addEventListener(COLOR_CHANGE, PICKER_COLOR_CHANGE);
		}
		private function initTextPicker():void{
			textPicker = new TextPicker();
			super.addChild(textPicker);
			textPicker.y = difficultPicker.y - 30;
			textPicker.color = difficultPicker.color;
			textPicker.addEventListener(COLOR_CHANGE, PICKER_COLOR_CHANGE);
		}
		private function PICKER_COLOR_CHANGE(e:Event):void{
			var currentColor:uint = e.target.color;
			if(e.target != difficultPicker) difficultPicker.color = currentColor;
			if(e.target != textPicker) textPicker.color = currentColor;
			saverSettings.color = currentColor;
		}
		private function CHANGE_LABEL_SELECT(e:Event):void{
			//trace(this + ': Object SELECT; COLOR = ' + e.target.color);
			var currentColor:uint = e.target.color;
			difficultPicker.color = currentColor;
			textPicker.color = currentColor;
		}
		public function set object(value:*):void{
			//trace(this + ': set Object COMPLATE');
			if(value == null){
				saverSettings.clearPanel();
			}else{
				saverSettings.object = value;
			}
		}
	}
	
}
