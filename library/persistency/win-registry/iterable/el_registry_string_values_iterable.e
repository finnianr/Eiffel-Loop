note
	description: "Summary description for {EL_REGISTRY_STRING_VALUES_ITERABLE}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-12 18:21:01 GMT (Thursday 12th October 2017)"
	revision: "2"

class
	EL_REGISTRY_STRING_VALUES_ITERABLE

inherit
	EL_REGISTRY_ITERABLE [TUPLE [name, value: ZSTRING]]

create
	make

feature -- Access: cursor

	new_cursor: EL_REGISTRY_STRING_VALUE_ITERATION_CURSOR
		do
			create Result.make (reg_path)
		end
end