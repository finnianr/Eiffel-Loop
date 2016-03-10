note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:30 GMT (Sunday 16th December 2012)"
	revision: "1"

class
	EL_STD_SYNCHRONIZED_HASH_TABLE [G, H -> HASHABLE]

inherit
	EL_STD_SYNCHRONIZED_REF [HASH_TABLE [G, H]]
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

