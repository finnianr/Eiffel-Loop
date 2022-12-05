note
	description: "Summary description for {EV_RADIO_BUTTON_IMP_EIFFEL_FEATURE_EDITOR}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-12-18 12:55:12 GMT (Friday 18th December 2015)"
	revision: "1"

class
	EV_RADIO_BUTTON_IMP_EIFFEL_FEATURE_EDITOR

inherit
	OVERRIDE_FEATURE_EDITOR
		redefine
			write_edited_lines
		end

create
	make

feature -- Basic operations

	write_edited_lines (output_path: FILE_PATH)
		local
		do
			class_header.find_first_true (agent {ZSTRING}.has_substring (Class_EV_RADIO_PEER_IMP))
			class_header.put_right ("%T%Trename")
			class_header.forth
			class_header.insert_line_right ("enable_select as set_checked", 3)

			class_header.find_first_true (agent {ZSTRING}.has_substring (Class_WEL_RADIO_BUTTON))
			class_header.find_next_true (agent {ZSTRING}.ends_with_zstring (Indented_keyword_end))
			class_header.back
			class_header.put_right ("%T%Tselect")
			class_header.forth
			class_header.insert_line_right ("set_checked", 3)

			Precursor (output_path)
		end

feature {NONE} -- Implementation

	new_feature_edit_actions: like feature_edit_actions
		do
			create Result.make_size (0)
		end

feature {NONE} -- Constants

	Class_WEL_RADIO_BUTTON: ZSTRING
		once
			Result := "WEL_RADIO_BUTTON"
		end

	Class_EV_RADIO_PEER_IMP: ZSTRING
		once
			Result := "EV_RADIO_PEER_IMP"
		end

end

