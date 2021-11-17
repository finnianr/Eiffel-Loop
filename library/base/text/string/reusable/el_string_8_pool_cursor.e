note
	description: "Implementation of [$source EL_POOL_CURSOR [STRING_8]]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-11-17 17:43:24 GMT (Wednesday 17th November 2021)"
	revision: "1"

class
	EL_STRING_8_POOL_CURSOR

inherit
	EL_POOL_CURSOR [STRING_8]

create
	make

feature {NONE} -- Constants

	Once_pool: ARRAYED_STACK [STRING_8]
		once
			create Result.make (10)
		end
end