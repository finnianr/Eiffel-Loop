note
	description: "Shared access to default objects for reflective initialization system"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-02-21 13:44:11 GMT (Wednesday 21st February 2018)"
	revision: "3"

class
	EL_SHARED_DEFAULT_VALUE_TABLE

feature {NONE} -- Constants

	Default_value_table: EL_OBJECTS_BY_TYPE
		once
			create Result.make (11)
		end

end

