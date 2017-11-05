note
	description: "Summary description for {SHARED_HTML_CLASS_SOURCE_TABLE}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-18 11:19:16 GMT (Wednesday 18th October 2017)"
	revision: "2"

class
	SHARED_HTML_CLASS_SOURCE_TABLE

feature {NONE} -- Implementation

	Class_source_table: EL_ZSTRING_HASH_TABLE [EL_FILE_PATH]
		once ("PROCESS")
			create Result.make_equal (100)
		end
end
