/*
 PureMVC MultiCore - Copyright(c) 2006-08 Futurescale, Inc., Some rights reserved.
 Your reuse is governed by the Creative Commons Attribution 3.0 United States License
*/
package org.puremvc.as3.multicore.patterns.facade
{
	import org.puremvc.as3.multicore.core.*;
	import org.puremvc.as3.multicore.interfaces.*;
	import org.puremvc.as3.multicore.patterns.observer.*;

	/**
	 * A base Multiton <code>IFacade</code> implementation.
	 * 
	 * @see org.puremvc.as3.multicore.core.Model Model
	 * @see org.puremvc.as3.multicore.core.View View
	 * @see org.puremvc.as3.multicore.core.Controller Controller 
	 */
	public class Facade implements IFacade
	{
		/**
		 * Constructor. 
		 * 
		 * <P>
		 * This <code>IFacade</code> implementation is a Multiton, 
		 * so you should not call the constructor 
		 * directly, but instead call the static Factory method, 
		 * passing the unique key for this instance 
		 * <code>Facade.getInstance( multitonKey )</code>
		 * 
		 * @throws Error Error if instance for this Multiton key has already been constructed
		 * 
		 */
		public function Facade( key:String ) {
			if (instanceMap[ key ] != null) throw Error(MULTITON_MSG);
			initializeNotifier( key );
			instanceMap[ multitonKey ] = this;
			initializeFacade();	
		}

		/**
		 * Initialize the Multiton <code>Facade</code> instance.
		 * 
		 * <P>
		 * Called automatically by the constructor. Override in your
		 * subclass to do any subclass specific initializations. Be
		 * sure to call <code>super.initializeFacade()</code>, though.</P>
		 */
		protected function initializeFacade(  ):void {
			initializeModel();
			initializeController();
			initializeView();
		}

		/**
		 * Facade Multiton Factory method
		 * 
		 * @return the Multiton instance of the Facade
		 */
		public static function getInstance( key:String ):IFacade {
			if (instanceMap[ key ] == null ) instanceMap[ key ] = new Facade( key );
			return instanceMap[ key ];
		}

		/**
		 * Initialize the <code>Controller</code>.
		 * 
		 * <P>
		 * Called by the <code>initializeFacade</code> method.
		 * Override this method in your subclass of <code>Facade</code> 
		 * if one or both of the following are true:
		 * <UL>
		 * <LI> You wish to initialize a different <code>IController</code>.</LI>
		 * <LI> You have <code>Commands</code> to register with the <code>Controller</code> at startup.</code>. </LI>		  
		 * </UL>
		 * If you don't want to initialize a different <code>IController</code>, 
		 * call <code>super.initializeController()</code> at the beginning of your
		 * method, then register <code>Command</code>s.
		 * </P>
		 */
		protected function initializeController( ):void {
			if ( controller != null ) return;
			controller = Controller.getInstance( multitonKey );
		}

		/**
		 * Initialize the <code>Model</code>.
		 * 
		 * <P>
		 * Called by the <code>initializeFacade</code> method.
		 * Override this method in your subclass of <code>Facade</code> 
		 * if one or both of the following are true:
		 * <UL>
		 * <LI> You wish to initialize a different <code>IModel</code>.</LI>
		 * <LI> You have <code>Proxy</code>s to register with the Model that do not 
		 * retrieve a reference to the Facade at construction time.</code></LI> 
		 * </UL>
		 * If you don't want to initialize a different <code>IModel</code>, 
		 * call <code>super.initializeModel()</code> at the beginning of your
		 * method, then register <code>Proxy</code>s.
		 * <P>
		 * Note: This method is <i>rarely</i> overridden; in practice you are more
		 * likely to use a <code>Command</code> to create and register <code>Proxy</code>s
		 * with the <code>Model</code>, since <code>Proxy</code>s with mutable data will likely
		 * need to send <code>INotification</code>s and thus will likely want to fetch a reference to 
		 * the <code>Facade</code> during their construction. 
		 * </P>
		 */
		protected function initializeModel( ):void {
			if ( model != null ) return;
			model = Model.getInstance( multitonKey );
		}
		

		/**
		 * Initialize the <code>View</code>.
		 * 
		 * <P>
		 * Called by the <code>initializeFacade</code> method.
		 * Override this method in your subclass of <code>Facade</code> 
		 * if one or both of the following are true:
		 * <UL>
		 * <LI> You wish to initialize a different <code>IView</code>.</LI>
		 * <LI> You have <code>Observers</code> to register with the <code>View</code></LI>
		 * </UL>
		 * If you don't want to initialize a different <code>IView</code>, 
		 * call <code>super.initializeView()</code> at the beginning of your
		 * method, then register <code>IMediator</code> instances.
		 * <P>
		 * Note: This method is <i>rarely</i> overridden; in practice you are more
		 * likely to use a <code>Command</code> to create and register <code>Mediator</code>s
		 * with the <code>View</code>, since <code>IMediator</code> instances will need to send 
		 * <code>INotification</code>s and thus will likely want to fetch a reference 
		 * to the <code>Facade</code> during their construction. 
		 * </P>
		 */
		protected function initializeView( ):void {
			if ( view != null ) return;
			view = View.getInstance( multitonKey );
		}

		/**
		 * Register an <code>ICommand</code> with the <code>Controller</code> by Notification name.
		 * 
		 * @param notificationName the name of the <code>INotification</code> to associate the <code>ICommand</code> with
		 * @param commandClassRef a reference to the Class of the <code>ICommand</code>
		 */
		public function registerCommand( notificationName:String, commandClassRef:Class ):void 
		{
			controller.registerCommand( notificationName, commandClassRef );
		}

		/**
		 * Remove a previously registered <code>ICommand</code> to <code>INotification</code> mapping from the Controller.
		 * 
		 * @param notificationName the name of the <code>INotification</code> to remove the <code>ICommand</code> mapping for
		 */
		public function removeCommand( notificationName:String ):void 
		{
			controller.removeCommand( notificationName );
		}

		/**
		 * Check if a Command is registered for a given Notification 
		 * 
		 * @param notificationName
		 * @return whether a Command is currently registered for the given <code>notificationName</code>.
		 */
		public function hasCommand( notificationName:String ) : Boolean
		{
			return controller.hasCommand(notificationName);
		}

		/**
		 * Register an <code>IProxy</code> with the <code>Model</code> by name.
		 * 
		 * @param proxyName the name of the <code>IProxy</code>.
		 * @param proxy the <code>IProxy</code> instance to be registered with the <code>Model</code>.
		 */
		public function registerProxy ( proxy:IProxy ):void	
		{
			model.registerProxy ( proxy );	
		}
				
		/**
		 * Retrieve an <code>IProxy</code> from the <code>Model</code> by name.
		 * 
		 * @param proxyName the name of the proxy to be retrieved.
		 * @return the <code>IProxy</code> instance previously registered with the given <code>proxyName</code>.
		 */
		public function retrieveProxy ( proxyName:String ):IProxy 
		{
			return model.retrieveProxy ( proxyName );	
		}

		/**
		 * Remove an <code>IProxy</code> from the <code>Model</code> by name.
		 *
		 * @param proxyName the <code>IProxy</code> to remove from the <code>Model</code>.
		 * @return the <code>IProxy</code> that was removed from the <code>Model</code>
		 */
		public function removeProxy ( proxyName:String ):IProxy 
		{
			var proxy:IProxy;
			if ( model != null ) proxy = model.removeProxy ( proxyName );	
			return proxy
		}

		/**
		 * Check if a Proxy is registered
		 * 
		 * @param proxyName
		 * @return whether a Proxy is currently registered with the given <code>proxyName</code>.
		 */
		public function hasProxy( proxyName:String ) : Boolean
		{
			return model.hasProxy( proxyName );
		}

		/**
		 * Register a <code>IMediator</code> with the <code>View</code>.
		 * 
		 * @param mediatorName the name to associate with this <code>IMediator</code>
		 * @param mediator a reference to the <code>IMediator</code>
		 */
		public function registerMediator( mediator:IMediator ):void 
		{
			if ( view != null ) view.registerMediator( mediator );
		}

		/**
		 * Retrieve an <code>IMediator</code> from the <code>View</code>.
		 * 
		 * @param mediatorName
		 * @return the <code>IMediator</code> previously registered with the given <code>mediatorName</code>.
		 */
		public function retrieveMediator( mediatorName:String ):IMediator 
		{
			return view.retrieveMediator( mediatorName ) as IMediator;
		}

		/**
		 * Remove an <code>IMediator</code> from the <code>View</code>.
		 * 
		 * @param mediatorName name of the <code>IMediator</code> to be removed.
		 * @return the <code>IMediator</code> that was removed from the <code>View</code>
		 */
		public function removeMediator( mediatorName:String ) : IMediator 
		{
			var mediator:IMediator;
			if ( view != null ) mediator = view.removeMediator( mediatorName );			
			return mediator;
		}

		/**
		 * Check if a Mediator is registered or not
		 * 
		 * @param mediatorName
		 * @return whether a Mediator is registered with the given <code>mediatorName</code>.
		 */
		public function hasMediator( mediatorName:String ) : Boolean
		{
			return view.hasMediator( mediatorName );
		}

		/**
		 * Create and send an <code>INotification</code>.
		 * 
		 * <P>
		 * Keeps us from having to construct new notification 
		 * instances in our implementation code.
		 * @param notificationName the name of the notiification to send
		 * @param body the body of the notification (optional)
		 * @param type the type of the notification (optional)
		 */ 
		public function sendNotification( notificationName:String, body:Object=null, type:String=null ):void 
		{
			notifyObservers( new Notification( notificationName, body, type ) );
		}

		/**
		 * Notify <code>Observer</code>s.
		 * <P>
		 * This method is left public mostly for backward 
		 * compatibility, and to allow you to send custom 
		 * notification classes using the facade.</P>
		 *<P> 
		 * Usually you should just call sendNotification
		 * and pass the parameters, never having to 
		 * construct the notification yourself.</P>
		 * 
		 * @param notification the <code>INotification</code> to have the <code>View</code> notify <code>Observers</code> of.
		 */
		public function notifyObservers ( notification:INotification ):void {
			if ( view != null ) view.notifyObservers( notification );
		}

		/** 
		 * Set the Multiton key for this facade instance.
		 * <P>
		 * Not called directly, but instead from the 
		 * constructor when getInstance is invoked. 
		 * It is necessary to be public in order to 
		 * implement INotifier.</P>
		 */
		public function initializeNotifier( key:String ):void
		{
			multitonKey = key;
		}

		/**
		 * Remove a Core 
		 * 
		 * @param multitonKey of the Core to remove
		 */
		public function removeCore( key:String ) : void
		{
			// remove the model, view, controller 
			// and facade instances for this key 
			model.removeModel( key ); 
			view.removeView( key );
			controller.removeController( key );
			delete instanceMap[ key ];
		}

		// References to Model, View and Controller
		protected var controller : IController;
		protected var model		 : IModel;
		protected var view		 : IView;
		
		// The Multiton Key for this app
		protected var multitonKey : String;
		
		// The Multiton Facade instanceMap.
		protected static var instanceMap : Array = new Array(); 
		
		// Message Constants
		protected const MULTITON_MSG:String = "Facade instance for this Multiton key already constructed!";
	
	}
}