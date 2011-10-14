/**
 * @class IComponent
 * @author InfoSoft Global (P) Ltd. www.InfoSoftGlobal.com
 * @version 3.0
 *
 * Copyright (C) InfoSoft Global Pvt. Ltd. 2005-2006
 * Interface to define all components that will be created from it.
 * Basically, all components that we'll create for FusionCharts will
 * have to implement these methods.
*/
//Interface
interface com.fusioncharts.components.IComponent {
	/**
	 * inValidate method redraws the component without any code repetition.
	 */
	public function invalidate():Void;
	/**
	  * setColor method is use to set the Color of the Component
	*/
	function setColor(colorCode:String):Void;
	/**
	  * setState method is use to set the state of the Component
	*/
	function setState(state:Boolean):Void;
	/**
	 * getState method returns the state of the Component
	*/
	function getState():Boolean;
	/**
	  * show method shows the Component
	*/
	function show():Void;
	/**
	 * hide method hides the Component
	*/
	function hide():Void;
	/**
	 * destroy method MUST be called whenever you wish to delete this class's
	 * instance.
	*/
	function destroy():Void;
}
