note
	description: "Expand hyperlink in class note"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:04 GMT (Tuesday 15th November 2022)"
	revision: "4"

class
	HYPERLINK_NOTE_SUBSTITUTION

inherit
	HYPERLINK_SUBSTITUTION
		redefine
			new_expanded_link
		end

	PUBLISHER_CONSTANTS

	EL_PATH_CONSTANTS

create
	make

feature {NONE} -- Implementation

	new_expanded_link (path, text: ZSTRING): ZSTRING
		local
			l_path: ZSTRING; html_path: FILE_PATH
			first_index: INTEGER
		do
			l_path := path
			if path.starts_with (Current_dir_forward_slash) then
				first_index := Current_dir_forward_slash.count + 1
				if path.occurrences ('/') > 1 then
					html_path := path.substring_end (first_index)
					l_path := html_path.universal_relative_path (relative_page_dir)

				elseif path.valid_index (first_index) and then path [first_index] = '#' then
					l_path := Back_dir_step.multiplied (relative_page_dir.step_count) + path.substring_end (first_index)
				end

			end
			Result := A_href_template #$ [l_path, text]
		end

feature {NONE} -- Constants

	Current_dir_forward_slash: ZSTRING
		once
			Result := "./"
		end

end