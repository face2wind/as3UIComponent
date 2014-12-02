package face2wind.uiComponents
{
	import flash.events.MouseEvent;
	import flash.text.TextFieldAutoSize;
	
	import face2wind.uiComponents.controll.RadioButtonGroup;
	import face2wind.uiComponents.enum.RadioButtonType;
	
	import face2wind.view.BaseSprite;
	
	/**
	 * 单选按钮组件
	 * @author face2wind
	 */
	public class RadioButton extends BaseSprite
	{
		/**
		 * 选中 - 普通状态 
		 */		
		private var selected_upBg:ResBitmap;
		
		/**
		 * 选中 - 按下状态 
		 */		
		private var selected_downBg:ResBitmap;
		
		/**
		 * 选中 - 鼠标移上状态 
		 */		
		private var selected_overBg:ResBitmap;
		
		/**
		 * 非选中 - 普通状态 
		 */		
		private var unselected_upBg:ResBitmap;
		
		/**
		 * 非选中 - 按下状态 
		 */		
		private var unselected_downBg:ResBitmap;
		
		/**
		 * 非选中 - 鼠标移上状态 
		 */		
		private var unselected_overBg:ResBitmap;
		
		/**
		 * 当前正在显示的背景（引用） 
		 */		
		private var curOnshowBg:ResBitmap;
		
		/**
		 * 文本 
		 */		
		private var labelTxt:CustomTextfield;
		
		private var _selected:Boolean = false;
		/**
		 * 当前是否被选中 
		 */
		public function get selected():Boolean
		{
			return _selected;
		}
		/**
		 * @private
		 */
		public function set selected(value:Boolean):void
		{
			if(_selected == value)
				return;
			
			_selected = value;
			selectChange = true;
			propertyChange();
		}
		
		/**
		 * 选中状态被改变 
		 */		
		private var selectChange:Boolean = false;
		
		private var _skin:int = RadioButtonType.NORMAL;
		
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
			skinChange = true;
			propertyChange();
		}
		
		/**
		 * 皮肤改变 
		 */		
		private var skinChange:Boolean = false;

		
		/**
		 * 构造单选按钮 
		 * @param newGroup 单选按钮组控制器
		 * @param newSkin 皮肤
		 * 
		 */		
		public function RadioButton(newSkin:int = 1, newGroup:RadioButtonGroup = null )
		{
			super();
			skin = newSkin;
			group = newGroup;
		}
		
		/**
		 * 此函数是视图的内容初始化函数<br/>对父类的覆盖 
		 * 
		 */		
		protected override function createChildren():void
		{
			super.createChildren();
			
//			buttonBg = new ResBitmap();
//			buttonBg.addEventListener(Event.COMPLETE , onBtnBgLoadCompleteHandle);
//			buttonBg.source = "radio_"+skin+"_up";
//			addChild(buttonBg);
			
			selected_upBg = new ResBitmap();
			selected_overBg = new ResBitmap();
			selected_downBg = new ResBitmap();
			
			unselected_upBg = new ResBitmap();
			unselected_overBg = new ResBitmap();
			unselected_downBg = new ResBitmap();
			
			updateSkin();
//			selectedBtn = new BaseButton("radio_"+skin+"_selected_up",null,"radio_"+skin+"_selected_over");
////			addChild(selectedBtn);
//			
//			unselectedBtn = new BaseButton("radio_"+skin+"_unselected_up",null,"radio_"+skin+"_unselected_over");
//			addChild(unselectedBtn);
			
			curOnshowBg = unselected_upBg;
			addChild(unselected_upBg);
			
			labelTxt = new CustomTextfield();
			labelTxt.autoSize = TextFieldAutoSize.LEFT;
			addChild(labelTxt);
			
			buttonMode = true;
		}
		
		/**
		 * 重新加载皮肤 
		 * 
		 */		
		private function updateSkin():void
		{
			selected_upBg.source = "radio_"+skin+"_selected_up";
			selected_downBg.source = "radio_"+skin+"_selected_up";
			selected_overBg.source = "radio_"+skin+"_selected_over";
			
			unselected_upBg.source = "radio_"+skin+"_unselected_up";
			unselected_downBg.source = "radio_"+skin+"_unselected_up";
			unselected_overBg.source = "radio_"+skin+"_unselected_over";
		}
		
		private var _label:String = "";
		/**
		 * 设置label显示文本 
		 * @param value
		 * 
		 */		
		public function set label(value:String):void
		{
			_label = value;
			labelChange = true;
			propertyChange();
		}

		private var _group:RadioButtonGroup;
		/**
		 * 单选组件所属的组管理器（为空则表示这是一个孤立的单选按钮） 
		 */
		public function get group():RadioButtonGroup
		{
			return _group;
		}
		/**
		 * @private
		 */
		public function set group(value:RadioButtonGroup):void
		{
			if(_group)
				_group.removeItem(this);
			_group = value;
			if(_group)
				_group.addItem(this);
		}

		private var _enable:Boolean = true;
		/**
		 * 是否可点击（若不可点击，则按钮会变灰） 
		 */
		public function get enable():Boolean
		{
			return _enable;
		}
		/**
		 * @private
		 */
		public function set enable(value:Boolean):void
		{
			_enable = value;
			if(_enable)
				fade = true;
			else
				fade = false;
		}
		
		/**
		 * label内容被改变 
		 */		
		private var labelChange:Boolean = false;
		
		/**
		 * 更新文本位置 
		 * 
		 */		
		private function updateLabelPosition():void
		{
//			labelTxt.x = buttonBg.width + 2;
//			labelTxt.y = (buttonBg.height - labelTxt.height)/2;
			labelTxt.x = curOnshowBg.width + 2; //理论上，选中和非选中的按钮素材宽高一样，所以这里用非选中素材的宽高
			labelTxt.y = (curOnshowBg.height - labelTxt.height)/2;
		}
		
		/**
		 * 点击事件 
		 * @param event
		 * 
		 */		
		protected function onRadioBtnMouseClickedHandler(event:MouseEvent):void
		{
			if(!_enable) //禁止点击后，不能通过点击来切换状态（可以直接设置来切换）
				return;
			
			selected = true;
		}
		
		/**
		 * 鼠标移出 
		 * @param event
		 * 
		 */		
		protected function onRadioBtnMouseOutHandler(event:MouseEvent):void
		{
			if(contains(curOnshowBg))
				removeChild(curOnshowBg);
			if(selected)
			{
				addChild(selected_upBg);
				curOnshowBg = selected_upBg;
			}
			else
			{
				addChild(unselected_upBg);
				curOnshowBg = unselected_upBg;
			}
		}
		
		/**
		 * 鼠标移上去
		 * @param event
		 * 
		 */		
		protected function onRadioBtnMouseOverHandler(event:MouseEvent):void
		{
			if(contains(curOnshowBg))
				removeChild(curOnshowBg);
			if(selected)
			{
				addChild(selected_overBg);
				curOnshowBg = selected_overBg;
			}
			else
			{
				addChild(unselected_overBg);
				curOnshowBg = unselected_overBg;
			}
		}
		
		/**
		 * 属性变更，更新视图 
		 * 
		 */		
		protected override function update():void
		{
			super.update();
			if(selectChange)
			{
				if(selected)
				{
//					buttonBg.source = "radio_"+skin+"_selected";
					if(contains(curOnshowBg))
						removeChild(curOnshowBg);
					addChild(selected_upBg);
				}
				else
				{
//					buttonBg.source = "radio_"+skin+"_up";
					if(contains(curOnshowBg))
						removeChild(curOnshowBg);
					addChild(unselected_upBg);
				}
				if(selected && group)
					group.selectItem(this);
				selectChange = false;
			}
			if(labelChange)
			{
				labelTxt.text = _label;
				labelChange = false;
			}
			if(skinChange)
			{
				updateSkin();
//				selectedBtn.updateBtnSkins("radio_"+skin+"_selected_up",null,"radio_"+skin+"_selected_over");
//				unselectedBtn.updateBtnSkins("radio_"+skin+"_unselected_up",null,"radio_"+skin+"_unselected_over");
				updateLabelPosition();
				skinChange = false;
			}
		}
		
		/**
		 * 被加到显示列表时执行 
		 */		
		public override function onShowHandler():void
		{
			super.onShowHandler();
			addEventListener(MouseEvent.MOUSE_DOWN , onRadioBtnMouseClickedHandler);
			addEventListener(MouseEvent.MOUSE_OVER , onRadioBtnMouseOverHandler);
			addEventListener(MouseEvent.MOUSE_OUT , onRadioBtnMouseOutHandler);
		}
		
		/**
		 * 从显示列表移除时执行 
		 */		
		public override function onHideHandler():void
		{
			super.onHideHandler();
			removeEventListener(MouseEvent.MOUSE_DOWN , onRadioBtnMouseClickedHandler);
			removeEventListener(MouseEvent.MOUSE_OVER , onRadioBtnMouseOverHandler);
			removeEventListener(MouseEvent.MOUSE_OUT , onRadioBtnMouseOutHandler);
		}
	}
}