package source.Task.TaskSceneControl {
	import flash.display.Sprite;
	import source.utils.Figure;
	
	public class IconControl extends Sprite{
		private var labelArr:Array = [	new Vvod(),
										new Vnesenie(),
										new Videlenie(),
										new Soedinenie(),
										new Raskraska(),
										new Probel(),
										new Povorot(),
										new Peremeshenie(),
										new Perechislenie(),
										new OneSelect(),
										new MuchSelect(),
										new DoubleClick()	];
		public function IconControl(value:Sprite) {
			super();
			value.addChild(super);
			super.x = super.y = 7;
			initIcon();
		}
		private function initIcon():void{
			Figure.insertRect(super, 350, 30);
			var i:int;
			var l:int;
			l = labelArr.length;
			for(i=0;i<l;i++){
				super.addChild(labelArr[i]);
				labelArr[i].x = i*29.3;
			}
		}
		public function open():void{
			super.visible = true;
		}
		public function close():void{
			super.visible = false;
		}

	}
	
}
