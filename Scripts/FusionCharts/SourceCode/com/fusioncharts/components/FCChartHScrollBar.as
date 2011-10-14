/**
 * @class FCChartHScrollBar
 * @author InfoSoft Global (P) Ltd. www.InfoSoftGlobal.com
 * @version 3.0
 *
 * Copyright (C) InfoSoft Global Pvt. Ltd. 2005-2006
 * Low foot print & no-frills horizontal Scroll Bar class that enables 
 * scrolling of Charts. 
 * This is a chart specific scroll bar and therefore uses a reference
 * movie clip to scroll the content. This is because of the x-axis labels or data
 * value textboxes on the chart. When placed at 0 (x), they extend to the left,
 * or when placed at max (x), they extend to the right, thereby increasing the total
 * width of the content MC, which in turn leads to additional space on left/right with
 * a generic scroll bar component. Here, we do not use the width of the content MC.
 * Instead, we use the width of a reference MC, which helps us keep the width of the 
 * scroll content to the figure we want. Anything that's "hanging" outside is cropped
 * during scrolling.
 * We extend the IComponent interface, so as to keep the APIs of 
 * all FusionCharts components same.
 * You can change the cosmetics of this scroll bar using a single color.
 * To use a scroll bar, just instantiate it with the properties and call
 * invalidate().
 * To set color, use the setColor() method.
 * If you want to set the X and Y Position of scroll bar, you can directly
 * do in your parent code, by setting the x/y position of scrollContainerMC.
 * This component dispatches the following events:
 * - click - When the scroll face or buttons are clicked (before movement).
 * - change - When the content area has changed.
*/
//Import necessary classes
//Color extensions - to get variations of colors
import com.fusioncharts.extensions.ColorExt;
//Utilities
import com.fusioncharts.helper.Utils;
//Event Dispatcher - as we'll dispatch various events when required.
import mx.events.EventDispatcher;
//Delegation
import mx.utils.Delegate;
//Class
class com.fusioncharts.components.FCChartHScrollBar extends MovieClip implements com.fusioncharts.components.IComponent {
	//What state the component is in - enabled or disabled.
	//By default, at start, we keep the component enabled (true)
	private var state:Boolean;
	//Content Movie clip which we've to scroll.
	private var contentMC:MovieClip;
	//Movie clip which will contain sub-movieclips that represent
	//scroll bar components.
	private var scrollMC:MovieClip;
	//Movie clip that acts as mask for the content, to enable scroll.
	private var maskMC:MovieClip;
	//Width and height required for scroll bar
	private var scrollWidth:Number;
	private var scrollHeight:Number;
	//Movie clip reference which will give us mask pane width & height
	private var refMaskMC:MovieClip;
	//Object to store various cosmetic properties
	private var cosmetics:Object;
	//Current Color of the scroll bar
	private var scrollColor:String;
	//Various variables that'll store reference to movie clips
	//Reference to scroll bar face
	private var faceMC:MovieClip;
	//Reference to face Click Clip
	private var faceClickMC:MovieClip;
	//Reference to track movieclip
	private var trackMC:MovieClip;
	//Track click movie clip
	private var trackClickMC:MovieClip;
	//Reference to right button
	private var plusBtnMC:MovieClip;
	//Reference to left button
	private var minusBtnMC:MovieClip;
	//Various variables that'll store different dimensions
	//Width of the scroll face.
	private var faceWidth:Number;
	//If the scroll face is manually altered, this variables
	//stores the adjustment value
	private var faceAdjWidth:Number;
	//Width of the scroll track
	private var trackWidth:Number;
	//Change in content X Position when a button is clicked
	private var deltaBtnShift:Number;
	//Delta due to key shift action
	private var deltaKeyShift:Number;
	//Delta shift due to mouse wheel
	private var deltaMouseShift:Number;
	//Delta when the track is clicked
	private var deltaTrackShift:Number;
	//Pane width and height
	//Pane refers to the visible area (same as mask MC)
	private var paneWidth:Number;
	private var paneHeight:Number;
	//Content width
	//Content refers to the original movie clip that we'll scroll
	private var contentWidth:Number;
	private var contentHeight:Number;
	//Original content X Position
	private var contentStartXPosition:Number;
	//Original scroll X Position
	private var scrollStartXPosition:Number;
	//Constants
	//Width for each button.
	private var btnWidth:Number = 16;
	//To store padding between the button and track
	private var btnPadding:Number;
	//Interval trackers
	//Track click interval
	private var trackInterval:Number;
	//Button click interval
	private var btnInterval:Number;
	//Listener objects
	//Key Listener
	private var keyL:Object;
	//Mouse Listener
	private var mouseL:Object;
	//
	/**
	 * Constructor function for the scroll bar. To instantiate any scroll
	 * bar for any movie clip, you need to pass the following properties:
	 *	@param	contentMC			MovieClip which we've to scroll. This movie clip
	 *								should have a registration point of 0,0 at top left.	 
	 *	@param	refMaskMC			The movie clip reference sets the width of the scroll content.
	 *								If you need the entire content be scrollable, just set this parameter
	 *								the same as contentMC
	 *	@param	scrollContainerMC	MovieClip in which we'll create the visual
	 *								elements of the scroll bar.
	 *	@param	maskMC				MovieClip in which we'll create the mask movie
	 *								clip for scrolling.
	 *	@param	paneWidth			Width of the scroll pane (viewable area).
	 *	@param	paneHeight			Height of the scroll pane (viewable area).
	 *	@param	scrollWidth			Width of the scroll width - including buttons, track.
	 *	@param	scrollHeight		Height of the scroll bar.
	 *	@param	btnWidth			Width of scroll buttons
	 *	@param	btnPadding			Padding (in pixels) between the buttons and track.
	*/
	function FCChartHScrollBar(contentMC:MovieClip, refMaskMC:MovieClip, scrollContainerMC:MovieClip, maskMC:MovieClip, paneWidth:Number, paneHeight:Number, scrollWidth:Number, scrollHeight:Number, btnWidth:Number, btnPadding:Number) {
		//Store properties from parameters
		this.contentMC = contentMC;
		this.refMaskMC = refMaskMC;
		this.scrollMC = scrollContainerMC;
		this.maskMC = maskMC;
		this.paneWidth = paneWidth;
		this.paneHeight = paneHeight;		
		//By default assume scroll width equal to that of pane.
		this.scrollWidth = Utils.getFirstNumber(scrollWidth, this.paneWidth);
		this.scrollHeight = Utils.getFirstNumber(scrollHeight, 16);
		this.btnWidth = Utils.getFirstNumber(btnWidth, 16);
		this.btnPadding = Utils.getFirstNumber(btnPadding, 3);
		//Initialize EventDispatcher to implement the event handling functions
		mx.events.EventDispatcher.initialize(this);
		//Initialize instance variables
		this.cosmetics = new Object();
		this.keyL = new Object();
		this.mouseL = new Object();
		//Initialize the scroll bar
		this.init();
	}
	/**
	 * init function initializes the process of scroll bar creation. This
	 * method is called once only, from constructor.
	*/
	private function init():Void {
		//Calculate the various dimensions required.
		this.calculate();
		//Create children movie clips
		this.createChildren();
		//Set a default grey color shade
		this.setColor("CCCCCC");
		//Draw the elements initially.
		//Track, face and buttons have been rendered by setColor method.
		this.drawMask();
		this.setEvents();
		//Now, if the scroll bar is not required, we de-activate scroll bar.
		if (this.contentWidth<=this.paneWidth) {
			this.setState(false);
		} else {
			//Update initial state
			this.state = true;
		}
	}
	/**
	 * calculate method calculates the various co-ordinates and dimensions
	 * of scroll bar.
	*/
	private function calculate() {
		//Store Content width
		this.contentWidth = this.refMaskMC._width;
		this.contentHeight = this.refMaskMC._height;
		//Width of scroll track
		this.trackWidth = this.scrollWidth-2*(this.btnPadding+this.btnWidth);
		//Calculate the width required for scroll bar face
		this.faceWidth = (this.paneWidth/this.contentWidth)*this.trackWidth;
		//Now, if face is too small (<15 pixels, but track > 15), we restrict face to 15p
		//This is done to ensure that it's properly drag-able. 
		if (this.trackWidth>=15 && this.faceWidth<15) {
			this.faceAdjWidth = 15-this.faceWidth;
			this.faceWidth = 15;
		} else {
			this.faceAdjWidth = 0;
		}
		//When a button is clicked, the delta would be 1/2 the face width
		this.deltaBtnShift = this.faceWidth/2;
		//When the user presses left/right key, we change the content by same X as face width
		this.deltaKeyShift = this.faceWidth;
		//When user uses mouse wheel, we change content by 2/3
		this.deltaMouseShift = this.faceWidth*0.66;
		//When user clicks the track
		this.deltaTrackShift = (this.trackWidth-this.faceWidth)/(1/(this.faceWidth/this.trackWidth));
	}
	/**
	 * createChildren method creates the movie clips and visual elements for
	 * the scroll.
	*/
	private function createChildren():Void {
		//Scroll bar track
		this.trackMC = this.scrollMC.createEmptyMovieClip("Track", 2);
		//Track click MC - hide by default
		this.trackClickMC = this.scrollMC.createEmptyMovieClip("TrackClick", 3);
		this.trackClickMC._visible = false;
		//Plus (right) button
		this.plusBtnMC = this.scrollMC.createEmptyMovieClip("BtnPlus", 4);
		//Reference to left button
		this.minusBtnMC = this.scrollMC.createEmptyMovieClip("BtnMinus", 5);
		//Face Click clip (invisible by default)
		this.faceClickMC = this.scrollMC.createEmptyMovieClip("FaceClick", 6);
		this.faceClickMC._visible = false;
		//Scroll bar face
		this.faceMC = this.scrollMC.createEmptyMovieClip("Face", 7);
		//Set initial X positions
		this.trackMC._x = this.btnWidth+this.btnPadding;
		this.trackClickMC._x = this.trackMC._x;
		this.minusBtnMC._x = 0;
		this.faceMC._x = this.btnWidth+this.btnPadding;
		this.faceClickMC._x = this.btnWidth+this.btnPadding;
		this.plusBtnMC._x = this.btnWidth+2*this.btnPadding+this.trackWidth;
		//Store scroll starting X Position
		this.scrollStartXPosition = this.btnWidth+this.btnPadding;
		//Content original start position
		this.contentStartXPosition = this.contentMC._x;
	}
	/**
	 * drawTrack method does the job of drawing the scroll background & track.
	*/
	private function drawTrack():Void {
		//Clear the track movie clip of any previous drawings
		this.trackMC.clear();
		this.trackClickMC.clear();
		//Set line style
		this.trackMC.lineStyle(0, this.cosmetics.track.borderColor, 100);
		//Set fill gradient style
		this.trackMC.beginGradientFill("linear", [this.cosmetics.track.darkColor, this.cosmetics.track.lightColor], [100, 100], [127, 255], {matrixType:"box", x:0, y:0, w:this.trackWidth, h:this.scrollHeight, r:(90/180)*Math.PI});
		//Draw the rectangle
		this.drawRectangle(this.trackMC, 0, 0, this.trackWidth, this.scrollHeight);
		//End Fill
		this.trackMC.endFill();
		//Draw the track click
		//Set line style
		this.trackClickMC.lineStyle(0, this.cosmetics.trackClick.borderColor, 100);
		//Set fill gradient style
		this.trackClickMC.beginGradientFill("linear", [this.cosmetics.trackClick.darkColor, this.cosmetics.trackClick.lightColor], [100, 100], [127, 255], {matrixType:"box", x:0, y:0, w:this.trackWidth, h:this.scrollHeight, r:(90/180)*Math.PI});
		//Draw the rectangle
		this.drawRectangle(this.trackClickMC, 0, 0, this.trackWidth, this.scrollHeight);
		//End Fill
		this.trackClickMC.endFill();
	}
	/**
	 * drawFace method does the job of drawing the scroll face & face click.
	*/
	private function drawFace():Void {
		//Clear any previous drawings
		this.faceMC.clear();
		this.faceClickMC.clear();
		//Set line style
		this.faceMC.lineStyle(0, this.cosmetics.face.borderColor, 100);
		//Set fill gradient style
		this.faceMC.beginGradientFill("linear", [this.cosmetics.face.lightColor, this.cosmetics.face.darkColor], [100, 100], [127, 255], {matrixType:"box", x:0, y:0, w:this.trackWidth, h:this.scrollHeight, r:(90/180)*Math.PI});
		//Draw the rectangle
		this.drawRectangle(this.faceMC, 0, 0, this.faceWidth, this.scrollHeight);
		//End Fill
		this.faceMC.endFill();
		//Draw the face lines
		this.drawFaceLines(this.faceMC, 0, 0);
		//Also create the face click clip (for click effect)
		//Set line style
		this.faceClickMC.lineStyle(0, this.cosmetics.faceClick.borderColor, 100);
		//Set fill gradient style
		this.faceClickMC.beginGradientFill("linear", [this.cosmetics.faceClick.darkColor, this.cosmetics.faceClick.lightColor], [100, 100], [127, 255], {matrixType:"box", x:0, y:0, w:this.trackWidth, h:this.scrollHeight, r:(90/180)*Math.PI});
		//Draw the rectangle
		this.drawRectangle(this.faceClickMC, 0, 0, this.faceWidth, this.scrollHeight);
		//End Fill
		this.faceClickMC.endFill();
		//Draw the face lines
		this.drawFaceLines(this.faceClickMC, 1, 1);
	}
	/**
	 * drawFaceLines draws the 4 vertical (cosmetic) lines on the scroll face
	 *	@param	mc		In which movie clip to draw?
	 *	@param	offsetX	Offset X from center for drawing
	 *	@param	offsetY	Offest Y from center for drawing
	*/
	private function drawFaceLines(mc:MovieClip, offsetX:Number, offsetY:Number):Void {
		//x-distance between each line
		var xGap:Number = 3;
		//Height of each line
		var hLine:Number = 6;
		//Start X, start Y, end Y
		var sX:Number = Math.round(this.faceWidth/2+offsetX)-5;
		var sY:Number = (this.scrollHeight-hLine)/2+offsetY;
		var eY:Number = sY+hLine;
		//Set the linestyle
		mc.lineStyle(1, this.cosmetics.face.darkColor, 100, true, "none");
		//Now draw the 4 lines
		for (var i:Number = 0; i<=3; i++) {
			mc.moveTo(sX+(xGap*i), sY);
			mc.lineTo(sX+(xGap*i), eY);
		}
	}
	/**
	 * drawButtons method does the job of drawing the buttons.
	*/
	private function drawButtons():Void {
		//Clear of any previous drawing
		this.plusBtnMC.clear();
		this.minusBtnMC.clear();
		//Draw minus button first
		this.minusBtnMC.lineStyle(0, this.cosmetics.button.borderColor, 100);
		//Set fill gradient style
		this.minusBtnMC.beginGradientFill("linear", [this.cosmetics.button.lightColor, this.cosmetics.button.darkColor], [100, 100], [127, 255], {matrixType:"box", x:0, y:0, w:this.trackWidth, h:this.scrollHeight, r:(90/180)*Math.PI});
		//Draw the rectangle
		this.drawRectangle(this.minusBtnMC, 0, 0, this.btnWidth, this.scrollHeight);
		//End Fill
		this.minusBtnMC.endFill();
		//Draw Plus Button now
		this.plusBtnMC.lineStyle(0, this.cosmetics.button.borderColor, 100);
		//Set fill gradient style
		this.plusBtnMC.beginGradientFill("linear", [this.cosmetics.button.lightColor, this.cosmetics.button.darkColor], [100, 100], [127, 255], {matrixType:"box", x:0, y:0, w:this.trackWidth, h:this.scrollHeight, r:(90/180)*Math.PI});
		//Draw the rectangle
		this.drawRectangle(this.plusBtnMC, 0, 0, this.btnWidth, this.scrollHeight);
		//End Fill
		this.plusBtnMC.endFill();
		//Draw the arrows
		var cX:Number = btnWidth/2;
		var cY:Number = this.scrollHeight/2;
		var h:Number = this.scrollHeight/4;
		//Draw the left arrow
		this.minusBtnMC.lineStyle(2, this.cosmetics.button.arrowColor, 100);
		this.minusBtnMC.moveTo(cX-4, cY);
		this.minusBtnMC.lineTo(cX+2, cY-h);
		this.minusBtnMC.moveTo(cX-4, cY);
		this.minusBtnMC.lineTo(cX+2, cY+h);
		//Draw the right arrow
		this.plusBtnMC.lineStyle(2, this.cosmetics.button.arrowColor, 100);
		this.plusBtnMC.moveTo(cX+4, cY);
		this.plusBtnMC.lineTo(cX-2, cY-h);
		this.plusBtnMC.moveTo(cX+4, cY);
		this.plusBtnMC.lineTo(cX-2, cY+h);
	}
	/**
	 * drawMask method draws the mask required.
	*/
	private function drawMask():Void {
		//Clear the mask movie clip
		this.maskMC.clear();
		//Draw a rectangle within this movie clip
		//Create a mask rectangle equal to the pane width & height
		this.maskMC.beginFill(0xffffff, 100);
		this.drawRectangle(this.maskMC, 0, 0, this.paneWidth, this.paneHeight);
		this.maskMC.endFill();
		//Set the mask's start position as that of the content movie clip
		this.maskMC._x = contentStartXPosition;
		this.maskMC._y = this.contentMC._y;
		//Set the mask
		this.contentMC.setMask(this.maskMC);
	}
	/**
	 * setEvents method sets the events for various parts of scroll bar.
	*/
	private function setEvents():Void {
		//Get a reference to self class.
		var classRef = this;
		var scrollStartX:Number = this.faceMC._x;
		//Define the drag event for the face
		this.faceMC.onPress = function() {
			//Dispatch the click event
			classRef.dispatchEvent({type:"click", target:classRef});
			//Hide the face movie clip
			this._alpha = 0;
			//Show the click effect movie clip
			classRef.faceClickMC._visible = true;
			//Set the dragging for click handler movie clip
			classRef.faceClickMC.startDrag(false, classRef.btnWidth+classRef.btnPadding, 0, classRef.trackWidth-classRef.faceWidth+classRef.btnWidth+classRef.btnPadding, 0);
			classRef.faceClickMC.onEnterFrame = function() {
				//Update the x-position w.r.t click handler				
				classRef.faceMC._x = this._x;
				if (this._x != scrollStartX) {
					//If the scroll position has changed, update the scroll content					
					classRef.scrollContent(this._x, classRef.deltaDragShift, true, false);
					//Update delta register
					scrollStartX = this._x;
				}
			};
		};
		this.faceMC.onRelease = this.faceMC.onReleaseOutside=function () {
			//Stop dragging
			classRef.faceClickMC.stopDrag();
			//Delete enterFrame
			delete classRef.faceClickMC.onEnterFrame;
			//Show the face back
			this._alpha = 100;
			//Hide the click movie
			classRef.faceClickMC._visible = false;
			//Dispatch the change event
			classRef.dispatchEvent({type:"change", target:classRef});
		};
		//Events for button
		//Left Button
		this.minusBtnMC.onPress = Delegate.create(this, minusButtonOnPress);
		this.minusBtnMC.onRelease = this.minusBtnMC.onReleaseOutside=function () {			
			//Clear the interval
			clearInterval(classRef.btnInterval);
			//Dispatch the change event
			classRef.dispatchEvent({type:"change", target:classRef});
		};
		//Right Button
		this.plusBtnMC.onPress = Delegate.create(this, plusButtonOnPress);
		this.plusBtnMC.onRelease = this.plusBtnMC.onReleaseOutside=function () {
			//Clear the interval
			clearInterval(classRef.btnInterval);
			//Dispatch the change event
			classRef.dispatchEvent({type:"change", target:classRef});
		};
		//Click events for track
		//We need to delegate the onPress event to another member function, as we've
		//to use setInterval within that, which in turn calls another member function.
		this.trackMC.onPress = Delegate.create(this, trackOnPress);
		this.trackMC.onRelease = this.trackMC.onReleaseOutside=function () {
			//Show the track MC
			this._alpha = 100;
			//Hide the track click MC
			classRef.trackClickMC._visible = false;
			//Clear interval			
			clearInterval(classRef.trackInterval);
			//Dispatch the change event
			classRef.dispatchEvent({type:"change", target:classRef});
		};
		//Add Key Listeners to enable key movement
		//We define the onKeyDown event for the key listener.
		this.keyL.onKeyDown = function() {
			if (classRef.maskMC.hitTest(_root._xmouse, _root._ymouse)) {
				//if the left key is pressed
				if (Key.isDown(Key.LEFT)) {
					//Negative Shift
					classRef.scrollContentFromDelta(-classRef.deltaKeyShift);
				} else if (Key.isDown(Key.RIGHT)) {
					//Positive Shift
					classRef.scrollContentFromDelta(classRef.deltaKeyShift);
				}
			}
			//Dispatch the change event
			classRef.dispatchEvent({type:"change", target:classRef});
		};
		//Register the key listener
		Key.addListener(this.keyL);
		//Add mouse listeners to enable mouse wheel movement
		//Define the onMouseWheel Event for the scroll
		this.mouseL.onMouseWheel = function(delta) {
			if (classRef.maskMC.hitTest(_root._xmouse, _root._ymouse)) {
				if (delta<0) {
					//Positive Shift
					classRef.scrollContentFromDelta(classRef.deltaMouseShift);
				} else {
					//Negative Shift
					classRef.scrollContentFromDelta(-classRef.deltaMouseShift);
				}
			}
			//Dispatch the change event
			classRef.dispatchEvent({type:"change", target:classRef});
		};
		//Register the listener for the scroll
		Mouse.addListener(this.mouseL);
	}
	/**
	 * minusButtonOnPress is a delegated method which is invoked, when the user presses
	 * the left button.
	*/
	private function minusButtonOnPress():Void {
		//Dispatch the click event
		this.dispatchEvent({type:"click", target:this});
		this.btnInterval = setInterval(Delegate.create(this, scrollContentFromDelta), 50, -this.deltaBtnShift);
	}
	/**
	 * plusButtonOnPress is a delegated method which is invoked, when the user presses
	 * the right button.
	*/
	private function plusButtonOnPress():Void {
		//Dispatch the click event
		this.dispatchEvent({type:"click", target:this});
		this.btnInterval = setInterval(Delegate.create(this, scrollContentFromDelta), 50, this.deltaBtnShift);
	}
	/**
	 * trackOnPress is a delegated method which is invoked, when the user presses
	 * the scroll track.
	*/
	private function trackOnPress():Void {
		//Dispatch the click event
		this.dispatchEvent({type:"click", target:this});
		//Hide the track MC
		this.trackMC._alpha = 0;
		//Show the track click MC
		this.trackClickMC._visible = true;
		//Set an interval to scroll the content in periodic interval
		this.trackInterval = setInterval(Delegate.create(this, scrollContentFromTrack), 50, this.trackMC._xmouse);
	}
	/**
	 * setState method helps set the state (enabled/disabled) for the scroll bar.
	 * By default the component starts in enabled mode. If you set in disabled mode,
	 * the component changes to a greyed out shade with no visible scroll bar face.
	 * Also, the buttons stay inactive.
	*/
	public function setState(state:Boolean):Void {
		//Check if the same state is sent again
		if (state != this.state) {
			//Store state
			this.state = state;
			//Disable the events
			this.scrollMC.enabled = state;
			this.faceMC.enabled = state;
			this.faceClickMC.enabled = state;
			this.trackMC.enabled = state;
			this.trackClickMC.enabled = state;
			this.plusBtnMC.enabled = state;
			this.minusBtnMC.enabled = state;
			//Need to take care of listeners
			if (state) {
				Key.addListener(this.keyL);
				Mouse.addListener(this.mouseL);
			} else {
				Key.removeListener(this.keyL);
				Mouse.removeListener(this.mouseL);
			}
			//Alter visibility of scroll face
			this.faceMC._visible = state;
		}
	}
	/**
	 * getState method returns the current state of the component.
	*/
	public function getState():Boolean {
		return this.state;
	}
	/**
	 * setColor method skins the component by just specifying a single color
	 * for the component. We automatically calculate various other colors for
	 * the component internally. Each setColor() calls for an entire re-draw
	 * of the component.	 
	*/
	public function setColor(strColor:String):Void {
		if (this.scrollColor != strColor) {
			//Store color
			this.scrollColor = strColor;
			//Create new objects in this.cosmetics to store various colors
			this.cosmetics.bg = new Object();
			this.cosmetics.track = new Object();
			this.cosmetics.trackClick = new Object();
			this.cosmetics.face = new Object();
			this.cosmetics.faceClick = new Object();
			this.cosmetics.button = new Object();
			//Scroll Track Properties
			this.cosmetics.track.color = parseInt(strColor, 16);
			this.cosmetics.track.darkColor = ColorExt.getLightColor(strColor, 0.35);
			this.cosmetics.track.lightColor = ColorExt.getLightColor(strColor, 0.15);
			this.cosmetics.track.borderColor = ColorExt.getDarkColor(strColor, 0.75);
			//Scroll Track Click Properties
			this.cosmetics.trackClick.color = parseInt(strColor, 16);
			this.cosmetics.trackClick.darkColor = ColorExt.getLightColor(strColor, 0.95);
			this.cosmetics.trackClick.lightColor = ColorExt.getLightColor(strColor, 0.75);
			this.cosmetics.trackClick.borderColor = ColorExt.getDarkColor(strColor, 0.75);
			//Button properties
			this.cosmetics.button.arrowColor = ColorExt.getDarkColor(strColor, 0.30);
			this.cosmetics.button.lightColor = ColorExt.getLightColor(strColor, 0.25);
			this.cosmetics.button.darkColor = ColorExt.getDarkColor(strColor, 0.75);
			this.cosmetics.button.borderColor = ColorExt.getDarkColor(strColor, 0.55);
			//Scroll-face properties
			this.cosmetics.face.color = parseInt(strColor, 16);
			this.cosmetics.face.darkColor = ColorExt.getDarkColor(strColor, 0.75);
			this.cosmetics.face.lightColor = ColorExt.getLightColor(strColor, 0.25);
			this.cosmetics.face.borderColor = ColorExt.getDarkColor(strColor, 0.55);
			//Face click properties
			this.cosmetics.faceClick.color = parseInt(strColor, 16);
			this.cosmetics.faceClick.darkColor = ColorExt.getDarkColor(strColor, 0.95);
			this.cosmetics.faceClick.lightColor = ColorExt.getLightColor(strColor, 0.55);
			this.cosmetics.faceClick.borderColor = ColorExt.getDarkColor(strColor, 0.55);
			//Now, re-draw the various objects
			this.drawTrack();
			this.drawFace();
			this.drawButtons();
		}
	}
	/**
	 * scrollToStart method scrolls the scroll bar to start of the content.
	*/
	public function scrollToStart():Void{
		//Shift content MC to start position
		this.contentMC._x = this.contentStartXPosition;
		//Set the face position based on content position
		this.setFacePositionFromContent();
	}
	/**
	 * scrollToEnd method scrolls the scroll bar to extreme end of the content.
	*/
	public function scrollToEnd():Void{
		//Shift content MC to extreme left
		this.contentMC._x = this.paneWidth - this.refMaskMC._width + this.contentStartXPosition;
		//Set the face position based on content position
		this.setFacePositionFromContent();
	}
	/**
	 * setFacePositionFromContent method sets the position of the scroll face
	 * based on the content position.
	*/
	public function setFacePositionFromContent():Void {
		//Calculate the x-position
		//We adjust for the deducted face width (for width <15 pixels)
		var fX:Number = ((-(this.contentMC._x-this.contentStartXPosition)/this.refMaskMC._width)*this.trackWidth)+this.scrollStartXPosition-(this.faceAdjWidth*(-(this.contentMC._x-this.contentStartXPosition)/this.refMaskMC._width));
		//Update face and face click movie clips X position
		this.faceMC._x = fX;
		this.faceClickMC._x = fX;		
	}
	/**
	 * scrollContent method scrolls the content when the user drags the scroll face.
	 *	@param	faceXPos		Final x-position of the scroll bar. The content will be
	 *							scrolled till this x position (proportionally).	
	*/
	private function scrollContent(faceXPos:Number):Void {
		//Calculate how much we will need to shift the content movie clip
		var xShift = ((faceXPos-this.scrollStartXPosition)/(this.trackWidth-this.faceWidth))*(this.contentWidth-this.paneWidth);
		//Based on scroll face shift, we need to shift the content movie clip in reverse direction.
		this.contentMC._x = this.contentStartXPosition-xShift;
	}
	/**
	 * scrollContentFromDelta method helps scroll the content using a delta factor.
	 *	@param	shift		The X Delta shift required.
	*/
	private function scrollContentFromDelta(shift):Void {
		//Nothing to do if no shift is required.
		if (shift == 0) {
			return;
		}
		//Based on shift direction, we scroll the content  
		if (shift>0) {
			//Shift in right position. So, movie clip has to be scrolled in opposite direction
			if ((this.contentMC._x-this.contentStartXPosition-shift)>=(this.paneWidth-this.contentWidth)) {
				//Shift by the given step
				this.contentMC._x -= shift;
			} else {
				//Place it at the extreme left.
				this.contentMC._x = this.contentStartXPosition+this.paneWidth-this.contentWidth;
			}
		} else {
			//Shift in left direction. So, movie clip has to be scrolled in opposite direction.
			if (this.contentMC._x-shift<contentStartXPosition) {
				this.contentMC._x -= shift;
			} else {
				this.contentMC._x = contentStartXPosition;
			}
		}
		//Update the scroll face position accordingly.
		this.setFacePositionFromContent();
	}
	/**
	 * scrollContentFromTrack method is called to scroll the content when the user clicks
	 * on the track.
	*/
	private function scrollContentFromTrack(clickXPos:Number):Void {
		//xShift needed
		var xShift:Number = this.deltaTrackShift;
		//First check where the user clicked on the track. Left or right or
		//scroll face
		//Now, if clickXPos is on the left side of the face movie clip
		//we need to scroll to left. Else, we need to scroll to right
		
		if (clickXPos<(this.faceMC._x-this.scrollStartXPosition)) {
			//Since the scroll face will come towards left, the content movie 
			//would shift to right, until the specified condition is reached.
			//Check if the entire content has shifted completely.
			if (this.contentMC._x + xShift>this.contentStartXPosition){				
				//If we're nearing extreme position, do a conditional check
				if (this.contentMC._x<this.contentStartXPosition){
					//For last position, just "push" it to the extreme
					this.contentMC._x = this.contentStartXPosition;
				}
				//Clear the interval.
				clearInterval(this.trackInterval);
			}else{
				//Normal shifting (incremental)
				this.contentMC._x += xShift;			
			}
		} else if (clickXPos>(this.faceMC._x-this.scrollStartXPosition+this.faceWidth)){			
			if ((this.contentMC._x-this.contentStartXPosition - xShift)<=(this.paneWidth-this.contentWidth)) {
				//"Push" to the extreme edge
				this.contentMC._x = (this.paneWidth-this.contentWidth) + this.contentStartXPosition;
				//Clear the interval.
				clearInterval(this.trackInterval);				
			} else{
				//Normal shifting (incremental)
				this.contentMC._x -= xShift;
			}
		}
		//Update the scroll face position accordingly.
		this.setFacePositionFromContent();
		
	}
	/**
	 * invalidate method should be called to draw the scroll bar initially or
	 * even when the content has changed. This method adjusts the scroll bar
	 * to update the latest state.
	*/
	public function invalidate():Void {
		//Calculate the various dimensions required.
		this.calculate();
		//Draw the elements again.
		this.drawTrack();
		this.drawFace();
		this.drawButtons();
		this.drawMask();
		//Special case - in cases of invalidation where the scroll bar is 
		//dragged to extreme right, the content MC width reduced and then 
		//invalidate is called - the scroll bar doesn't reduce in that case.
		//So, we shift the content MC to right (as the width has reduced).
		//Thereby, the scroll bar automatically shows right based on content
		//position.
		if ((this.contentWidth>this.paneWidth) && (this.contentMC._x+this.refMaskMC._width-this.contentStartXPosition<this.paneWidth)) {
			this.contentMC._x += this.paneWidth-(this.contentMC._x+this.refMaskMC._width-this.contentStartXPosition);
		}
		//Set face position from content
		this.setFacePositionFromContent();
		
		//Now, if the scroll bar is not required, we de-activate scroll bar. 
		if (this.contentWidth<=this.paneWidth) {
			this.setState(false);
		} else {
			this.setState(true);
		}
	}
	
	/**
	 * show method shows the scroll bar back, if you've hidden it using hide().
	*/
	public function show():Void {
		this.scrollMC._visible = true;
	}
	/**
	 * hide method hides a scroll bar. It doesn't remove the masking movie clip.
	*/
	public function hide():Void {
		this.scrollMC._visible = false;
	}
	/**
	 * drawRectangle method draws a rectangle in the given movie clip.
	 *	@param	mc	Movieclip in which we've to draw rectangle.
	 *	@param	x	Top Left X Position from where we've to start drawing.
	 *	@param	y	Top Left Y Position from where we've to start drawing.
	 *	@param	w	Width of the rectangle.
	 *	@param	h	Height of the rectangle.
	 *	@return		Nothing
	*/
	private function drawRectangle(mc:MovieClip, x:Number, y:Number, w:Number, h:Number):Void {
		mc.moveTo(x, y);
		mc.lineTo(x+w, y);
		mc.lineTo(x+w, y+h);
		mc.lineTo(x, y+h);
		mc.lineTo(x, y);
	}
	//These functions are defined in the class to prevent
	//the compiler from throwing an error when they are called
	//They are not implemented until EventDispatcher.initalize(this)
	//overwrites them.
	public function dispatchEvent() {
	}
	public function addEventListener() {
	}
	public function removeEventListener() {
	}
	public function dispatchQueue() {
	}
	/** 
	 * destroy method MUST be called whenever you wish to delete this class's
	 * instance. It removes all listeners and removes all movie clips that
	 * are created as a part of scroll bar.
	*/
	public function destroy():Void {
		//Collect garbage
		delete cosmetics;
		//Clear any intervals
		clearInterval(this.trackInterval);
		clearInterval(this.btnInterval);
		//Remove all listeners
		Key.removeListener(this.keyL);
		Mouse.removeListener(this.mouseL);
		//Remove all movie clips
		scrollMC.removeMovieClip();
		maskMC.removeMovieClip();
	}
}
