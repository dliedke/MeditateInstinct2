using Toybox.ActivityRecording;

module HrvAlgorithms {
	class FitSessionSpec {
		
		private static const SUB_SPORT_BREATHWORKS = 62;
		
		static function createCardio(sessionName) {
			return {
                 :name => sessionName,                              
                 :sport => ActivityRecording.SPORT_TRAINING,      
                 :subSport => SUB_SPORT_BREATHWORKS
                };
		}
	}
}