note
	description: "Action exception manager"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-08-02 11:48:39 GMT (Monday 2nd August 2021)"
	revision: "10"

class
	EL_ACTION_EXCEPTION_MANAGER [D -> EL_INFORMATION_VIEW_DIALOG create make_info end]

inherit
	EXCEPTION_MANAGER

	EL_MODULE_DEFERRED_LOCALE

	EL_MODULE_SCREEN

create
	make

feature {NONE} -- Initialization

	make (a_parent_window: EV_WINDOW; a_error_list: like error_list; a_new_properties: like new_properties)
		do
			parent_window := a_parent_window; error_list := a_error_list
			new_properties := a_new_properties
		end

feature -- Status query

	error_occurred: BOOLEAN

	successfull: BOOLEAN
		do
			Result := not error_occurred
		end

feature -- Status change

	clear_error
		do
			error_occurred := False
		end

feature -- Basic operations

	try (a_action: PROCEDURE)
		local
			condition_found: BOOLEAN; title, message: ZSTRING; position_widget: EV_WIDGET
			error_dialog: D; properties: EL_DIALOG_MODEL
		do
			if error_occurred then
				title := Default_title; message := Default_message
				position_widget := parent_window.item
				across error_list as condition until condition_found loop
					if last_exception.description.same_string (condition.item.exception_message)
						and condition.item.exception_recipient_name ~ last_exception.recipient_name
					then
						condition_found := True
						title := condition.item.title
						message := condition.item.message
						position_widget := condition.item.dialog_position_widget
					end
				end
				properties := new_properties (title.as_upper)
				properties.set_text (message)
				create error_dialog.make_info (properties)
				Screen.set_position (
					error_dialog,
					position_widget.screen_x + position_widget.width // 2 - error_dialog.width // 2,
					position_widget.screen_y + position_widget.height
				)
				if position_widget = parent_window.item then

					Screen.set_y_position (error_dialog, parent_window.screen_y + (parent_window.height - parent_window.item.height))
				end
				error_dialog.show_modal_to_window (parent_window)
			else
				a_action.apply
			end
		rescue
			error_occurred := True
			retry
		end

feature -- Type definitions

	ERROR_CONDITION: TUPLE [
		exception_message: READABLE_STRING_GENERAL; exception_recipient_name: STRING
		dialog_position_widget: EV_WIDGET -- Dialog is centered below this widget
		title, message: ZSTRING
	]
		require
			never_called: False
		do
		end

feature {NONE} -- Internal attributes

	error_list: ARRAY [like ERROR_CONDITION]

	new_properties: FUNCTION [READABLE_STRING_GENERAL, EL_DIALOG_MODEL]

	parent_window: EV_WINDOW

feature {NONE} -- Constants

	Default_message: ZSTRING
		once
			if Locale.english_only then
				Locale.set_next_translation ("Something bad happened that prevented this operation!")
			end
			Result := Locale * "{something bad happened}"
		end

	Default_title: ZSTRING
		once
			Result := Locale * "Error"
		end

end