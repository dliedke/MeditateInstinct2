using Toybox.WatchUi as Ui;
using Toybox.Lang;
using Toybox.Graphics as Gfx;
using Toybox.Application as App;
using Toybox.Timer;

class MeditateView extends Ui.View {
	private var mMeditateModel;
	private var mMainDuationRenderer;
	
    function initialize(meditateModel) {
        View.initialize();
        me.mMeditateModel = meditateModel;
        me.mMainDuationRenderer = null;
        me.mElapsedTime = null; 
        me.mHrStatusText = null;
        me.mMeditateIcon = null;   
		me.iconsYOffset = App.getApp().getProperty("meditateActivityIconsYOffset");          
    }
    
    private var mElapsedTime;
    private var mHrStatusText;    
	private var mHrStatus;
	private var mHrvIcon;
	private var mHrvText;	
    private var mMeditateIcon;
    private var mIntervalAlertsRenderer;
	private var iconsYOffset;

    private function createMeditateText(color, font, xPos, yPos, justification) {
    	return new Ui.Text({
        	:text => "",
        	:font => font,
        	:color => color,
        	:justification =>justification,
        	:locX => xPos,
        	:locY => yPos
    	});
    }
    
    private static const TextFont = Gfx.FONT_XTINY;
    
    private function renderBackground(dc) {				        
        dc.setColor(Gfx.COLOR_TRANSPARENT, Gfx.COLOR_BLACK);        
        dc.clear();        
    }
    
    private function renderHrStatusLayout(dc) {
    	var xPosText = dc.getWidth() / 2;
    	var yPosText = getYPosOffsetFromCenter(dc, 1);
      	me.mHrStatusText = createMeditateText(Gfx.COLOR_WHITE, TextFont, xPosText + 3, yPosText + iconsYOffset, Gfx.TEXT_JUSTIFY_CENTER); 
      	
  	    var hrStatusX = App.getApp().getProperty("meditateActivityIconsXPos");
        var hrStatusY = getYPosOffsetFromCenter(dc, 1) + iconsYOffset; 
  	    me.mHrStatus = new ScreenPicker.Icon({        
        	:font => Gfx.FONT_XTINY,
        	:symbol => "HR:",
        	:color=>Graphics.COLOR_WHITE,
        	:xPos => hrStatusX,
        	:yPos => hrStatusY
        });
    }
    
    private function getYPosOffsetFromCenter(dc, lineOffset) {
    	return dc.getHeight() / 2 + lineOffset * dc.getFontHeight(TextFont);
    }
        
    function renderLayoutElapsedTime(dc) { 	
    	var xPosCenter = dc.getWidth() / 2;
    	var yPosCenter = getYPosOffsetFromCenter(dc, 0) + iconsYOffset;
    	me.mElapsedTime = createMeditateText(me.mMeditateModel.getColor(), TextFont, xPosCenter, yPosCenter, Gfx.TEXT_JUSTIFY_CENTER);
    }
                
    // Load your resources here
    function onLayout(dc) {   
        renderBackground(dc);   
        renderLayoutElapsedTime(dc);  
		        
        var durationArcRadius = dc.getWidth() / 2;
        var mainDurationArcWidth = (dc.getWidth() / 4) - 20;  // Circle width
        me.mMainDuationRenderer = new ElapsedDuationRenderer(me.mMeditateModel.getColor(), durationArcRadius, mainDurationArcWidth);

		// Initialize interval alerts		
		var intervalAlertsArcRadius = dc.getWidth() / 2;
		var intervalAlertsArcWidth = dc.getWidth() / 16;
		me.mIntervalAlertsRenderer = new IntervalAlertsRenderer(me.mMeditateModel.getSessionTime(), me.mMeditateModel.getRepeatIntervalAlerts(), intervalAlertsArcRadius, intervalAlertsArcWidth);    

        renderHrStatusLayout(dc);
    }
    
    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() {
    }
	
	private function formatHr(hr) {
		if (hr == null) {
			return "--";
		}
		else {
			return hr.toString();
		}
	}
		
	private const InvalidHeartRate = "--";
	
	private function formatHrv(hrv) {
		if (hrv == null) {
			return InvalidHeartRate;
		}
		else {
			return hrv.format("%3.0f");
		}
	}
	
    // Update the view
    function onUpdate(dc) {      
        View.onUpdate(dc);
        if (me.mMeditateIcon != null) {
        	mMeditateIcon.draw(dc);
        }
		
		var timeText = "Time: " + TimeFormatter.format(me.mMeditateModel.elapsedTime);
		var currentHr = me.mMeditateModel.currentHr;

		// Check if activity is paused, render the [Paused] text and hide HR metrics
		if (!me.mMeditateModel.isTimerRunning)  {
			timeText = Ui.loadResource(Rez.Strings.meditateActivityPaused);
			currentHr = null;
		}

		me.mElapsedTime.setText(timeText);	
		me.mElapsedTime.draw(dc);
                    
        var alarmTime = me.mMeditateModel.getSessionTime();
		me.mMainDuationRenderer.drawOverallElapsedTime(dc, me.mMeditateModel.elapsedTime, alarmTime);
		
		// Render interval alerts
		if (me.mIntervalAlertsRenderer != null) {
			me.mIntervalAlertsRenderer.drawRepeatIntervalAlerts(dc);
		}

		me.mHrStatusText.setText(me.formatHr(currentHr));
		me.mHrStatusText.draw(dc);        
     	me.mHrStatus.draw(dc);	       	
     
    }
    	
    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() {
    }

}
