note
	description: "Shared html class source table"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-03-02 12:35:50 GMT (Tuesday 2nd March 2021)"
	revision: "7"

deferred class
	SHARED_HTML_CLASS_SOURCE_TABLE

inherit
	EL_ANY_SHARED

feature {NONE} -- Constants

	Class_source_table: CLASS_SOURCE_TABLE
		once ("PROCESS")
			Result := create {EL_SINGLETON [CLASS_SOURCE_TABLE]}
		end
end