package  {
	import flash.display.Sprite;
	
	public class Hero {
		private var line1:Line;
		private var line2:Line;
		
		private var yStart:int;
		private var yDist:int;
		private var xStart:int;
		private var xDist:int;
		private var speed:int;
		private var r:Sprite;
		private var curY:int;
		private var up:Boolean;
		private var down:Boolean;
		public function Hero(r:Sprite,x,y) {
			this.r=r;
			xStart=x;
			yStart = y;
			yDist = 50;
			xDist = 2;
			speed = 7;
			line1 = new Line(r,xStart,yStart-yDist,speed,xDist);
			line2 = new Line(r,xStart,yStart+yDist,speed,xDist);
			curY = yStart;
			up = false;
			down = false;
		}
		public function updateHero() {
			if(curY > yDist+speed && up) {
				curY -= speed;
				line1.increase();
				line2.increase();
			} else if(curY < 350 && down) {
				curY += speed;
				line1.decrease();
				line2.decrease();
			}
			line1.updateLine();
			line2.updateLine();
		}
		public function checkBrick(brick:Brick):Boolean {
			if(brick.x < xStart) {
				if(!brick.isColored()) {
					var collected:Boolean=false;
					if(brick.y < curY+yDist && brick.y > curY-yDist)
						collected=true;
					brick.changeColor(collected);
					GLOBAL.ss.updateScore(collected);
				} else if(brick.x < -10) {
					brick.cleanup();
					return true;
				}
			}
			return false;
		}
		public function cleanup() {
			line1.cleanup();
			line2.cleanup();
		}
		public function upPressed():void {
			up = true;
			//down = false;
		}
		public function downPressed():void {
			down = true;
			//up = false;
		}
		public function upReleased():void {
			up = false;
		}
		public function downReleased():void {
			down = false;
		}
	}
}