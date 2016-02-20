package source.EnvInterface.WorkScene.DLCourses {
	import flash.display.Sprite;
	import source.EnvInterface.EnvPanel.Panel;
	import flash.events.Event;
	
	public class CourseController extends Sprite{
		private var DLpanel:Panel;
		private var MYpanel:Panel
		private var arrCours:Array;
		private var arrMyCourse:Array;
		public function CourseController(value:Object, DLpanel:Panel, MYpanel:Panel) {
			super();
			this.DLpanel = DLpanel;
			this.MYpanel = MYpanel
			this.DLpanel.mainContainer.addChild(super);
			initDLCoursees(value);
			arrMyCourse = new Array();
		}
			
		private function initDLCoursees(value:Object):void{
			arrCours = new Array();
			var ID:int;
			for(var key:Object in value){
				ID = arrCours.length;
				arrCours.push(new DLCourse(key.toString(), value[key].toString()));
				super.addChild(arrCours[ID]);
				arrCours[ID].y = ID*(arrCours[ID].height+2) + 2;
				arrCours[ID].addEventListener(DLCourse.UPDATE_PANEL, UPDATE_PANEL);
				arrCours[ID].addEventListener(DLCourse.NEW_COURSE, SAVE_NEW_COURSE);
			}
		}
		private function UPDATE_PANEL(event:Event):void{
			var i:int;
			var l:int;
			l = arrCours.length;
			for(i=1;i<l;i++){
				arrCours[i].y = arrCours[i-1].y + arrCours[i-1].height + 2;
			}
			DLpanel.updatePanel();
		}
		private function SAVE_NEW_COURSE(event:Event):void{
			var arr:Array = event.target.newCourse;
			var ID:int;
			ID = arrMyCourse.length;
			arrMyCourse.push(new MYCourse(arr));
			this.MYpanel.mainContainer.addChild(arrMyCourse[ID]);
			arrMyCourse[ID].addEventListener(MYCourse.UPDATE_PANEL, MY_UPDATE_PANEL);
			MY_UPDATE_PANEL(null);
		}
		private function MY_UPDATE_PANEL(event:Event):void{
			var i:int;
			var l:int;
			l = arrMyCourse.length;
			for(i=1;i<l;i++){
				arrMyCourse[i].y = arrMyCourse[i-1].y + arrMyCourse[i-1].height + 2;
			}
			MYpanel.updatePanel();
		}
		
		
		public function get saveTasks():Array{
			var outArray:Array = new Array();
			var arr:Array;
			var i:int;
			var l:int;
			var j:int;
			l = arrMyCourse.length;
			for(i=0;i<l;i++){
				arr = arrMyCourse[i].myTasks;
				for(j=0;j<arr.length;j++){
					outArray.push(arr[j]);
				}
			}
			return outArray;
		}
	}
	
}
