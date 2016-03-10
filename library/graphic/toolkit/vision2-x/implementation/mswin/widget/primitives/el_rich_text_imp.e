note
	description: "[
		Rich text control that responds to HOME and END keyboard shortcuts (without Ctrl combination)
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-03-02 21:12:45 GMT (Saturday 2nd March 2013)"
	revision: "2"

class
	EL_RICH_TEXT_IMP

inherit
	EL_RICH_TEXT_I
		rename
			set_selection as text_component_imp_set_selection
		undefine
			text_length, selected_text
		redefine
			interface, last_load_successful
		end

	EV_RICH_TEXT_IMP
		redefine
			interface, last_load_successful, accelerator_from_key_code
		select
			last_load_successful
		end

create
	make

feature -- Status query

	last_load_successful: BOOLEAN

feature {EV_ANY, EV_ANY_I} -- Implementation		

	accelerator_from_key_code (a_key_code: INTEGER): EV_ACCELERATOR
			-- Process HOME and END keyboard shortcuts (without Ctrl)

		local
			l_app: like application_imp
		do
			l_app := application_imp
			if l_app.ctrl_pressed or else l_app.alt_pressed or else l_app.shift_pressed then
				Result := Precursor (a_key_code)
			else
				inspect a_key_code
					when {EV_KEY_CONSTANTS}.key_home then
						l_app.do_once_on_idle (agent scroll_to_line (1))

					when {EV_KEY_CONSTANTS}.key_end then
						l_app.do_once_on_idle (agent scroll_to_end)
				else
					Result := Precursor (a_key_code)
				end
			end
		end

	interface: detachable EL_RICH_TEXT note option: stable attribute end;

feature {NONE} -- Implementation

	page_scroll (a_direction_type: INTEGER): INTEGER
			-- Returns number of lines scrolled
		require
			valid_type: Scroll_direction_types.has (a_direction_type)
		local
			l_result: POINTER
		do
			l_result := {WEL_API}.send_message_result (
				wel_item, {WEL_EM_CONSTANTS}. Em_scroll, to_wparam (a_direction_type), to_lparam (0)
			)
			check
				successful: cwin_hi_word (l_result).to_boolean
			end
			Result := cwin_lo_word (l_result)
		end

feature {NONE} -- Constants

	Scroll_direction_types: ARRAY [INTEGER]
		local
			l_types: WEL_SB_CONSTANTS
		once
			create l_types
			Result := << l_types.Sb_linedown, l_types.Sb_lineup, l_types.Sb_pagedown, l_types.Sb_pageup >>
		end

end
