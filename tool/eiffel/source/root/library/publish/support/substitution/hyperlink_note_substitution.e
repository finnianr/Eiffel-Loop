note
	description: "Expand hyperlink in class note"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-03-02 9:46:09 GMT (Tuesday 2nd March 2021)"
	revision: "1"

class
	HYPERLINK_NOTE_SUBSTITUTION

inherit
	HYPERLINK_SUBSTITUTION
		redefine
			new_expanded_link
		end

	PUBLISHER_CONSTANTS

create
	make

feature {NONE} -- Implementation

	new_expanded_link (path, text: ZSTRING): ZSTRING
		local
			l_path: ZSTRING; html_path: EL_FILE_PATH
		do
			l_path := path
			if path.starts_with (Current_dir_forward_slash) and then path.occurrences ('/') > 1 then
				html_path := path.substring_end (Current_dir_forward_slash.count + 1)
				l_path := html_path.universal_relative_path (relative_page_dir)
			end
			Result := A_href_template #$ [l_path, text]
		end

feature {NONE} -- Constants

	Current_dir_forward_slash: ZSTRING
		once
			Result := "./"
		end

end