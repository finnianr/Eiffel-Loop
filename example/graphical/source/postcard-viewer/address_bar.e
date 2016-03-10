note
	description: "Summary description for {DIRECTORY_SELECT_BOX}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:32:12 GMT (Thursday 11th December 2014)"
	revision: "3"

class
	ADDRESS_BAR

inherit
	SD_TOOL_BAR_CONTENT

	EL_MODULE_GUI
		undefine
			default_create, copy, is_equal
		end
create
	make

feature {NONE} -- Initialization

	make (a_open_action: PROCEDURE [ANY, TUPLE])
		local
			l_button: SD_TOOL_BAR_BUTTON
			list: ARRAYED_SET [SD_TOOL_BAR_ITEM]
		do
			create list.make (2)
			location_input := GUI.text_field (40)

			list.extend (bar_item (location_input, "Address box"))

			create l_button.make
			l_button.set_text ("Open")
			l_button.set_name ("Open address")
--			l_button.set_pixel_buffer (sd_shared.icons.close_all)
			l_button.select_actions.extend (a_open_action)
			l_button.set_description ("Open button")
			list.extend (l_button)

			make_with_items ("Address bar", list)

			if {PLATFORM}.is_windows then
				location_input.set_text ("C:\Users\finnian\Pictures\Postcards")
			else
				location_input.set_text ("/home/finnian/Pictures/Scenery/Tibet")
			end
		end

feature -- Access

	location: EL_DIR_PATH
		do
			Result := location_input.text
		end

feature {NONE} -- Implementation

	bar_item (a_widget: EV_WIDGET; a_description: STRING): SD_TOOL_BAR_WIDGET_ITEM
		do
			create Result.make (a_widget)
			Result.set_description (a_description)
		end

	location_input: EV_TEXT_FIELD
end
