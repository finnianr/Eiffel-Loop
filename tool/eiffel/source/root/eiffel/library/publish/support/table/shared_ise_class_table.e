note
	description: "Shared instance of [$source ISE_CLASS_TABLE]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:04 GMT (Tuesday 15th November 2022)"
	revision: "4"

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