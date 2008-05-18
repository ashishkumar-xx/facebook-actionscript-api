package com.pbking.facebook
{
	import flash.external.ExternalInterface;
	
	import mx.controls.Alert;
	
	public class FacebookJSBridge
	{
		private static var externalInterfaceCallId:uint = 0;
		private static var externalInterfaceInitialized:Boolean;
		private static var externalInterfaceCallbacks:Object = {};
		
		public function FacebookJSBridge()
		{
			//nothing here
		}

		public static function postBridgeAsync(method:String, args:Object, instanceCallback:Function, fb_js_api_name:String, as_app_name:String):void
		{
			if(!externalInterfaceInitialized)
			{
				ExternalInterface.addCallback("bridgeFacebookReply", postBridgeAsyncReply);
				externalInterfaceInitialized = true;
			}

			externalInterfaceCallId++;
			
			externalInterfaceCallbacks[externalInterfaceCallId] = instanceCallback;
			
			var bridgeCallFunctionName:String = "bridgeFacebookCall_"+externalInterfaceCallId;
			
			var bridgeCall:String = 
				"function "+bridgeCallFunctionName+"(method, args){"+
				    //"alert('calling > "+externalInterfaceCallId+"');" +
					fb_js_api_name+"._callMethod$1(method, args, " + 
							"function(result, exception){" + 
								//"alert('reply > "+externalInterfaceCallId+"');" +
								"document."+as_app_name+".bridgeFacebookReply(result, exception, "+externalInterfaceCallId+");" + 
							"});" + 
				"}";

			//Alert.show("calling > " + externalInterfaceCallId);

			ExternalInterface.call(bridgeCall, method, args);
		}
		
		private static function postBridgeAsyncReply(result:Object, exception:Object, exCallId:uint):void
		{
			//Alert.show("reply > " + exCallId + "|" + externalInterfaceCallbacks[exCallId]);
			externalInterfaceCallbacks[exCallId](result, exception);
			delete externalInterfaceCallbacks[exCallId];
		}
		
	}
}