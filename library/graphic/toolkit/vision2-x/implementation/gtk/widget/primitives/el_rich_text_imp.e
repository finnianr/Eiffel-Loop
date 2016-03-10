note
	description: "Summary description for {EL_RICH_TEXT_IMP}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-03-02 17:27:35 GMT (Saturday 2nd March 2013)"
	revision: "2"

class
	EL_RICH_TEXT_IMP
inherit
	EL_RICH_TEXT_I
		undefine
			text_length, selected_text, next_change_of_character
		redefine
			interface
		end

	EV_RICH_TEXT_IMP
		redefine
			interface, on_key_event
		end

create
	make

feature {EV_ANY, EV_ANY_I} -- Implementation		

	on_key_event (a_key: detachable EV_KEY; a_key_string: detachable STRING_32; a_key_press: BOOLEAN)
			-- Used for key event actions sequences.
		local
			l_app: like App_implementation
			l_key_processed: BOOLEAN
		do
			if a_key_press and then a_key /= Void then
				l_app := App_implementation
				if not (l_app.ctrl_pressed or else l_app.alt_pressed or else l_app.shift_pressed) then
					inspect a_key.code
						when {EV_KEY_CONSTANTS}.key_home then
							scroll_to_line (1); l_key_processed := True

						when {EV_KEY_CONSTANTS}.key_end then
							scroll_to_end; l_key_processed := True

					else
					end
				end
			end
			if not l_key_processed then
				Precursor {EV_RICH_TEXT_IMP} (a_key, a_key_string, a_key_press)
			end
		end

	interface: detachable EL_RICH_TEXT note option: stable attribute end;

end
