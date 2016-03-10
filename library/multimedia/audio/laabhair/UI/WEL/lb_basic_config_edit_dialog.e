note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:28 GMT (Sunday 16th December 2012)"
	revision: "1"

deferred class
	LB_BASIC_CONFIG_EDIT_DIALOG

inherit
	EL_DIALOG
	 	redefine
	 		on_control_id_command, on_ok, Class_icon
	 	end
	
	WEL_DS_CONSTANTS
	
	LB_WEL_WINDOW_IDS
	
	LB_SHARED_CONFIGURATION

feature {NONE} -- Initialization

	make_child (a_parent: WEL_WINDOW; a_name: STRING)
			--
		do
			make_child_dialog (a_parent, a_name, 400, 200)

			add_fields
			
			-- Layout Apply button
			layout_pos.set_x (width - 120)
			layout_pos.set_y (layout_pos.y + 10)
			layout_size.set_width (62)
			layout_size.set_height (Button_height)
			
			create apply_button.make (Current, "Apply", layout_pos, layout_size, ID_apply_config_button)
			apply_button.set_font (gui_font)
			apply_button.disable
			add_control (apply_button)
						
			-- Layout OK button
			layout_pos.set_x (layout_pos.x + apply_button.width + Field_spacing )
			layout_size.set_width (32)
			layout_size.set_height (Button_height)
			
			create ok_button.make (Current, "OK", layout_pos, layout_size, IDOK)
			ok_button.set_font (gui_font)
			add_control (ok_button)

			set_height (caption_height + layout_pos.y + layout_size.height + Border_top_bottom)
		end

	add_fields
			--
		do
			add_script_file_name_field (
				"Praat Script", Config.script_file_name
			)
			add_integer_field (
				"Sample interval (millisecs)", Config.sample_interval_millisecs
			)
			add_real_field (
				"Signal threshold (Root mean square)", Config.signal_threshold
			)
		end
		
feature {NONE} -- Event handlers

	on_control_id_command  (control_id: INTEGER)
			--	
		do
			inspect control_id
				when ID_file_browse_button then
					on_file_select_script_file
	
				when ID_apply_config_button then
					apply_pending_edits
					
				when IDOK then
					on_ok
				else
			end
		end

	on_file_select_script_file
	
		do
			open_script_file_dialog.activate (Current)
			if open_script_file_dialog.selected then
				script_file_edit.set_text (open_script_file_dialog.file_name)
				script_file_edit.on_en_change
			end
		end

	on_ok
			-- Button Ok has been pressed.
		do
			if apply_button.enabled then
				apply_pending_edits
			end
			hide
		end

	on_pending_edit
			--
		do
			apply_button.enable
		end

	on_pending_edits_applied
			--
		do
			apply_button.disable
			tabbed_controls.last.set_focus
		end

feature {NONE} -- Component layout

	add_integer_field (
		field_label: STRING;
		initial_value: EL_EDITABLE_INTEGER
	)
			--
		local
			field: EL_INTEGER_EDIT_FIELD
		do
			layout_pos.set_x (Border_left_right)
			layout_size.set_width (50)
			layout_size.set_height (22)

			create field.make (Current, layout_pos, layout_size, initial_value)
			field.set_font (gui_font)
			add_control (field)
			
			add_field_label (field_label, field.width)
			layout_next_row
		end

	add_real_field (
		field_label: STRING;
		initial_value: EL_EDITABLE_REAL
	)
			--
		local
			field: EL_REAL_EDIT_FIELD
		do
			layout_pos.set_x (Border_left_right)
			layout_size.set_width (50)
			layout_size.set_height (22)

			create field.make (Current, layout_pos, layout_size, initial_value)
			field.set_font (gui_font)
			add_control (field)

			add_field_label (field_label, field.width)
			layout_next_row
		end

	add_script_file_name_field (field_label: STRING; script_name: EL_EDITABLE_STRING)
			--
		local
			label: WEL_STATIC
		do
			layout_size.set_width (100)
			layout_size.set_height (22)
			
			create label.make (
				Current, field_label,
				layout_pos.x, layout_pos.y, layout_size.width, layout_size.height,
				- 1
			)
			label.set_font (gui_font)
			
			layout_pos.set_y (layout_pos.y + layout_size.height)

			layout_size.set_width (300)
			create script_file_edit.make (Current, layout_pos, layout_size, script_name)
			script_file_edit.set_font (gui_font)
			add_control (script_file_edit)
			
			layout_pos.set_x (layout_pos.x + layout_size.width + 5)
			layout_size.set_width (65)
			layout_size.set_height (Button_height)
			create browse_button.make (Current, "Browse..", layout_pos, layout_size, id_file_browse_button)
			browse_button.set_font (gui_font)
			add_control (browse_button)
			
			layout_next_row

		end

	add_field_label (label_str: STRING; field_width: INTEGER)
			--
		do
			layout_pos.set_x (Border_left_right + field_width + 5)

			layout_size.set_width (width - layout_pos.x)
			layout_size.set_height (22 + 14 * label_str.occurrences ('%N') )
			
			add_label (label_str)
			label_list.last.set_font (gui_font)
			
		end
		
feature {NONE} -- Implementation

	open_script_file_dialog: WEL_OPEN_FILE_DIALOG
			--
		once
			create Result.make
			Result.set_title ("Select Praat script")
			Result.set_filter (
				<< "Praat script (*.psc; *.praat)",	"All file (*.*)" >>,
				<< "*.praat; *.psc", 				"*.*" >>
			)
		ensure
			result_not_void: Result /= Void
		end
		
	ok_button: EL_PUSH_BUTTON
	
	browse_button: EL_PUSH_BUTTON
	
	apply_button: EL_PUSH_BUTTON

	script_file_edit: EL_SCRIPT_NAME_EDIT_FIELD
	
feature {NONE} -- Default constants

	Class_icon: WEL_ICON
			-- Window's icon
		once
			create Result.make_by_id (Id_ico_application)
		end

	Button_height: INTEGER = 24

	Field_spacing: INTEGER = 10
	
	Border_left_right: INTEGER = 10
	
	Border_top_bottom: INTEGER = 15

end





