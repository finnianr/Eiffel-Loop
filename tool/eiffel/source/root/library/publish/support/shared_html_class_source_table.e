note
	description: "Shared html class source table"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-02-27 18:19:56 GMT (Saturday 27th February 2021)"
	revision: "6"

deferred class
	SHARED_HTML_CLASS_SOURCE_TABLE

inherit
	EL_ANY_SHARED

feature {NONE} -- Constants

	Class_source_table: CLASS_SOURCE_TABLE
		once ("PROCESS")
			create Result.make_equal (100)
		end
end