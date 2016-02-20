package source.DBSaver {
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.filters.BlurFilter;
	import source.Components.Label;
	import flash.events.Event;
	import source.MainEnvelope;

	public class DBViwer extends Sprite{
		
		private var sprBG:Sprite = new Sprite();
		private var workSpr:Sprite = new Sprite();
		private var bgPanel:Bitmap;
		private var progress:Label = new Label();
		private var dbModel:DBModel;
		private var bmpData:BitmapData
		public function DBViwer(container:Sprite, model:DBModel) {
			super();
			dbModel = model;
			container.addChild(super);
			
		}
		public function startCheckProgress():void{
			initBackGrount();
			workSpr.x = (MainEnvelope.STAGE.nativeWindow.width - bgPanel.width)/2
			workSpr.y = 150;
			dbModel.addEventListener(DBModel.NUM_TASK_CANGE, NEXT_TASK);
		}
		private function NEXT_TASK(event:Event):void{
			var str:String = 'Загружается ' + (dbModel.id+1).toString() + ' из ' + dbModel.numTask;
			progress.text = str;
			var w:Number = (bgPanel.width - progress.width)/2;
			progress.x = w;
			
		}
		public function stopProgress():void{
			super.removeChild(workSpr);
			dbModel.removeEventListener(DBModel.NUM_TASK_CANGE, NEXT_TASK);
		}
		private function initBackGrount():void{
			sprBG.graphics.lineStyle(1, 0xA9A9A9, 1);
			sprBG.graphics.beginFill(0xF0F0F0, 1);
			sprBG.graphics.drawRoundRect(0, 0, 240, 120, 6, 6);
			sprBG.graphics.endFill();
			bmpData = new BitmapData(sprBG.width, sprBG.height);
			bmpData.draw(sprBG, new Matrix());
			bgPanel = new Bitmap(bmpData);
			bmpData.applyFilter(bmpData, bmpData.rect, new Point(), new BlurFilter());
			workSpr.addChild(bgPanel);
			workSpr.addChild(progress);
			progress.y = 50;
			super.addChild(workSpr);
		}

	}
	
}
