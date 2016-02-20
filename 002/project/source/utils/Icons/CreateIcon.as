package source.utils.Icons {
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import source.MainPlayer;

	public class CreateIcon {
		private var arrIcon:Array = new Array(new Peremeshenie(),
											  new Povorot(),
											  new Raskraska(),
											  new Perechislenie(),
											  new Videlenie(),
											  new DoubleClick(),
											  new Vvod(),
											  new Soedinenie(),
											  new Vnesenie(),
											  new Probel(),
											  new MuchSelect(),
											  new OneSelect(),
											  new CharisProgramToStage(),//12
											  new CharisProgramToSchem(),//13
											  new CharisSchemToSchem(),//14
											  new CharisSchemToStage(),//15
											  new CharisStageToSchem(),//16
											  new CharisStageToStage()); // 17
		private var hitIcons:Array = new Array('Перемещение объектов',
											   'Поворот танов стрелочками',
											   'Раскрашивание объектов',
											   'Поля перечисления (клик по объекту)',
											   'Области выделения (клик по примечательной области)',
											   'Попарный клик по области сцены',
											   'Ввод текста',
											   'Соединение нескольких точек сцены',
											   'Внесение объектов в некоторую область сцены',
											   'Переворот объекта по клавише "Пробел"',
											   'Множественный выбор',
											   'Одиночный выбор',
											   'По программе построить рисунок',
											   'По программе построить схему',
											   'По схеме построить схему',
											   'По схеме построить рисунок',
											   'По рисунку построить схему',
											   'По рисунку построить рисунок');
		private var iconSprite:Sprite = new Sprite;
		private var currentIcon:Array;
		private var currentHint:IconHint;
		public function CreateIcon(spr:Sprite, arr:Array) {
			spr.addChild(iconSprite);
			iconSprite.x = 8;
			iconSprite.y = 8;
			addIcon(arr);
		}
		private function addIcon(arr:Array):void{
			currentIcon = new Array();
			var i:int;
			var l:int;
			l = arr.length;
			for(i=0;i<l;i++){
				if(arrIcon[i]!=null && arr[i]){
					currentIcon.push(arrIcon[i]);
				}
			}
			l = currentIcon.length;
			if(l==0)return;
			iconSprite.addChild(currentIcon[0]);
			for(i=1;i<l;i++){
				iconSprite.addChild(currentIcon[i]);
				currentIcon[i].x = currentIcon[i-1].x + currentIcon[i-1].width;
			}
			for(i=0;i<l;i++){
				currentIcon[i].addEventListener(MouseEvent.MOUSE_OVER, ICON_MOUSE_OVER);
				currentIcon[i].addEventListener(MouseEvent.MOUSE_OUT, ICON_MOUSE_OUT);
			}
		}
		private function ICON_MOUSE_OVER(event:MouseEvent):void{
			var i:int;
			var l:int;
			l = arrIcon.length;
			for(i=0;i<l;i++){
				if(event.target == arrIcon[i]){
					currentHint = new IconHint(hitIcons[i]);
					MainPlayer.STAGE.addChild(currentHint);
					currentHint.x = event.stageX+2;
					currentHint.y = event.stageY+2;
				}
			}
		}
		private function ICON_MOUSE_OUT(event:MouseEvent):void{
			if(MainPlayer.STAGE.contains(currentHint)){
				MainPlayer.STAGE.removeChild(currentHint);
				currentHint = null;
			}
		}
	}
}