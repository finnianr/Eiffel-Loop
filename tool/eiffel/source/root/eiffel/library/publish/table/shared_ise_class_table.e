note
	description: "Shared instance of ${ISE_CLASS_TABLE}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:27 GMT (Saturday 20th January 2024)"
	revision: "5"

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