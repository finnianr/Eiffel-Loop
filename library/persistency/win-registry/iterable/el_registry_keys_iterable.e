note
	description: "Registry keys iterable"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 19:24:49 GMT (Saturday 19th May 2018)"
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