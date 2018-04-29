note
	description: "Shared access to default objects for reflective initialization system"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-04-26 8:07:12 GMT (Thursday 26th April 2018)"
	revision: "4"

class
	EL_SHARED_DEFAULT_VALUE_TABLE

feature {NONE} -- Constants

	Default_value_table: EL_OBJECTS_BY_TYPE
		once
			create Result.make (11)
		end

end

