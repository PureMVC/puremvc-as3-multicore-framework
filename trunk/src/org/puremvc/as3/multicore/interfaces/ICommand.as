/*
 PureMVC MultiCore - Copyright(c) 2006-08 Futurescale, Inc., Some rights reserved.
 Your reuse is governed by the Creative Commons Attribution 3.0 United States License
*/
package org.puremvc.as3.multicore.interfaces
{
	/**
	 * The interface definition for a PureMVC Command.
	 *
	 * @see org.puremvc.as3.multicore.interfaces INotification
	 */
	public interface ICommand extends INotifier
	{
		/**
		 * Execute the <code>ICommand</code>'s logic to handle a given <code>INotification</code>.
		 * 
		 * @param note an <code>INotification</code> to handle.
		 */
		function execute( notification:INotification ) : void;
	}
}