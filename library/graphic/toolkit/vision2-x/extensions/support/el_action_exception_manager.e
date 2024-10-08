note
	description: "Action exception manager"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-09-23 7:55:15 GMT (Monday 23rd September 2024)"
	revision: "15"

class
	EL_ACTION_EXCEPTION_MANAGER [D -> EL_MODELED_INFORMATION_DIALOG create make_info end]

inherit
	EXCEPTION_MANAGER

	EL_MODULE_SCREEN

	EL_SHARED_VISION_2_TEXTS

	EL_SHARED_WORD

create
	make

feature {NONE} -- Initialization

	make (a_parent_window: EV_WINDOW; a_new_properties: like new_properties)
		do
			parent_window := a_parent_window; new_properties := a_new_properties
			create error_table.make (3)
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
			title, message: ZSTRING; position_widget: EV_WIDGET
			error_dialog: D; properties: EL_DIALOG_MODEL
		do
			if error_occurred then
				if attached error_table as table
					and then table.has_key (last_exception.recipient_name)
					and then last_exception.description.same_string (table.found_item.exception_description)
				then
					title := table.found_item.title
					message := table.found_item.message
					position_widget := table.found_item.dialog_position_widget
				else
					title := Default_title; message := Default_message
					position_widget := parent_window.item
				end
				properties := new_properties (title.as_upper)
				properties.set_text (message)
				create error_dialog.make_info (properties)
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

feature -- Element change

	register_error (
		exception_recipient_name: STRING; exception_description: READABLE_STRING_GENERAL
		dialog_position_widget: EV_WIDGET; title, message: ZSTRING
	)
		-- Register error to be displayed if `exception_recipient_name' matches `last_exception.recipient_name'
		-- and `exception_description' matches `last_exception.description'
		-- Dialog is centered below widget `dialog_position_widget'
		do
			error_table [exception_recipient_name] := [
				exception_description, dialog_position_widget, title, message
			]
		end

feature {NONE} -- Internal attributes

	error_table: EL_HASH_TABLE [
		TUPLE [
			exception_description: READABLE_STRING_GENERAL; dialog_position_widget: EV_WIDGET
			title, message: ZSTRING
		],
		STRING
	]

	new_properties: FUNCTION [READABLE_STRING_GENERAL, EL_DIALOG_MODEL]

	parent_window: EV_WINDOW

feature {NONE} -- Constants

	Default_message: ZSTRING
		once
			Result := Text.something_bad_happened
		end

	Default_title: ZSTRING
		once
			Result := Word.error
		end

end