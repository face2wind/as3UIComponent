package face2wind.customUIComponents
{
	import flash.text.TextFormat;
	
	import face2wind.util.ColorUtil;
	
	import face2wind.enum.LayerEnum;
	import face2wind.manager.LayerManager;
	import face2wind.manager.StageManager;
	import face2wind.view.BaseSprite;
	import face2wind.view.MessageView;

	/**
	 * 提示信息显示类
	 * @author Face2wind
	 */
	public class Message
	{
		public function Message()
		{
		}
		
		public static function init():void
		{
			var tf:TextFormat = new TextFormat(); //信息文本默认格式
			tf.color = ColorUtil.YELLOW;
			tf.size = 15;
			
			msgTxt = new MessageView();
			msgTxt.maxNum = 10;
			msgTxt.txtFormat = tf;
			msgTxt.mouseEnabled = false;
			msgTxt.mouseChildren = false;
			
			layer = LayerManager.getInstance().getLayer(LayerEnum.MSG_LAYER);
			layer.addChild(msgTxt);
			
			StageManager.getInstance().addStageResizeFunc( onScreenResizeHandler , true);
		}
		
		/**
		 * 屏幕大小改变事件 
		 * @param w
		 * @param h
		 * 
		 */		
		private static function onScreenResizeHandler(w:Number , h:Number):void
		{
			msgTxt.x = w - 350;
			msgTxt.y = h - 300;
		}
		
		/**
		 * 信息显示类 
		 */		
		private static var msgTxt:MessageView;
		
		/**
		 * 信息所在的层 
		 */		
		private static var layer:BaseSprite;
		
		/**
		 * 显示一条信息 
		 * @param msg
		 * 
		 */		
		public static function show(msg:String):void
		{
			if(msgTxt)
			{
				msgTxt.show(msg);
			}
		}
	}
}
