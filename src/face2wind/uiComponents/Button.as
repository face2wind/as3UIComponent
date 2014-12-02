package face2wind.uiComponents
{
	import face2wind.uiComponents.enum.ButtonType;
	
	import face2wind.view.BaseButton;
	
	/**
	 * 普通按钮（拥有公共皮肤的按钮，不用disable的皮肤，直接用滤镜灰掉就行）
	 * @author face2wind
	 */
	public class Button extends BaseButton
	{
		/**
		 * 构造按钮，传入皮肤类型，默认是类型1
		 * @param newSkin 默认是ButtonType.NORMAL
		 * 
		 */		
		public function Button(newSkin:int = 1)
		{
			_skin = newSkin;
			super("button_"+_skin+"_up","button_"+_skin+"_down","button_"+_skin+"_over",null);
			updateSize();
		}
		
		private var _skin:int = ButtonType.NORMAL;
		/**
		 * 按钮皮肤（皮肤类型在ButtonType里定义）
		 */
		public function get skin():int
		{
			return _skin;
		}
		/**
		 * @private
		 */
		public function set skin(value:int):void
		{
			_skin = value;
			updateBtnSkins("button_"+_skin+"_up","button_"+_skin+"_down","button_"+_skin+"_over",null);
			updateSize();
		}
		
		private function updateSize():void
		{
			switch(skin)
			{
				case ButtonType.NORMAL:
				{
					resize(80,28);
					break;
				}
			}
		}
	}
}