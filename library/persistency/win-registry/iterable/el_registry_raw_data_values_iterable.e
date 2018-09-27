note
	description: "Registry raw data values iterable"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:14 GMT (Thursday 20th September 2018)"
	revision: "5"

class
	EL_REGISTRY_RAW_DATA_VALUES_ITERABLE

inherit
	EL_REGISTRY_ITERABLE [TUPLE [name: ZSTRING; data: MANAGED_POINTER]]

create
	make

feature -- Access: cursor

	new_cursor: EL_REGISTRY_RAW_DATA_ITERATION_CURSOR
		do
			create Result.make (reg_path)
		end
end