note
	description: "Shared list of invalid class name references in ''$source'' links"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-11-24 13:47:50 GMT (Wednesday 24th November 2021)"
	revision: "2"

deferred class
	SHARED_INVALID_CLASSNAMES

inherit
	EL_ANY_SHARED

feature {NONE} -- Constants

	Invalid_source_name_table: EL_GROUP_TABLE [STRING, EL_FILE_PATH]
		-- map source path to group of invalid class names
		once
			create Result.make (20)
		end
end