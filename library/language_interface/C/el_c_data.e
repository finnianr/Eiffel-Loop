note
	description: "Summary description for {EL_C_DATA}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:27 GMT (Sunday 16th December 2012)"
	revision: "1"

class
	EL_C_DATA

inherit
	EL_MEMORY
		redefine
			dispose
		end

create
	make_owned, make_borrowed

feature {NONE} -- Initialization

	make_owned (ptr: POINTER)
			--
		do
			item := ptr
			is_owner := true
		end

	make_borrowed (ptr: POINTER)
			--
		do
			item := ptr
			is_owner := false
		end

feature -- Access

	item: POINTER

feature -- Status query

	is_owner: BOOLEAN

	is_void: BOOLEAN
			--
		do
			Result := not is_attached (item)
		end

feature {NONE} -- Implementation

	dispose
			--
		do
			if is_owner and then is_attached (item) then
				item.memory_free
			end
		end

end
