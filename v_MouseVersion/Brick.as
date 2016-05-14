package  {
	import flash.display.Sprite;
	import flash.display.Graphics;
	
	public class Brick extends Sprite {
		private var r:Sprite;
		private var speed:int;
		private var radius:int;
		private var colored:Boolean;
		
		public function Brick(r:Sprite,y:int,speed:int,delay:int) {
			this.r = r;
			this.r.addChild(this);
			this.speed = speed;
			this.y = y;
			this.x = GLOBAL.stageW+delay;
			radius = int(Math.random()*5)+5;
			colored = false;
			drawBrick();
		}
		private function drawBrick() {
			this.graphics.lineStyle(3,int(GLOBAL.brickColor),.3);
			this.graphics.drawRect(-radius,-radius,radius*2,radius*2);
			this.cacheAsBitmap=true;
			//this.graphics.drawCircle(0,0,radius);
		}
		public function changeColor(b:Boolean) {
			this.graphics.clear();
			if(b) this.graphics.lineStyle(3,0x0099FF,.3);
			else  this.graphics.lineStyle(3,0x990000,.3);
			
			this.graphics.drawRect(-radius,-radius,radius*2,radius*2);
			colored = true;
		}
		public function recycleBrick(y:int,speed:int,delay:int) {
			this.graphics.clear();
			this.speed = speed;
			this.y = y;
			this.x = GLOBAL.stageW+delay;
			radius = int(Math.random()*5)+3;
			colored = false;
			drawBrick();
		}
		public function cleanup():void {
			//ANY CLEANUP?
		}
		public function updateBrick() {
			this.x-=speed;
		}
		public function isColored():Boolean {
			return colored;
		}
	}
}
