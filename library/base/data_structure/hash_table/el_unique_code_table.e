note
	description: "Unique code table"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-11-11 10:27:46 GMT (Wednesday 11th November 2020)"
	revision: "6"

class
	EL_UNIQUE_CODE_TABLE [K -> HASHABLE]

inherit
	EL_CODE_TABLE [K]
		rename
			put as put_code,
			found_item as last_code
		export
			{NONE} all
			{ANY} last_code, search, found, item, count
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