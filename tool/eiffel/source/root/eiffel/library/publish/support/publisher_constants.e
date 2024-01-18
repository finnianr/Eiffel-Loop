note
	description: "Publisher constants"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-18 19:03:12 GMT (Thursday 18th January 2024)"
	revision: "8"

deferred class
	PUBLISHER_CONSTANTS

inherit
	EL_ANY_SHARED

feature {NONE} -- Constants

	A_href_template: ZSTRING
		-- contains to '%S' markers
		once
			Result := "[
				<a href="#"# target="_blank">#</a>
			]"
		end

	Dollor_left_brace: ZSTRING
		once
			Result := "${"
		end

	Editor: EL_ZSTRING_EDITOR
		once
			create Result.make_empty
		end

	Html: ZSTRING
		once
			Result := "html"
		end

	Library: ZSTRING
		once
			Result := "library"
		end

	Maximum_code_width: INTEGER
		once
			Result := 110
		end

	Note_description: ZSTRING
		once
			Result := "description"
		end

	Relative_root: DIR_PATH
		once
			create Result
		end

	Source_variable: ZSTRING
		once
			Result := "$source"
		end

	Source_variable_padded: ZSTRING
		once
			Result := Source_variable.twin
			Result.append_character (' ')
		end

	Wiki_source_link: ZSTRING
		once
			Result := Source_variable.twin
			Result.prepend_character ('[')
		end

end