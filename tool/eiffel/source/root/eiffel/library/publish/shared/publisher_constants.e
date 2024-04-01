note
	description: "Publisher constants"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-04-01 12:05:33 GMT (Monday 1st April 2024)"
	revision: "16"

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

	Source_span_template: ZSTRING
		once
			Result := "[
				<span id="source">#</span>
			]"
		end

feature {NONE} -- Strings

	Tag: TUPLE [li, li_close, oli, oli_close: ZSTRING]
		once
			create Result
			Tuple.fill (Result, "[li], [/li], [oli], [/oli]")
		end

	Current_dir_forward_slash: ZSTRING
		once
			Result := "./"
		end

	Html: ZSTRING
		once
			Result := "html"
		end

feature {NONE} -- Constants

	Class_link_list: CLASS_LINK_LIST
		once
			create Result.make (20)
		end

end