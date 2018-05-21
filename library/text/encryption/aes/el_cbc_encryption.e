note
	description: "Cbc encryption"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 17:36:22 GMT (Saturday 19th May 2018)"
	revision: "3"

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