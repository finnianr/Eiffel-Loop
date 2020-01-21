note
	description: "Eros makeable result"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-21 12:34:08 GMT (Tuesday 21st January 2020)"
	revision: "2"

class
	EROS_MAKEABLE_RESULT [G -> EL_MAKEABLE create make end]

inherit
	EROS_RESULT [G]
		redefine
			set_default_item
		end

create
	make_call

convert
	item: {G}

feature {NONE} -- Implementation

	set_default_item
		do
			create item.make
		end
end
