package face2wind.uiComponents
{
	import flash.display.Sprite;
	import flash.text.TextFieldType;
	import flash.text.TextFormatAlign;
	
	import face2wind.uiComponents.enum.TextInputType;
	
	import face2wind.lib.Reflection;
	import face2wind.view.BaseSprite;
	
	/**
	 * 带背景的输入文本
	 * @author face2wind
	 */
	public class TextInput extends BaseSprite
	{
		/**
		 * 输入文本 
		 */		
		private var textfield:CustomTextfield;
		
		/**
		 * 背景 
		 */		
		private var inputBg:Sprite;
		
		public function TextInput(_newSkin:int = 1)
		{
			super();
			_skin = _newSkin;
		}
		
		/**
		 * 皮肤有改动 
		 */		
		private var skinChange:Boolean = false;
		private var _skin:int = TextInputType.NORMAL;
		/**
		 * 皮肤类型 
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
			if(_skin == value)
				return;
			
			_skin = value;
			skinChange = true;
			propertyChange();
		}
		
		/**
		 * 可编辑状态被改变 
		 */		
		private var editableChange:Boolean = false;
		private var _editable:Boolean = true;
		/**
		 * 是否可编辑 
		 */
		public function get editable():Boolean
		{
			return _editable;
		}
		/**
		 * @private
		 */
		public function set editable(value:Boolean):void
		{
			if(_editable == value)
				return;
			
			_editable = value;
			editableChange = true;
			propertyChange();
		}

		
		/**
		 * 大小被改变 
		 */		
		private var sizeChange:Boolean = false;
		
		/**
		 * 此函数是视图的内容初始化函数<br/>对父类的覆盖 
		 * 
		 */		
		protected override function createChildren():void
		{
			super.createChildren();
		
			inputBg = Reflection.createSpriteInstance("textinput_" + skin + "_bg");
			addChild(inputBg);
			
			textfield = new CustomTextfield();
			textfield.mouseEnabled = true;
			textfield.type = TextFieldType.INPUT;
//			textfield.border = true;
			addChild(textfield);
			
			sizeChange = true;
		}
		
		/**
		 * 文本排列规则改变 
		 */		
		private var alignChange:Boolean = false;
		private var _align:String = TextFormatAlign.LEFT;
		/**
		 * 设置文本放置规则，默认TextFormatAlign.LEFT
		 * @param value
		 * 
		 */		
		public function set align(value:String):void
		{
			if(_align == value)
				return;
			
			_align = value;
			alignChange = true;
			propertyChange();
		}
		public function get align():String
		{
			return _align;
		}
		
		/**
		 * 重写宽度设定
		 * @param value
		 * 
		 */		
		public override function set width(value:Number):void
		{
			if(_w == value)
				return;
			
			_w = value;
			sizeChange = true;
			propertyChange();
		}
		
		/**
		 * 重写高度设定，直接设置到_h里，布局时用到 
		 * @param value
		 */		
		public override function set height(value:Number):void
		{
			if(_h == value)
				return;
			
			_h = value;
			sizeChange = true;
			propertyChange();
		}
		
		/**
		 * 文本内容改变 
		 */		
		private var textChange:Boolean = false;
		private var _text:String = "";
		/**
		 * 输入的文本内容 
		 */
		public function get text():String
		{
			return _text;
		}
		/**
		 * @private
		 */
		public function set text(value:String):void
		{
			if(_text == value || null == value)
				return;
			
			_text = value;
			textChange = true;
			propertyChange();
		}

		
		/**
		 * 属性变更，更新视图 
		 * 
		 */	
		protected override function update():void
		{
			super.update();
			if(skinChange)
			{
				if(inputBg && contains(inputBg))
					removeChild(inputBg);
				inputBg = Reflection.createSpriteInstance("textinput_" + skin + "_bg");
				addChildAt(inputBg,0);
				skinChange = false;
			}
			if(sizeChange)
			{
				inputBg.width = _w;
				inputBg.height = _h;
				var intend:Number = _h/8;
				textfield.height = _h - 2*intend;
				textfield.width = _w - 2*intend;
				textfield.move(intend,intend);
				textfield.size = int(textfield.height/1.3); //临时搞个公式，大概能让字体大小和文本高度吻合就行
				sizeChange = false;
			}
			if(alignChange)
			{
				alignChange = false;
				textfield.align = _align;
			}
			if(textChange)
			{
				textChange = false;
				textfield.text = _text;
			}
			if(editableChange)
			{
				editableChange = false;
				if(editable)
					textfield.type = TextFieldType.INPUT;
				else
					textfield.type = TextFieldType.DYNAMIC;
			}
		}
	}
}