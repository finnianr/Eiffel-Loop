note
	description: "Std mutex hash table"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:04 GMT (Tuesday 15th November 2022)"
	revision: "5"

class
	EL_STD_MUTEX_HASH_TABLE [G, H -> HASHABLE]

inherit
	EL_MUTEX_REFERENCE [HASH_TABLE [G, H]]
		rename
			make as make_synchronized
		end

create
	make

feature {NONE} -- Initialization

	make (size: INTEGER)
			--
		do
			make_synchronized (create {HASH_TABLE [G, H]}.make (size))
		end

end