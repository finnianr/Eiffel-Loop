note
	description: "Summary description for {EL_ACTION_MANAGER}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-12-26 11:18:45 GMT (Saturday 26th December 2015)"
	revision: "6"

class
	EL_ACTION_EXCEPTION_MANAGER [D -> EL_ERROR_DIALOG create make end]

inherit
	EXCEPTION_MANAGER

create
	make

feature {NONE} -- Initialization

	make (a_parent_window: like parent_window; a_error_conditions: like error_conditions)
		do
			parent_window := a_parent_window; error_conditions := a_error_conditions
		end

feature -- Status query

	successfull: BOOLEAN
		do
			Result := not error_occurred
		end

	error_occurred: BOOLEAN

feature -- Status change

	clear_error
		do
			error_occurred := False
		end

feature -- Basic operations

	try (a_action: PROCEDURE [ANY, TUPLE])
		local
			error_dialog: D
			condition_found: BOOLEAN
			title, message: ZSTRING
			position_widget: EV_WIDGET
		do
			if error_occurred then
				title := Default_title; message := Default_message
				position_widget := parent_window.item
				across error_conditions as condition until condition_found loop
					if condition.item.exception_message ~ last_exception.message
						and condition.item.exception_recipient_name ~ last_exception.recipient_name
					then
						condition_found := True
						title := condition.item.title
						message := condition.item.message
						position_widget := condition.item.dialog_position_widget
					end
				end
				create error_dialog.make (title.as_upper, message)
				error_dialog.set_position (
					position_widget.screen_x + position_widget.width // 2 - error_dialog.width // 2,
					position_widget.screen_y + position_widget.height
				)
				if position_widget = parent_window.item then
					error_dialog.set_y_position (parent_window.screen_y + (parent_window.height - parent_window.item.height))
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

	Type_error_condition: TUPLE [
		exception_message, exception_recipient_name: STRING
		dialog_position_widget: EV_WIDGET -- Dialog is centered below this widget
		title, message: ZSTRING
	]
		once
		end

feature {NONE} -- Implementation

	error_conditions: ARRAY [like Type_error_condition]

	parent_window: EV_WINDOW

feature {NONE} -- Constants

	Default_title: ZSTRING
		once
			Result := "ERROR"
		end

	Default_message: ZSTRING
		once
			Result := "Something bad happened that prevented this operation!"
		end

end

