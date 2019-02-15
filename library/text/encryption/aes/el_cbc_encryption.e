note
	description: "Cbc encryption"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-02-15 17:50:20 GMT (Friday 15th February 2019)"
	revision: "6"

class
	EL_CBC_ENCRYPTION

inherit
	CBC_ENCRYPTION
		rename
			last as last_block
		export
			{ANY} last_block
		redefine
			is_equal
		end

create
	make

feature -- Comparison

	is_equal (other: like Current): BOOLEAN
		do
			Result := last_block ~ other.last_block
		end
end
