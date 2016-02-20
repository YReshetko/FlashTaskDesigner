package source.BlockOfTask.Task.Animation {
	import flash.events.EventDispatcher;
	/*import flash.display.Sprite;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import source.Task.OneTask;*/
	
	public class ControllerAnimation extends EventDispatcher{
		/*public static var GET_SETTINGS:String = 'onGetSettings';
		private var remTarget:KeyPointAnimation;
		private var arrayAnimation:Array = new Array();*/
		public function ControllerAnimation() {
			super();
		}
		/*//	Получение и запись объекта анимации
		public function getAnimation(container:Sprite, object:Sprite):ObjectAnimation{
			var ID:int = arrayAnimation.length;
			arrayAnimation.push(new ObjectAnimation(container, object));
			arrayAnimation[ID].addEventListener(GET_SETTINGS, KEY_POINT_GET_SETTINGS);
			return arrayAnimation[ID] as ObjectAnimation;
		}
		private function KEY_POINT_GET_SETTINGS(event:Event):void{
			remTarget = (event.target as ObjectAnimation).currentPoint;
			super.dispatchEvent(new Event(OneTask.GET_OBJECT_SETTINGS));
		}
		public function get remember():KeyPointAnimation{
			return remTarget;
		}*/
	}
	
}
