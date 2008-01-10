package com.pbking.facebook.delegates.notifications
{
	import com.pbking.facebook.Facebook;
	import com.pbking.facebook.data.notifications.Notification;
	import com.pbking.facebook.data.notifications.NotificationList;
	import com.pbking.facebook.delegates.FacebookDelegate;
	
	import mx.logging.Log;

	public class GetNotifications_delegate extends FacebookDelegate
	{
		
		public var notifications:Object = new Object();
		public var notificationLists:Object = new Object();
		
		public function GetNotifications_delegate(fBook:Facebook)
		{
			super(fBook);

			Log.getLogger("pbking.facebook").debug("getting notifications");
			
			fbCall.post("facebook.notifications.get");
		}
		
		override protected function handleResult(resultXML:XML):void
		{
			default xml namespace = fBook.FACEBOOK_NAMESPACE;
				
			for each(var noteData:XML in resultXML.children())
			{
				if(noteData.@list == "true")
				{
					var newList:NotificationList = new NotificationList();
					for each(var listItem:XML in noteData.children)
					{
						newList.addItem(listItem);
					}
					notificationLists[noteData.name().localName] = newList;
				}
				else
				{
					var newNote:Notification = new Notification();
					newNote.unread = noteData.messages.unread;
					newNote.most_recent = noteData.messages.most_recent;
					notifications[noteData.name().localName] = newNote;
				}
			}
		}
		
	}
}