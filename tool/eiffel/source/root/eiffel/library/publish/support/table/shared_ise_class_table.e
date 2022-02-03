note
	description: "Shared instance of [$source ISE_CLASS_TABLE]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-11-24 12:32:01 GMT (Wednesday 24th November 2021)"
	revision: "3"

deferred class
	SHARED_ISE_CLASS_TABLE

inherit
	EL_ANY_SHARED

feature {NONE} -- Constants

	ISE_class_table: ISE_CLASS_TABLE
		once ("PROCESS")
			Result := create {EL_SINGLETON [ISE_CLASS_TABLE]}
		end
end