package source.utils.Icons {
	import flash.display.Sprite;
	public class CreateIcon {
		private var arrIcon:Array = new Array(new Peremeshenie(),
											  new Povorot(),
											  new Raskraska(),
											  new Perechislenie(),
											  new Videlenie(),
											  new DoubleClick(),
											  new Vvod(),
											  new Soedinenie(),
											  new Vnesenie());
		private var iconSprite:Sprite = new Sprite;
		private var currentIcon:Array;
		public function CreateIcon(spr:Sprite, arr:Array) {
			spr.addChild(iconSprite);
			iconSprite.x = 8;
			iconSprite.y = 8;
			addIcon(arr);
		}
		private function addIcon(arr:Array){
			currentIcon = new Array();
			var i,l:int;
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
		}
	}
}