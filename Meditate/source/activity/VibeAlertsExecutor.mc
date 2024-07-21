using Toybox.Attention;
using Toybox.Timer;

class VibeAlertsExecutor {
	function initialize(meditateModel) {
		me.mMeditateModel = meditateModel;
		me.mRepeatIntervalAlerts = me.mMeditateModel.getRepeatIntervalAlerts();	
		me.mIsFinalAlertPending = true;
	}
	
	private var mIsFinalAlertPending;
	private var mMeditateModel;
	private var mRepeatIntervalAlerts;

	function firePendingAlerts() {
		if (me.mIsFinalAlertPending == true) {
			me.fireIfRequiredFinalAlert();
			me.fireIfRequiredRepeatIntervalAlerts();
		}
	}
	
	private function fireIfRequiredFinalAlert() {
        if (me.mMeditateModel.elapsedTime >= me.mMeditateModel.getSessionTime()) {
            // Vibrate long continuous
            Attention.vibrate(getLongContinuous());

            // Start a timer for 2 seconds
            var mTimer = new Timer.Timer();
            mTimer.start(method(:onTimerComplete), 2000, false);

            me.mIsFinalAlertPending = false;
        }
    }

    public function onTimerComplete() {
        // Vibrate long continuous again
        Attention.vibrate(getLongContinuous());

        me.mIsFinalAlertPending = false;
    }

	private function fireIfRequiredRepeatIntervalAlerts() {
		for (var i = 0; i < me.mRepeatIntervalAlerts.size(); i++) {
			if (me.mRepeatIntervalAlerts[i].time > 0 && me.mMeditateModel.elapsedTime % me.mRepeatIntervalAlerts[i].time == 0) {
	    		
				// Vibrate blip
				Attention.vibrate(getBlip());
	    	}	
		}

		// Warn user 2min before ending the session
		//if (me.mMeditateModel.getSessionTime() - me.mMeditateModel.elapsedTime == 120) {
			// Vibrate blip
		//	Attention.vibrate(getBlip());
		//}
		
	}

	private static function getLongContinuous() {
		return [
			new Attention.VibeProfile(100, 3000)
		];
	}

	private static function getBlip() {
		return [
	        new Attention.VibeProfile(100, 50)
		];
	}
}