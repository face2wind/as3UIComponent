package face2wind.util
{
	/**
	 * 组件层-颜色统一处理工具
	 * @author face2wind
	 */
	public class ColorUtil
	{
		/**
		 * 白/灰色（道具品质）
		 */
		public static const WHITE:uint = 0xd7d5cf;
		public static const WHITE_S:String = "#d7d5cf";
		/**
		 * 绿色（道具品质）
		 */
		public static const GREEN:uint = 0x73f004;
		public static const GREEN_S:String = "#73f004";
		/**
		 * 蓝色（道具品质）
		 */
		public static const BLUE:uint = 0x02abf9;
		public static const BLUE_S:String = "#02abf9";
		/**
		 * 黄色（道具品质）
		 */
		public static const YELLOW:uint = 0xF8EF38;
		public static const YELLOW_S:String = "#F8EF38";
		/**
		 * 紫色（道具品质）
		 */
		public static const PURPLE:uint = 0xdb09f4;
		public static const PURPLE_S:String = "#db09f4"
		/**
		 * 橙色（道具品质）
		 */
		public static const ORANGE:uint = 0xff7e00;
		public static const ORANGE_S:String = "#ff7e00";
		/**
		 * 红色（道具品质）
		 */
		public static const RED:uint = 0xf10028;
		public static const RED_S:String = "#f10028";
		
		/**
		 * 转换整数颜色值为字符串（0xffffff -> "#ffffff"）
		 * @param color
		 * @return
		 *
		 */		
		public static function intToString(color:uint):String
		{
			var strColor:String = "#";
			strColor += color.toString(16);
			return strColor;
		}
	}
}