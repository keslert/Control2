package  {
	
	public class scoringSystem {
		private var score:int;
		private var highestStreak;
		private var curStreak;
		private var caught:int;
		private var miss:int;
		private var points:int;
		
		public function scoringSystem() {
			score=0;
			highestStreak=0;
			curStreak=0;
			caught=0;
			miss=0;
			points = 50;
			
		}
		public function updateScore(b:Boolean):void {
			if(b) hit();
			else missed();
			GLOBAL.gui.setScore(score);
			GLOBAL.gui.setPercentage(getPercentage());
			GLOBAL.gui.setCurrentStreak(curStreak);
		}
		private function hit(){
			caught++;
			curStreak++;
			if(curStreak==50)GLOBAL.gui.bonus(50);
			else if(curStreak==100) GLOBAL.gui.bonus(100);
			else if(curStreak==150) GLOBAL.gui.bonus(150);
			else if(curStreak==200) GLOBAL.gui.bonus(200);
			if(curStreak > 199) {
				score+=points*8;
			} else if(curStreak > 149) {
				score+=points*4;
			} else if(curStreak > 99) {
				score+=points*3;
			} else if(curStreak > 49) {
				score+=points*2;
			} else {
				score+=points;
			}
		}
		private function missed() {
			miss++;
			if(curStreak > highestStreak) highestStreak = curStreak;
			if(curStreak>0) GLOBAL.gui.playMiss();
			curStreak = 0;
		}
		public function getPercentage():int {
			return 100*caught/(caught+miss);
		}
		public function getScore():int {
			return score;
		}
		public function getMissed():int {
			return miss;
		}
		public function getHit():int {
			return caught;
		}
		public function getBestStreak():int {
			if(curStreak > highestStreak) highestStreak = curStreak;
			return highestStreak;
		}
		public function getFinalScore():int {
			return int(score*(getPercentage()/100));
		}
		public function restart():void {
			score=0;
			highestStreak=0;
			curStreak=0;
			caught=0;
			updateScore(false);
			miss=0;
		}
	}
}
