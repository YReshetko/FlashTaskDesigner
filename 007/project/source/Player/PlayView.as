package source.Player {
	import flash.display.Sprite;
	import flash.events.Event;
	import source.Utilit.Scene3D.Scene3DBuild;
	import source.Utilit.CubePositioner;
	import source.Player.Objects3D.MyBox;
	import flash.events.MouseEvent;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import flash.events.EventDispatcher;
	import alternativa.engine3d.containers.ConflictContainer;
	import source.Player.DopClass.PictureFrame;
	
	public class PlayView extends Scene3DBuild{
		public static const KEY_DOWN_LEFT:String = 'keyDownLeft';
		public static const KEY_DOWN_RIGHT:String = 'keyDownRight';
		public static const KEY_DOWN_TOP:String = 'keyDownTop';
		public static const KEY_DOWN_BOTTOM:String = 'keyDownBottom';
		
		public static const ROTATION_COMPLATE:String = 'rotationComplate';
		
		private var mainSprite:Sprite;
		private var myModel:PlayModel;
		
		private var arrCube:Array = new Array;
		private var arrCubeCont:Array = new Array;
		
		private var currentBoxID:int = -1;
		
		private var typeRotation:String;
		private var currentIter:int = 0;
		private var currentOS:String = "X";
		
		private var currentVector:Array = new Array;
		private var browsPictBut:Loup = new Loup();
		
		private var pictureFrame:PictureFrame = new PictureFrame();
		
		public function PlayView(myModel:PlayModel, mainSprite:Sprite) {
			super(730, 495);
			super.setCameraPosition(0, -100, 300);
			this.mainSprite = mainSprite;
			this.mainSprite.addChild(this);
			this.mainSprite.addChild(pictureFrame);
			pictureFrame.visible = false;
			this.mainSprite.addChild(browsPictBut);
			browsPictBut.addEventListener(MouseEvent.MOUSE_DOWN, BROWS_PICT_MOUSE_DOWN);
			this.myModel = myModel;
			addModelHandler();
			addSuperHandler();
		}
		private function addModelHandler(){
			myModel.addEventListener(PlayModel.BUILD_COMPLATE, BUILD_SCENE);
			myModel.addEventListener(PlayModel.NEW_ROTATION, MY_MODEL_ROTATION);
		}
		private function addSuperHandler(){
			super.addEventListener(MouseEvent.CLICK, SCENE_CLICK);
			super.addEventListener(KeyboardEvent.KEY_DOWN, SCENE_KEYBOARD_KEY_DOWN);
			super.focusRect = false;
		}
		private function BUILD_SCENE(e:Event){
			var getModelBuild:Array = myModel.getBuild();
			var arrStartPotation:Array = getModelBuild[3];
			var i:int;
			CubePositioner.setCubePosition(getModelBuild, arrCubeCont, arrCube, super.getCubeContainer(), 50, MyBox);
			for(i=0;i<arrCubeCont.length;i++){
				arrCubeCont[i].rotationX = (Math.PI/2)*arrStartPotation[i][0];
				arrCubeCont[i].rotationY = (Math.PI/2)*arrStartPotation[i][1];
				arrCubeCont[i].rotationZ = (Math.PI/2)*arrStartPotation[i][2];
			}
			switch(myModel.getBuild()[1]){
				case 1:
					super.setCameraPosition(0, -100, 215);
				break;
				case 2:
					super.setCameraPosition(0, -100, 230);
				break;
				case 3:
					super.setCameraPosition(0, -100, 250);
				break;
				case 4:
					super.setCameraPosition(0, -100, 270);
				break;
				case 5:
					super.setCameraPosition(0, -100, 290);
				break;
			}
			initBox();
			super.rendering();
		}
		private function initBox(){
			var i:int;
			for(i=0;i<arrCube.length;i++){
				arrCube[i].addEventListener(MouseEvent.CLICK, BOX_CLICK);
			}
		}
		private function BOX_CLICK(e:MouseEvent){
			var i:int;
			for(i=0;i<arrCube.length;i++){
				if(arrCube[i].getActive()){
					if(i!=currentBoxID){
						//trace("Class "+this+": Active MyBox["+i+"]");
						arrCube[i].resetActive();
						currentBoxID = i;
						stage.focus = null;
						//trace("Class "+this+": Z = "+ arrCube[i].z);
						stage.addEventListener(Event.ENTER_FRAME, BOX_ENTER_FARME);
					}else{
						arrCube[i].resetActive();
						currentBoxID = -1;
						stage.focus = null;
						//trace("Class "+this+": Z = "+ arrCube[i].z);
						stage.addEventListener(Event.ENTER_FRAME, BOX_ENTER_FARME);
					}
					return;
				}
			}
		}
		private function BOX_ENTER_FARME(e:Event){
			var flag:Boolean = boxChange();
			if(currentBoxID != -1){
				if(arrCubeCont[currentBoxID].z == 55 && flag){
					stage.removeEventListener(Event.ENTER_FRAME, BOX_ENTER_FARME);
					stage.focus = this;
				}
			}else{
				if(flag){
					stage.removeEventListener(Event.ENTER_FRAME, BOX_ENTER_FARME);
				}
			}
			rendering();
		}
		private function boxChange():Boolean{
			var flag:Boolean = true;
			var i:int;
			//trace("Class "+this+": currentBoxID = "+currentBoxID);
			for(i=0;i<arrCubeCont.length;i++){
				if(i == currentBoxID){
					if(arrCubeCont[i].z<55){
						//trace("Class "+this+": UP");
						arrCubeCont[i].z += 5;
					}
				}else{
					if(arrCubeCont[i].z>0){
						//trace("Class "+this+": DOWN");
						flag = false;
						arrCubeCont[i].z -= 5;
					}
				}
			}
			return flag;
		}
		private function SCENE_CLICK(e:MouseEvent){
			if(currentBoxID != -1){
				if(arrCubeCont[currentBoxID].z == 55){
					stage.focus = this;
				}else{
					stage.focus = null;
				}
			}else{
				stage.focus = null;
			}
		}	
		private function SCENE_KEYBOARD_KEY_DOWN(e:KeyboardEvent){
			//trace("Class "+this+": KeyDown = "+e.keyCode);
			//trace("Class "+this+": rotationX = "+arrCubeCont[currentBoxID].rotationX/Math.PI+" rotationY = "+arrCubeCont[currentBoxID].rotationY/Math.PI+" rotationZ = "+arrCubeCont[currentBoxID].rotationZ/Math.PI);
			super.removeEventListener(KeyboardEvent.KEY_DOWN, SCENE_KEYBOARD_KEY_DOWN);
			stage.focus = null;
			switch(e.keyCode){
				case 37:	// Влево
					
					super.dispatchEvent(new Event(KEY_DOWN_LEFT));
				break;
				case 38:	// Вверх
					if(currentOS == "X") currentOS = "Y";
					else currentOS = "X"
					super.dispatchEvent(new Event(KEY_DOWN_TOP));
				break;
				case 39:	// Вправо
					
					super.dispatchEvent(new Event(KEY_DOWN_RIGHT));
				break;
				case 40:	// Вниз
					if(currentOS == "X") currentOS = "Y";
					else currentOS = "X"
					super.dispatchEvent(new Event(KEY_DOWN_BOTTOM));
				break;
			}
		}
		public function getCurrentBoxID():int{
			return currentBoxID;
		}
		private function MY_MODEL_ROTATION(e:Event){
			var objRotation:Object = myModel.getRotation();
			typeRotation = objRotation.typeRotation;
			currentBoxID = objRotation.ID;
			currentIter = -1;
			stage.addEventListener(Event.ENTER_FRAME, BOX_ROTATION);
		}
		private function BOX_ROTATION(e:Event){
			++currentIter;
			if(currentIter < 6){
				switch(typeRotation){
					case 'left':
						arrCubeCont[currentBoxID].rotationZ -= Math.PI/12;
					break;
					case 'right':
						arrCubeCont[currentBoxID].rotationZ += Math.PI/12;
					break;
					case 'top':
							if(currentOS == "X") arrCubeCont[currentBoxID].rotationX -= Math.PI/12;
							else arrCubeCont[currentBoxID].rotationY -= Math.PI/12;
					break;
					case 'bottom':
						if(currentOS == "X") arrCubeCont[currentBoxID].rotationX += Math.PI/12;
							else arrCubeCont[currentBoxID].rotationY += Math.PI/12;
					break;
				}
				
			}else{
				stage.removeEventListener(Event.ENTER_FRAME, BOX_ROTATION);
				var R_X:int = Math.round(arrCubeCont[currentBoxID].rotationX/(Math.PI/2));
				var R_Y:int = Math.round(arrCubeCont[currentBoxID].rotationY/(Math.PI/2));
				var R_Z:int = Math.round(arrCubeCont[currentBoxID].rotationZ/(Math.PI/2));
				//trace("++++++++++++++++++++++++++++++++")
				//trace(R_X, R_Y, R_Z);
				switch(R_X){
					case 4:
					arrCubeCont[currentBoxID].rotationX = 0;
					R_X = 0;
					break;
					case -1:
					arrCubeCont[currentBoxID].rotationX = (3*Math.PI)/2;
					R_X = 3;
					break;
				}
				switch(R_Y){
					case 4:
					arrCubeCont[currentBoxID].rotationY = 0;
					R_Y = 0;
					break;
					case -1:
					arrCubeCont[currentBoxID].rotationY = (3*Math.PI)/2;
					R_Y = 3;
					break;
				}
				switch(R_Z){
					case 4:
					arrCubeCont[currentBoxID].rotationZ = 0;
					R_Z = 0;
					break;
					case -1:
					arrCubeCont[currentBoxID].rotationZ = (3*Math.PI)/2;
					R_Z = 3;
					break;
				}
				//trace(R_X, R_Y, R_Z);
				currentVector = [R_X, R_Y, R_Z];
				super.dispatchEvent(new Event(ROTATION_COMPLATE));
			}
			super.rendering();
		}
		public function getCurrentVector():Object{
			var outObj:Object = new Object();
			outObj._ID = currentBoxID;
			outObj._vector = currentVector;
			return outObj;
		}
		public function continueAnimation(){
			stage.focus = this;
			this.addEventListener(KeyboardEvent.KEY_DOWN, SCENE_KEYBOARD_KEY_DOWN);
		}
		public function pictCreated(markID:int){
			pictureFrame.setMark(markID);
			currentBoxID = -1;
			stage.addEventListener(Event.ENTER_FRAME, BOX_STAY_DOWN);
		}
		private function BOX_STAY_DOWN(e:Event){
			var flag:Boolean = boxChange();
			if(flag){
				stage.removeEventListener(Event.ENTER_FRAME, BOX_STAY_DOWN);
				continueAnimation();
			}
			super.rendering();
		}
		private function BROWS_PICT_MOUSE_DOWN(e:MouseEvent){
			trace("BUT");
			pictureFrame.visible = !pictureFrame.visible;
		}
		public function setPictureFrame(arr:Array){
			pictureFrame.addPict(arr);
		}
	}
	
}
