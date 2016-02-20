package source.BlockOfTask.Task.TaskObjects.CharisProgram.CharisSystem {
	import flash.display.Sprite;
	import flash.display.MovieClip;
	
	public class SchemSector extends SystemSector{
		private var rotations:Array = [{right:true,  left:false, up:false, down:false, rotation:0,   partName:"RightButton"    },  // right
									   {right:true,  left:false, up:true,  down:false, rotation:315, partName:"RightUpButton"  },  // rightUp
									   {right:false, left:false, up:true,  down:false, rotation:270, partName:"UpButton"       },  // up
									   {right:false, left:true,  up:true,  down:false, rotation:225, partName:"LeftUpButton"   },  // leftUp
									   {right:false, left:true,  up:false, down:false, rotation:180, partName:"LeftButton"     },  // left
									   {right:false, left:true,  up:false, down:true,  rotation:135, partName:"LeftDownButton" },  // leftDown
									   {right:false, left:false, up:false, down:true,  rotation:90,  partName:"DownButton"	   },  // down
									   {right:true,  left:false, up:false, down:true,  rotation:45,  partName:"RightDownButton"}]; // rightDown
		
		private var target:*;
		private var type:String = "";
		private var buttonName:String = "";
		private var num:int = -1;
		public function SchemSector(size:Number, selectColor:uint=0x0000FF, defaultColor:uint=0xFFFFFF) {
			super(size, selectColor, defaultColor);
		}
		
		public function addDrawArrow(value:Object):void{
			buttonName = "Charis";
			var rotation:int = getRotation(value);
			addArrow(new DrawArrow(), rotation);
			type = "DrawArrow";
			num = rotation;
		}
		public function addJumpArrow(value:Object):void{
			buttonName = "CharisJump";
			var rotation:int = getRotation(value);
			addArrow(new JumpArrow(), rotation);
			type = "JumpArrow";
			num = rotation;
		}
		public function addCircle():void{
			buttonName = "CharisCircleButton";
			addArrow(new CircleArrow(), 0);
			type = "CircleArrow";
			num = 0;
		}
		public function addToZero():void{
			buttonName = "CharisJumpZeroButton";
			addArrow(new ToZeroArrow(), 0);
			type = "ToZeroArrow";
			num = 0;
		}
		public function addBar():void{
			buttonName = "CharisFillButton";
			addArrow(new BarArrow(), 0);
			type = "BarArrow";
			num = 0;
		}
		public function addWorm():void{
			buttonName = "CharisWormTortue";
			addArrow(new WormArrow(), 0);
			type = "WormArrow";
			num = 0;
		}
		public function addTurtle():void{
			buttonName = "CharisWormTortue";
			addArrow(new TurtleArrow(), 0);
			type = "TurtleArrow";
			num = 0;
		}
		
		override public function clearConnections():void{
			removeTarget();
		}
		
		private function addArrow(object:*, rotation:int):void{
			removeTarget();
			target = object;
			//(target as MovieClip).width = super.width*0.85;
			
			var scale:Number = (super.width*0.85)/(target as MovieClip).width;
			(target as MovieClip).scaleX = scale;
			(target as MovieClip).scaleY = scale;
			
			
			(target as MovieClip).rotation = rotation;
			var _x:Number;
			var _y:Number;
			
			_x = super.width/2;
			_y = super.height/2;
			super.addChild(target as MovieClip);
			
			(target as MovieClip).x = _x;
			(target as MovieClip).y = _y;
		}
		private function removeTarget():void{
			if(target!=null){
				if(super.contains(target)){
					super.removeChild(target);
				}
				target = null;
			}
			type = "";
			num = -1;
		}
		
		private function getRotation(value:Object):int{
			var i:int;
			var l:int;
			l = rotations.length;
			for(i=0;i<l;i++){
				if(value.right == rotations[i].right&&
				   value.left == rotations[i].left&&
				   value.up == rotations[i].up&&
				   value.down == rotations[i].down){
					   buttonName = buttonName + rotations[i].partName;
					   return rotations[i].rotation;
				   }
			}
			return 0;
		}
		
		override public function equal(value:SystemSector):Boolean{
			var obj:SchemSector = (value as SchemSector);
			return (type == obj.type)&&(num == obj.num);
		}
		
		public function get button():String{
			return buttonName;
		}

	}
	
}
