note
	description: "Summary description for {EL_ITERABLE_REGISTRY_KEYS}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:33:26 GMT (Thursday 11th December 2014)"
	revision: "4"

class
	EL_REGISTRY_KEYS_ITERABLE

inherit
	EL_REGISTRY_ITERABLE [WEL_REGISTRY_KEY]

create
	make

feature -- Access: cursor

	new_cursor: EL_REGISTRY_KEY_ITERATION_CURSOR
		do
			create Result.make (reg_path)
		end

end
