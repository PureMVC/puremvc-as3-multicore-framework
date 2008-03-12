/*
 PureMVC MultiCore - Copyright(c) 2006-08 Futurescale, Inc., Some rights reserved.
 Your reuse is governed by the Creative Commons Attribution 3.0 United States License
*/
package org.puremvc.as3.multicore.patterns.observer
{
	import org.puremvc.as3.multicore.interfaces.*;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	/**
	 * A Base <code>INotifier</code> implementation.
	 * 
	 * <P>
	 * <code>MacroCommand, Command, Mediator</code> and <code>Proxy</code> 
	 * all have a need to send <code>Notifications</code>. <P>
	 * <P>
	 * The <code>INotifier</code> interface provides a common method called
	 * <code>sendNotification</code> that relieves implementation code of 
	 * the necessity to actually construct <code>Notifications</code>.</P>
	 * 
	 * <P>
	 * The <code>Notifier</code> class, which all of the above mentioned classes
	 * extend, provides an initialized reference to the <code>Facade</code>
	 * Multiton, which is required for the convienience method
	 * for sending <code>Notifications</code>, but also eases implementation as these
	 * classes have frequent <code>Facade</code> interactions and usually require
	 * access to the facade anyway.</P>
	 * 
	 * <P>
	 * NOTE: In the MultiCore version of the framework, there is one caveat to
	 * notifiers, they cannot send notifications or reach the facade until they
	 * have a valid multitonKey. 
	 * 
	 * The multitonKey is set:
	 *   * on a Command when it is executed by the Controller
	 *   * on a Mediator is registered with the View
	 *   * on a Proxy is registered with the Model. 
	 * 
	 * @see org.puremvc.as3.multicore.patterns.proxy.Proxy Proxy
	 * @see org.puremvc.as3.multicore.patterns.facade.Facade Facade
	 * @see org.puremvc.as3.multicore.patterns.mediator.Mediator Mediator
	 * @see org.puremvc.as3.multicore.patterns.command.MacroCommand MacroCommand
	 * @see org.puremvc.as3.multicore.patterns.command.SimpleCommand SimpleCommand
	 */
	public class Notifier implements INotifier
	{
		/**
		 * Create and send an <code>INotification</code>.
		 * 
		 * <P>
		 * Keeps us from having to construct new INotification 
		 * instances in our implementation code.
		 * @param notificationName the name of the notiification to send
		 * @param body the body of the notification (optional)
		 * @param type the type of the notification (optional)
		 */ 
		public function sendNotification( notificationName:String, body:Object=null, type:String=null ):void 
		{
			if (facade != null) 
				facade.sendNotification( notificationName, body, type );
		}
		
		/**
		 * Initialize this INotifier instance.
		 * <P>
		 * This is how a Notifier gets its multitonKey. 
		 * Calls to sendNotification or to access the
		 * facade will fail until after this method 
		 * has been called.</P>
		 * 
		 * <P>
		 * Mediators, Commands or Proxies may override 
		 * this method in order to send notifications
		 * or access the Multiton Facade instance as
		 * soon as possible. They CANNOT access the facade
		 * in their constructors, since this method will not
		 * yet have been called.</P> 
		 * 
		 * @param key the multitonKey for this INotifier to use
		 */
		public function initializeNotifier( key:String ):void
		{
			multitonKey = key;
		}
		
		// Return the Multiton Facade instance 
		protected function get facade():IFacade
		{
			if ( multitonKey == null ) throw Error( MULTITON_MSG );
			return Facade.getInstance( multitonKey );
		}
		
		// The Multiton Key for this app
		protected var multitonKey : String;

		// Message Constants
		protected const MULTITON_MSG : String = "multitonKey for this Notifier not yet initialized!";

	}
}