package source.EnvInterface.EnvMenu {
	import flash.display.Sprite;
	import source.EnvUtils.EnvDraw.Figure;
	import source.EnvEvents.Events;
	import source.EnvUtils.EnvDraw.Filters;
	import flash.events.Event;
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.display.Bitmap;
	import flash.geom.Point;
	import flash.filters.BlurFilter;
	
	public class ListMenu extends Sprite{
		private static const deltaShadow:int = 4;
		
		private static const baseX:int = 3;
		private static const baseY:int = 3;
		
		private var arrLinksMenu:Array = new Array();
		
		private var listContainer:Sprite = new Sprite();
		
		public var currentLinkStatus:String;
		public function ListMenu() {
			super();
			super.addChild(listContainer);
			listContainer.y = Menu.MENU_HEIGHT;
			listContainer.visible = false;
		}
		public function addLinkMenu(nameLink:String, dispatchStatus:String = null):void{
			var ID:int = arrLinksMenu.length;
			if(nameLink == '---'){
				arrLinksMenu.push(new LinkLine());
			}else{
				arrLinksMenu.push(new LinkMenu(nameLink, dispatchStatus));
			}
			listContainer.addChild(arrLinksMenu[ID]);
			if(ID!=0) arrLinksMenu[ID].y = arrLinksMenu[ID-1].y + arrLinksMenu[ID-1].height;
			else arrLinksMenu[ID].y = baseY;
			arrLinksMenu[ID].x = baseX;
			arrLinksMenu[ID].addEventListener(Events.LINK_DISPATCH_STATUS, LINK_DISPATCHED);
			//	Перерисовка поля
		}
		public function activList(activator:Boolean):void{
			listContainer.visible = activator;
		}
		public function finalyList():void{
			var i:int;
			var maxWidth:Number = arrLinksMenu[0].getWidth();
			for(i=1;i<arrLinksMenu.length;i++){
				if(arrLinksMenu[i].getWidth()>maxWidth) maxWidth = arrLinksMenu[i].getWidth();
			}
			for(i=0;i<arrLinksMenu.length;i++){
				arrLinksMenu[i].setWidth(maxWidth);
			}
			
			var listWidth:Number = listContainer.width+ 2 * baseX;
			var listHeight:Number = listContainer.height + 2 * baseY;
			var backG:Sprite = Figure.returnRect(listWidth, listHeight, 1, 0.7, 0x6D6D6D, 1, 0xFFFFFFD)
			listContainer.addChild(backG);
			listContainer.setChildIndex(backG, 0);
			var botBitmap:Bitmap = Filters.returnBlurBitmap(Figure.returnRect(listWidth, deltaShadow, 1,0,0x000000, 0.4, 0x000000));
			var rightBitmap:Bitmap = Filters.returnBlurBitmap(Figure.returnRect(deltaShadow, listHeight - (deltaShadow-1), 1,0,0x000000, 0.4, 0x000000));
			listContainer.addChild(botBitmap);
			listContainer.addChild(rightBitmap);
			botBitmap.y = listHeight-1;
			botBitmap.x = deltaShadow-1;
			rightBitmap.x = listWidth-1;
			rightBitmap.y = deltaShadow+1;
			listContainer.setChildIndex(botBitmap, 0);
			listContainer.setChildIndex(rightBitmap, 0);
		}
		
		private function LINK_DISPATCHED(e:Event):void{
			//trace(this + ": LINK DISPATCH STATUS");
			currentLinkStatus = e.target.dispatchStatus;
			super.dispatchEvent(new Event(Events.LINK_DISPATCH_STATUS));
			
		}
	}
	
}
