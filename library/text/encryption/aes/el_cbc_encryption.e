note
	description: "Cbc encryption"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:15 GMT (Thursday 20th September 2018)"
	revision: "5"

class
	EL_CBC_ENCRYPTION

inherit
	CBC_ENCRYPTION
		rename
			last as last_block
		export
			{ANY} last_block
		end

create
	make

end