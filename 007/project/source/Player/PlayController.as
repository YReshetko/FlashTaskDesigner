package source.Player {
	import flash.display.Sprite;
	import flash.events.Event;
	
	import source.Player.LoaderPackage.UrlLoader;
	import source.Utilit.CuterPict;
	//import source.Utilit.RotationShem;
	import source.Utilit.Checker;
	import flash.utils.ByteArray;
	
	public class PlayController extends Sprite{
		private var urlPath:String;
		private var numCol:int;
		private var numLin:int;
		
		private var mainSprite:Sprite;
		
		private var myLoader:UrlLoader;
		
		private var imageName:Array = new Array()
		private var imageArr:Array = new Array('','','','','','');
		
		private var currentID:int = 0;
		
		private var combinePict:Array = [false, false, false, false, false, false];
		
		private var myModel:PlayModel;
		private var myView:PlayView;
		
		private var arrContent:Array;
		public function PlayController(mainSprite:Sprite) {
			super();
			this.mainSprite = mainSprite;
			buildModel();
			myViewHandler();
			myLoader = new UrlLoader();
			myLoader.addEventListener(UrlLoader.LOAD_COMPLATE, myLoader_LOAD_COMPLATE);
			myLoader.addEventListener(UrlLoader.LOAD_ERROR, myLoader_LOAD_ERROR);
		}
		private function buildModel(){
			myModel = new PlayModel();
			myView = new PlayView(myModel,mainSprite);
		}
		private function myViewHandler(){
			myView.addEventListener(PlayView.KEY_DOWN_LEFT, myView_LEFT);
			myView.addEventListener(PlayView.KEY_DOWN_RIGHT, myView_RIGHT);
			myView.addEventListener(PlayView.KEY_DOWN_TOP, myView_TOP);
			myView.addEventListener(PlayView.KEY_DOWN_BOTTOM, myView_BOTTOM);
		}
		
		
		public function setSettings(Path:String, settXML:XMLList, content:Array){
			arrContent = content;
			if(Path!="")urlPath = Path+"/";
			else urlPath = "";
			numCol = parseInt(settXML.COLCOLUMN);
			numLin = parseInt(settXML.COLLINE)
			for each(var key:XML in settXML..IMAGE){
				imageName.push([key.@ID, key]);
			}
			myLoader.LoadPict(getImage(imageName[currentID][1]));
		}
		private function getImage(name:String):ByteArray{
			var i,l:int;
			l = arrContent.length;
			for(i=0;i<l;i++){
				if(arrContent[i].name == name) return arrContent[i].byteArray;
			}
			return null;
		}
		private function myLoader_LOAD_COMPLATE(e:Event){
			imageArr[imageName[currentID][0]] = myLoader.getContent();
			myLoader_LOAD_ERROR();
		}
		private function myLoader_LOAD_ERROR(e:Event = null):void{
			if(currentID == imageName.length-1) {
				allLoadComplate();
				return
			}
			++currentID;
			myLoader.LoadPict(getImage(imageName[currentID][1]));
		}
		
		private function allLoadComplate(){
			myView.setPictureFrame(imageArr);
			trace(imageArr);
			var outArr:Array = new Array;
			var promArr:Array;
			var i,j,k:int;
			var ID:int = 0;
			for(i=0;i<numCol;i++){
				for(j=0;j<numLin;j++){
					outArr.push(new Array);
				}
			}
			for(k=0;k<imageArr.length;k++){
				if(imageArr[k] == ""){
					combinePict[k] = true;
					for(i=0;i<outArr.length;i++){
						outArr[i].push(null);
					}
				}else{
					promArr = CuterPict.cutPict(imageArr[k], numCol, numLin);
					for(i=0;i<outArr.length;i++){
						outArr[i].push(promArr[i]);
					}
				}
			}
			myModel.setBuild(numCol, numLin, outArr);
		}
		private function myView_LEFT(e:Event){
			sendTransPosition('left');
		}
		private function myView_RIGHT(e:Event){
			sendTransPosition('right');
		}
		private function myView_TOP(e:Event){
			sendTransPosition('top');
		}
		private function myView_BOTTOM(e:Event){
			sendTransPosition('bottom');
		}
		private function sendTransPosition(type:String){
			var ID:int = myView.getCurrentBoxID();
			myView.addEventListener(PlayView.ROTATION_COMPLATE, MY_VIEW_ROTATION_COMPLATE);
			myModel.setRotation(ID, type);
			
		}
		private function MY_VIEW_ROTATION_COMPLATE(e:Event){
			var inVector:Object = myView.getCurrentVector();
			myModel.setPosition(inVector._ID, inVector._vector);
			
			var makeCheck:Object = Checker.checkCoincid(myModel.getModel());
			if(makeCheck.flag && !combinePict[makeCheck.ID]){
				trace("СЛОЖЕНА КАРТИНКА ID = "+makeCheck.ID);
				combinePict[makeCheck.ID] = true;
				myView.pictCreated(makeCheck.ID);
			}else{
				myView.continueAnimation();
			}
		}
		public function getAnswer():Boolean{
			var flag:Boolean = true;
			var i:int;
			for(i=0;i<combinePict.length;i++){
				if(!combinePict[i]){
					flag = false;
				}
			}
			return flag;
		}
	}
	
}
