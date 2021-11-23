note
	description: "Shared list of invalid class name references in ''$source'' links"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-11-23 13:23:03 GMT (Tuesday 23rd November 2021)"
	revision: "1"

deferred class
	SHARED_INVALID_CLASSNAMES

inherit
	EL_ANY_SHARED

feature {NONE} -- Constants

	Invalid_classname_map: EL_HASHABLE_KEY_ARRAYED_MAP_LIST [EL_FILE_PATH, STRING]
		once
			create Result.make (20)
		end
end