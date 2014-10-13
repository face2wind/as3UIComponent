package face2wind
{
	import face2wind.customUIComponents.Message;

	/**
	 * 基础组件入口，这里包含组件的各种启动器开关
	 * @author face2wind
	 */
	public class ASUIComponent
	{
		public function ASUIComponent()
		{
		}
		
		/**
		 * 启动类库（初始化类库）  
		 * @param main 主应用程序入口对象
		 * @param onStart 主应用程序加载完毕后执行的回调
		 */
		public static function initialize():void
		{
			Message.init();
		}
	}
}