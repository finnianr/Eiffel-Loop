note
	description: "Cross platform constants"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:04 GMT (Tuesday 15th November 2022)"
	revision: "2"

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