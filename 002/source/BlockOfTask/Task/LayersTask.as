package source.BlockOfTask.Task {
	import flash.display.Sprite;
	import flash.ui.Mouse;
	
	public class LayersTask extends Sprite{
		public var iconContainer:Sprite = new Sprite();
		private var tanContainer:Sprite = new Sprite();
		public var colorPicker:Sprite = new Sprite();
		public var brushContainer:Sprite = new Sprite();
		public var backgroundContainer:Sprite = new Sprite();
		private var layerArray:Array = new Array([new Sprite,	"Рисование изображений",21],
												 [new Sprite,	"Поля перестановки",	20],
												 [new Sprite,	"Кнопки",				19],
												 [new Sprite,	"Групповое поле (Ч)",	18],
												 [new Sprite,	"Групповое поле (Ц)",	17],
												 [new Sprite,	"Компл. таны (Ч)",		1],
												 [new Sprite,	"Картинки таны (Ч)",	2],
												 [new Sprite,	"Польз. таны (Ч)",		3],
												 [new Sprite,	"SWF таны (Ч)",			14],
												 [new Sprite,	"Таблицы",				4],
												 [new Sprite,	"Линии",				5],
												 [new Sprite,	"Надписи",				6],
												 [new Sprite,	"Перечисл. поля",		7],
												 [new Sprite,	"Выбор ответов",		16],
												 [new Sprite,	"Точки соединения",		8],
												 [new Sprite,	"Компл. таны (Ц)",		9],
												 [new Sprite,	"Картинки таны (Ц)",	10],
												 [new Sprite,	"Польз. таны (Ц)",		11],
												 [new Sprite,	"SWF таны (Ц)",			15],
												 [new Sprite,	"Области выделения",	12],
												 [new Sprite,	"SWF объекты",			13],
												 [new Sprite,	"ЧЯРис",				23]);
		public function LayersTask(container:Sprite) {
			super();
			super.mouseEnabled = false;
			super.tabEnabled = false;
			container.addChild(super);
			super.addChild(backgroundContainer);
			super.addChild(colorPicker);
			super.addChild(iconContainer);
			super.addChild(tanContainer);
			super.addChild(brushContainer);
			setAllSprite();
		}
		public function setAllSprite():void{
			var i:int;
			tanContainer.mouseEnabled = false;
			tanContainer.tabEnabled = false;
			for(i=0;i<layerArray.length;i++){
				tanContainer.addChild(layerArray[i][0]);
				layerArray[i][0].mouseEnabled = false;
				layerArray[i][0].tabEnabled = false;
			}
		}
		public function getNamedSprite(s:String):Sprite{
			var i:int;
			for(i=0;i<layerArray.length;i++){
				if(layerArray[i][1] == s){
					return layerArray[i][0];
				}
			}
			return new Sprite();
		}
		public function setLinkArray(str:String):void{
			var arr:Array = str.split(",");
			//trace(this + ': LAYER = ' + arr);
			var promArr:Array;
			var i:int;
			var j:int;
			for(i=0;i<arr.length;i++){
				promArr = new Array();
				for(j=0;j<layerArray.length;j++){
					if(layerArray[j][2] == arr[i]){
						promArr = layerArray[j];
						layerArray.splice(j,1);
					}
				}
				//trace(promArr);
				if(promArr.length!=0){
					layerArray.splice(i,0,promArr);
				}
			}
			setAllSprite();
		}
		public function removeAllSprite():void{
			var i:int;
			for(i=0;i<layerArray.length;i++){
				tanContainer.removeChild(layerArray[i][0]);
			}
			super.removeChild(colorPicker);
			super.removeChild(tanContainer);
			super.removeChild(brushContainer);
		}
		public function clearAllSprite():void{
			Mouse.show();
			var i:int;
			for(i=0;i<layerArray.length;i++){
				while(layerArray[i][0].numChildren>0){
					layerArray[i][0].removeChildAt(0);
				}
			}
			while(colorPicker.numChildren>0){
				colorPicker.removeChildAt(0);
			}
			while(brushContainer.numChildren>0){
				brushContainer.removeChildAt(0);
			}
		}
	}
	
}
