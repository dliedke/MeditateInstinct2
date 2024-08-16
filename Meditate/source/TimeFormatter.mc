using Toybox.Lang;

class TimeFormatter {
	static function format(timeInSec) {		
		var timeCalc = timeInSec;
		var seconds = timeCalc % 60;
		timeCalc /= 60;
		var minutes = timeCalc % 60;
		timeCalc /= 60;
		var hours = timeCalc % 24;
		
		var formattedTime = Lang.format("$1$:$2$:$3$", [hours.format("%02d"), minutes.format("%02d"), seconds.format("%02d")]);
		return formattedTime;
	}

	static function formatHours(timeInSec) {		

		var formattedTime;
		
		if (timeInSec == 60 * 60) {
        	formattedTime = "1 hour";
		} else if (timeInSec == 90 * 60) {
			formattedTime = "1.5 hours";
		} else if (timeInSec == 120 * 60) {
			formattedTime = "2 hours";
		}
		
		return formattedTime;
	}

	static function formatMinutes(timeInSec) {		
		var timeCalc = timeInSec;
		var seconds = timeCalc % 60;
		timeCalc /= 60;
		var minutes = timeCalc % 60;
		timeCalc /= 60;
		var hours = timeCalc % 24;
		
		var formattedTime = Lang.format("$1$ Minutes", [minutes.format("%02d")]);
		return formattedTime;
	}

	static function formatSeconds(timeInSec) {		
		var timeCalc = timeInSec;
		var seconds = timeCalc % 60;
		timeCalc /= 60;
		var minutes = timeCalc % 60;
		timeCalc /= 60;
		var hours = timeCalc % 24;
		
		var formattedTime = Lang.format("$1$ Seconds", [seconds.format("%02d")]);
		return formattedTime;
	}
}