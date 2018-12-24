note
	description: "Cross platform constants"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-12-24 15:53:07 GMT (Monday 24th December 2018)"
	revision: "1"

class
	CROSS_PLATFORM_CONSTANTS

feature {NONE} -- Constants

	Implementation_ending: ZSTRING
		once
			Result := "_imp.e"
		end

	Interface_ending: ZSTRING
		once
			Result := "_i.e"
		end

end
