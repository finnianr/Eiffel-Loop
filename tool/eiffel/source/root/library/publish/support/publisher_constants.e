note
	description: "Publisher constants"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-03-21 11:10:22 GMT (Sunday 21st March 2021)"
	revision: "5"

deferred class
	PUBLISHER_CONSTANTS

inherit
	EL_ANY_SHARED

feature {NONE} -- Constants

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

	Relative_root: EL_DIR_PATH
		once
			create Result
		end

	Source_variable: ZSTRING
		once
			Result := "$source"
		end

end