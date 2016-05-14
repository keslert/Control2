package  {
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.display.Stage;
	
	public class LevelDesign {
		
		private var r:Sprite;
		private var mc:Sprite;
		private var brick:Brick;
		private var bricks:Array;
		private var recycleBricks:Array;
		private var maxBricks:uint=0;
		public function LevelDesign(r:Sprite) {
			this.r = r;
			mc = new Sprite();
			this.r.addChild(mc);
			bricks = new Array();
			recycleBricks = new Array();
			createAllBricks();
			addMusic();
			startLevel();
		}
		
		public function startLevel():void {
			r.addEventListener(Event.ENTER_FRAME,updateLevel);
			var stage:Stage = r.stage;
			stage.focus = stage;
			if(GLOBAL.mouse) GLOBAL.hideMouse();
		}
		private function updateLevel(e:Event):void {
			for(var i=bricks.length-1;i>-1;i--) {
				brick = bricks[i];
				brick.updateBrick();
				if(GLOBAL.hero.checkBrick(brick)) {
					bricks.splice(i,1);
					recycleBricks.push(brick);
				}
			}
			GLOBAL.hero.updateHero();
		}
		public function addBlock(y:int,speed:int,num:int) {
			for(var i=0;i<num;i++) {
				if(recycleBricks.length>0) {
					brick = recycleBricks.pop();
					brick.recycleBrick(y+(i/2*int((Math.random()-.5)*3)),speed,i*int(Math.random()*10));
					bricks.push(brick);
				} else {
					brick = new Brick(r,y+(i*int((Math.random()-.5)*3)),speed,i*int(Math.random()*10));
					bricks.push(brick);
				}
			}
		}
		public function songEnd():void {
			GLOBAL.gui.playEnd();
			GLOBAL.hero.cleanup();
			GLOBAL.showMouse();
			r.removeEventListener(Event.ENTER_FRAME,updateLevel);
		}
		public function restart():void {
			GLOBAL.ss.restart();
			GLOBAL.gui.restart();
			GLOBAL.music.gotoAndPlay(1);
			startLevel();
		}
		private function createAllBricks():void {
			for(var i=0;i<190;i++) {
				brick = new Brick(r,0,0,-GLOBAL.stageW-15);
				recycleBricks.push(brick);
			}
		}
		private function addMusic():void {
			GLOBAL.music = new MC_Song1();
		}
	}
}
