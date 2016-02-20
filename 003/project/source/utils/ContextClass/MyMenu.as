package source.utils.ContextClass {
	import flash.ui.ContextMenu;
    import flash.ui.ContextMenuItem;
    import flash.ui.ContextMenuBuiltInItems;
    import flash.events.ContextMenuEvent;
 //   import flash.display.Sprite;
	public class MyMenu {
		private var myMenu:ContextMenu;
		private var ARR_MY_MENU:Array = new Array;
		private var ARR_MY_FUNCTION:Array = new Array;
		public function MyMenu(Obj:Object,arrMyMenu:Array,arrMyFunction:Array) {
			myMenu = new ContextMenu();
			ARR_MY_MENU = arrMyMenu;
			ARR_MY_FUNCTION = arrMyFunction;
			//myMenu.addEventListener(ContextMenuEvent.MENU_SELECT,myMenu_MENU_SELECT);
			Obj.contextMenu = myMenu;
			remItemsMyMenu();
			addMyMenuItems();
		}
		private function remItemsMyMenu():void{
			myMenu.hideBuiltInItems();
		}
		private function addMyMenuItems():void{
			var MY_MENU_ITEM:Array = new Array;
			var i:int = new int;
			for(i=0;i<ARR_MY_MENU.length;i++){
				MY_MENU_ITEM[i] = new ContextMenuItem(ARR_MY_MENU[i]);
           		myMenu.customItems.push(MY_MENU_ITEM[i]);
           		MY_MENU_ITEM[i].addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,ARR_MY_FUNCTION[i]);
			}
		}
	}
}