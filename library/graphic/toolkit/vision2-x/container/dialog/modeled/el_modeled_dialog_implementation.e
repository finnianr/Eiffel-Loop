note
	description: "Implementation routines for ${EL_MODELED_DIALOG}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-11-10 13:21:51 GMT (Sunday 10th November 2024)"
	revision: "16"

deferred class
	EL_MODELED_DIALOG_IMPLEMENTATION

inherit
	EV_ANY_HANDLER

	EL_MODULE_ACTION; EL_MODULE_ITERABLE

	EL_MODULE_SCREEN; EL_MODULE_VISION_2;  EL_MODULE_WIDGET

	EL_SHARED_WORD; EV_SHARED_APPLICATION

feature -- Access

	layout: EL_DIALOG_LAYOUT
		do
			Result := model.layout
		end

	model: EL_DIALOG_MODEL

	style: EL_DIALOG_STYLE
		do
			Result := model.style
		end

feature -- Status query

	has_title_pixmap: BOOLEAN
		do
			Result := style.has_title_background_pixmap
		end

	has_title: BOOLEAN
		do
			Result := model.has_title
		end

	is_cancelled: BOOLEAN

feature {NONE} -- Box Factory

	new_border_box: EL_VERTICAL_BOX
		local
			button_box: EL_HORIZONTAL_BOX; inner_border_cms: REAL
		do
			inner_border_cms := layout.border_inner_width_cms - 0.05
			create Result.make_unexpanded (inner_border_cms, inner_border_cms, << new_content_widget >>)
			if model.has_buttons then
				create button_box.make_unexpanded (0, layout.button_separation_cms, new_button_row.to_array)
				if style.has_button_box_color then
					button_box.set_background_color (style.color.button_box)
				end
				Result.extend_unexpanded (button_box)
			end
			if style.has_content_area_color then
				propagate_content_area_color (Result)
			end
			Result.set_background_color (style.color.content_area)
		end

	new_box_section_list: ARRAYED_LIST [EL_BOX]
		local
			i: INTEGER
		do
			if attached new_widget_grid as list then
				create Result.make (Iterable.count (list))
				across list as row loop
					i := i + 1
					Result.extend (new_section_box (row.item, i))
				end
			else
				create Result.make (0)
			end
		end

	new_outer_box: EL_BOX
		do
			create {EL_VERTICAL_BOX} Result.make_unexpanded (
				0, layout.box_separation_cms, new_box_section_list.to_array
			)
		end

	new_section_box (widgets: ARRAY [EV_WIDGET]; section_index: INTEGER): EL_BOX
		do
			Result := Vision_2.new_horizontal_box (0, layout.row_separation_cms, widgets)

			if attached expanded_widgets as set and then set /= Empty_set then
				across Widget.box_widget_list (Result) as list loop
					if set.has (list.item) and then attached {EV_BOX} list.item.parent as box then
						box.enable_item_expand (list.item)
					end
				end
			end
		end

feature {EL_STANDARD_DIALOG} -- Factory

	new_button (a_text: READABLE_STRING_GENERAL): EL_BUTTON
		do
			if style.has_new_button_pixmap_set then
				create {EL_DECORATED_BUTTON} Result.make (new_text_pixmap (a_text))
			else
				create Result.make_with_text (a_text)
			end
		end

	new_button_list: ARRAYED_LIST [like new_button]
		do
			create Result.make (2)
			if model.has_default_button_text then
				Result.extend (default_button)
			end
			if model.has_cancel_button_text then
				Result.extend (cancel_button)
			end
		end

	new_button_row: ARRAYED_LIST [EV_WIDGET]
		do
			create Result.make (4)
			if layout.buttons_right_aligned then
				Result.extend (create {EL_EXPANDED_CELL})
			end
			across new_button_list as button loop
				Result.extend (button.item)
			end
			if layout.buttons_left_aligned then
				Result.extend (create {EL_EXPANDED_CELL})
			end
		end

	new_content_widget: EV_WIDGET
		do
			Result := new_outer_box
		end

	new_default_button: like new_button
		do
			Result := new_button (model.default_button_text)
			Result.select_actions.extend (agent on_default)
		end

	new_dialog_box: EL_VERTICAL_BOX
		do
			create Result.make_unexpanded (layout.dialog_border_width_cms, 0, Empty_set)
			window.add_title_to (Result)
			Result.extend (new_border_box)
			Result.set_background_color (style.border_color)
		end

	new_label (a_text: READABLE_STRING_GENERAL): EL_LABEL
		do
			create Result.make_with_text (a_text)
			Result.set_background_color (style.color.content_area)
			Result.set_font (style.label_font)
			Result.align_text_left
		end

	new_progress_meter: EL_PROGRESS_METER
		do
			create Result.make (
				layout.progress_meter.bar_width_cms, layout.progress_meter.bar_height_cms,
				style.progress_meter_font
			)
			Result.set_bar_color (style.color.progress_bar)
			Result.label.set_text (model.progress_meter.label_text)
			Result.set_completion_text (model.progress_meter.completion_text)
		end

	new_text_pixmap (a_text: READABLE_STRING_GENERAL): EL_SVG_TEXT_BUTTON_PIXMAP_SET
		do
			Result := style.new_button_pixmap_set (a_text, style.color.content_area)
		end

	new_wrapped_label (a_text: READABLE_STRING_GENERAL; a_width: INTEGER): EL_WRAPPED_LABEL
		do
			create Result.make_to_width (a_text, style.label_font, a_width)
		end

feature {NONE} -- Event handling

	on_cancel
		do
			if window.is_destroyed then
				if model.is_application then
					ev_application.destroy
				end
			else
				destroy
			end
			is_cancelled := True
		end

	on_default
		do
			if attached default_action as l_action then
				l_action.apply
			end
		end

	on_show
		do
		end

feature {NONE} -- Implementation

	accelerators: EV_ACCELERATOR_LIST
		-- Key combination shortcuts associated with this window.
		do
			Result := window.accelerators
		end

	cancel_action: PROCEDURE
		do
			if {PLATFORM}.is_windows then
			--	workaround to satisfy post-condition `window.is_destroyed'
				Result := agent Action.do_once_on_idle (agent on_cancel)
			else
				Result := agent on_cancel
			end
		end

	create_implementation
		do
			if has_title_pixmap or not has_title then
				create {EL_CUSTOM_TITLED_DIALOG} window.make (model)
			else
				create window.make (model)
			end
		end

	destroy
		do
			window.destroy
			if model.is_application then
				ev_application.destroy
			end
		end

	expanded_widgets: ARRAY [EV_WIDGET]
		do
			Result := Empty_set
		end

	is_content_area_color_applicable (a_widget: EV_WIDGET): BOOLEAN
		do
			if attached {EV_NOTEBOOK} a_widget or attached {EV_GRID} a_widget or attached {EV_TEXT_COMPONENT} a_widget then
				Result := False
			elseif attached {EV_FRAME} a_widget as frame and then attached {EL_PROGRESS_BAR} frame.item then
				Result := False
			else
				Result := True
			end
		end

	propagate_content_area_color (a_widget: EV_WIDGET)
		local
			list: LINEAR [EV_WIDGET]
		do
			if is_content_area_color_applicable (a_widget) then
				a_widget.set_background_color (style.color.content_area)
				if attached {EV_CONTAINER} a_widget as container then
					list := container.linear_representation
					from list.start until list.after loop
						propagate_content_area_color (list.item)
						list.forth
					end
				end
			end
		end

feature {NONE} -- Deferred

	new_widget_grid: ITERABLE [ARRAY [EV_WIDGET]]
		deferred
		end

feature {EV_ANY_HANDLER} -- Implementation: attributes

	cancel_button: like new_button

	default_button: like new_button

	default_action: PROCEDURE

	window: EL_STANDARD_DIALOG

feature {NONE} -- Constants

	Empty_set: ARRAY [EV_WIDGET]
		once
			create Result.make_empty
		end

end