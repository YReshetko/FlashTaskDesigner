package source.Task.TaskObjects.CharisProgram.CharisSystem {
	import flash.display.Sprite;
	import flash.display.MovieClip;
	
	public class SchemSector extends SystemSector{
		private var rotations:Array = [{right:true, left:false, up:false, down:false, rotation:0},  // right
									   {right:true, left:false, up:true, down:false, rotation:315}, // rightUp
									   {right:false, left:false, up:true, down:false, rotation:270},// up
									   {right:false, left:true, up:true, down:false, rotation:225}, // leftUp
									   {right:false, left:true, up:false, down:false, rotation:180},// left
									   {right:false, left:true, up:false, down:true, rotation:135}, // leftDown
									   {right:false, left:false, up:false, down:true, rotation:90}, // down
									   {right:true, left:false, up:false, down:true, rotation:45}]; // rightDown
		
		private var target:*;
		public function SchemSector(size:Number, selectColor:uint=0x0000FF, defaultColor:uint=0xFFFFFF) {
			super(size, selectColor, defaultColor);
		}
		
		public function addDrawArrow(value:Object):void{
			var rotation:int = getRotation(value);
			addArrow(new DrawArrow(), rotation);
		}
		public function addJumpArrow(value:Object):void{
			var rotation:int = getRotation(value);
			addArrow(new JumpArrow(), rotation);
		}
		public function addCircle():void{
			addArrow(new CircleArrow(), 0);
		}
		public function addToZero():void{
			addArrow(new ToZeroArrow(), 0);
		}
		public function addBar():void{
			addArrow(new BarArrow(), 0);
		}
		public function addWorm():void{
			addArrow(new WormArrow(), 0);
		}
		public function addTurtle():void{
			addArrow(new TurtleArrow(), 0);
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
					   return rotations[i].rotation;
				   }
			}
			return 0;
		}

	}
	
}
