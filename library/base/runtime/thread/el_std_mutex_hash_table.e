note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-12 18:20:58 GMT (Thursday 12th October 2017)"
	revision: "2"

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
