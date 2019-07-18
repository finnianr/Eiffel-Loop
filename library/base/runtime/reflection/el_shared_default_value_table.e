note
	description: "Shared access to default objects for reflective initialization system"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-07-17 7:30:41 GMT (Wednesday 17th July 2019)"
	revision: "5"

deferred class
	EL_SHARED_DEFAULT_VALUE_TABLE

inherit
	EL_ANY_SHARED

feature {NONE} -- Constants

	Default_value_table: EL_OBJECTS_BY_TYPE
		once
			create Result.make (11)
		end

end

