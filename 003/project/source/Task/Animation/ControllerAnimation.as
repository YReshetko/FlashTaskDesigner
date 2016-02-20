package source.Task.Animation {
	import flash.events.EventDispatcher;
	import flash.display.Sprite;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import source.Task.OneTask;
	
	public class ControllerAnimation extends EventDispatcher{
		public static var GET_SETTINGS:String = 'onGetSettings';
		private var remTarget:KeyPointAnimation;
		private var arrayAnimation:Array = new Array();
		private var container:Sprite
		public function ControllerAnimation(container:Sprite) {
			super();
			this.container = container;
		}
		//	Получение и запись объекта анимации
		public function getAnimation(object:Sprite):ObjectAnimation{
			var ID:int = arrayAnimation.length;
			arrayAnimation.push(new ObjectAnimation(this.container, object));
			arrayAnimation[ID].addEventListener(GET_SETTINGS, KEY_POINT_GET_SETTINGS);
			arrayAnimation[ID].addEventListener(ObjectAnimation.REMOVE_ANIMATION, REMOVE_ANIMATION);
			return arrayAnimation[ID] as ObjectAnimation;
		}
		private function KEY_POINT_GET_SETTINGS(event:Event):void{
			remTarget = (event.target as ObjectAnimation).currentPoint;
			super.dispatchEvent(new Event(OneTask.GET_OBJECT_SETTINGS));
		}
		private function REMOVE_ANIMATION(event:Event):void{
			var i:int;
			var l:int;
			l = arrayAnimation.length;
			for(i=0;i<l;i++){
				if(arrayAnimation[i] == (event.target as ObjectAnimation)){
					arrayAnimation[i].removeEventListener(GET_SETTINGS, KEY_POINT_GET_SETTINGS);
					arrayAnimation[i].removeEventListener(ObjectAnimation.REMOVE_ANIMATION, REMOVE_ANIMATION);
					arrayAnimation.splice(i, 1);
					return;
				}
			}
		}
		public function get remember():KeyPointAnimation{
			return remTarget;
		}
	}
	
}
