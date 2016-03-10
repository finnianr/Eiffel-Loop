note
	description: "Summary description for {EV_RADIO_BUTTON_IMP_EIFFEL_FEATURE_EDITOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EV_RADIO_BUTTON_IMP_EIFFEL_FEATURE_EDITOR

inherit
	EIFFEL_OVERRIDE_FEATURE_EDITOR
		redefine
			write_edited_lines
		end

create
	make

feature -- Basic operations

	write_edited_lines (output_path: EL_FILE_PATH)
		local
		do
			class_header.find_first (True, agent {ASTRING}.has_substring ("EV_RADIO_PEER_IMP"))
			class_header.put_right ("%T%Trename")
			class_header.forth
			class_header.insert_line_right ("enable_select as set_checked", 3)

			class_header.find_first (True, agent {ASTRING}.has_substring ("WEL_RADIO_BUTTON"))
			class_header.find_next (True, agent {ASTRING}.ends_with ("%Tend"))
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

end
