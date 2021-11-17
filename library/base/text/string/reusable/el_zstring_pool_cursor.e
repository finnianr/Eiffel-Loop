note
	description: "Implementation of [$source EL_POOL_CURSOR [ZSTRING]]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-11-17 17:16:52 GMT (Wednesday 17th November 2021)"
	revision: "1"

class
	EL_ZSTRING_POOL_CURSOR

inherit
	EL_POOL_CURSOR [ZSTRING]

create
	make

feature {NONE} -- Constants

	Once_pool: ARRAYED_STACK [ZSTRING]
		once
			create Result.make (10)
		end
end