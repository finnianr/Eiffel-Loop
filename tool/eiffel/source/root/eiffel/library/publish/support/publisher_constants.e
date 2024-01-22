note
	description: "Publisher constants"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-22 14:05:12 GMT (Monday 22nd January 2024)"
	revision: "12"

deferred class
	PUBLISHER_CONSTANTS

inherit
	EL_ANY_SHARED

	EL_MODULE_TUPLE

	EL_CHARACTER_32_CONSTANTS

feature {NONE} -- Strings

	A_href_template: ZSTRING
		once
			Result := "[
				<a href="#"# target="_blank">#</a>
			]"
		ensure
			three_markers: Result.occurrences ('%S') = 3
		end

	Dollor_left_brace: ZSTRING
		once
			Result := "${"
		end

	Github_link_template: ZSTRING
		once
			Result := "[%S](%S)"
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