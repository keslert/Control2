package  {
	import flash.display.MovieClip;
	public class MC_Song1 extends MovieClip{

		private var s:String;
		public function MC_Song1() {
			s="points=[\n";
		}
		public function addBlock(y:int,speed:int,num:int):void {
			s+="["+this.currentFrame+","+y+","+num+"],\n";
			GLOBAL.levelDesign.addBlock(y,speed,num);
		}
		public function songEnd():void {
			trace(s);
			GLOBAL.levelDesign.songEnd();
		}
		public function restartSong():void {
			trace(GLOBAL.levelDesign);
			this.gotoAndPlay(1);
			trace(GLOBAL.levelDesign);
		}

	}
	
}
