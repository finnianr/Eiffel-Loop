note
	description: "Summary description for {EL_EIFFEL_TEXT_EDITOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	EL_EIFFEL_TEXT_EDITOR

inherit
	EL_TEXT_EDITOR
		redefine
			put_string
		end

feature {NONE} -- Implementation

	put_string (str: READABLE_STRING_GENERAL)
			-- Write `s' at current position.
		do
			if is_utf8_encoded then
				output.put_string (String.as_utf8 (str))
			else
				if attached {ASTRING} str as el_str then
					output.put_string (el_str.to_latin1)
				else
					output.put_string (str.to_string_8)
				end
			end
		end
end
