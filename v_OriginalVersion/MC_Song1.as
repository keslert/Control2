package  {
	import flash.display.MovieClip;
	public class MC_Song1 extends MovieClip{

		public function MC_Song1() {
			// constructor code
		}
		public function addBlock(y:int,speed:int,num:int):void {
			GLOBAL.levelDesign.addBlock(y,speed,num);
		}
		public function songEnd():void {
			GLOBAL.levelDesign.songEnd();
		}
		public function restartSong():void {
			trace(GLOBAL.levelDesign);
			this.gotoAndPlay(1);
			trace(GLOBAL.levelDesign);
		}

	}
	
}
