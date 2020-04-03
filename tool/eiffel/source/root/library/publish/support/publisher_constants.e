note
	description: "Publisher constants"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-04-03 18:05:01 GMT (Friday 3rd April 2020)"
	revision: "1"

deferred class
	PUBLISHER_CONSTANTS

inherit
	EL_ANY_SHARED

feature {NONE} -- Constants

	Html: ZSTRING
		once
			Result := "html"
		end

	Library: ZSTRING
		once
			Result := "library"
		end

	Note_description: ZSTRING
		once
			Result := "description"
		end

	Relative_root: EL_DIR_PATH
		once
			create Result
		end

	Source_link: ZSTRING
		once
			Result := "[$source"
		end

end
