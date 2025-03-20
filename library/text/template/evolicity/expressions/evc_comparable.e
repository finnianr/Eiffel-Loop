note
	description: "Evolicity comparable"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-03-20 8:27:13 GMT (Thursday 20th March 2025)"
	revision: "7"

class
	EVC_COMPARABLE

inherit
	EVC_EXPRESSION

create
	make
	
feature {NONE} -- Initialization

	make (a_item: like item)
			--
		do
			item := a_item
		end

feature -- Basic operation

	evaluate (context: EVC_CONTEXT)
			--
		do
		end

feature -- Access

	item: COMPARABLE

end