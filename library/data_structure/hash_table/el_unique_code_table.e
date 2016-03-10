note
	description: "Summary description for {EL_UNIQUE_CODE_TABLE}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:27 GMT (Sunday 16th December 2012)"
	revision: "1"

class
	EL_UNIQUE_CODE_TABLE [K -> HASHABLE]

inherit
	EL_CODE_TABLE [K]
		rename
			put as put_code,
			found_item as last_code
		export
			{NONE} all
			{ANY} last_code, search, found, item
		end

create
	make

feature -- Element change

	put (key: K)
			--
		do
			search (key)
			if not found then
				extend (count + 1, key)
				last_code := count
			end
		end

end
