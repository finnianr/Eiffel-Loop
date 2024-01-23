note
	description: "Publisher constants"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-23 9:33:44 GMT (Tuesday 23rd January 2024)"
	revision: "14"

deferred class
	PUBLISHER_CONSTANTS

inherit
	EL_ANY_SHARED

	EL_MODULE_TUPLE

	EL_CHARACTER_32_CONSTANTS

feature {NONE} -- Templates

	Html_link_template: ZSTRING
		once
			Result := "[
				<a href="#"# target="_blank">#</a>
			]"
		ensure
			three_markers: Result.occurrences ('%S') = 3
		end

	Github_link_template: ZSTRING
		-- [link text] plus (web address)
		once
			Result := "[%S](%S)"
		end

feature {NONE} -- Strings

	Current_dir_forward_slash: ZSTRING
		once
			Result := "./"
		end

	Dollor_left_brace: ZSTRING
		once
			Result := "${"
		end

	Html: ZSTRING
		once
			Result := "html"
		end

	Source_variable: ZSTRING
		once
			Result := "$source"
		end

	Source_link_start: ZSTRING
		-- "[$source"
		once
			Result := char ('[') + Source_variable
		end

feature {NONE} -- Constants

	Class_link_list: CLASS_LINK_LIST
		once
			create Result.make (20)
		end

end