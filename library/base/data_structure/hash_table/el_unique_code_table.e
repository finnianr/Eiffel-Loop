note
	description: "Summary description for {EL_UNIQUE_CODE_TABLE}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-12 18:20:58 GMT (Thursday 12th October 2017)"
	revision: "2"

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