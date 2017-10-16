note
	description: "Summary description for {EL_CBC_ENCRYPTION}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-12 18:21:01 GMT (Thursday 12th October 2017)"
	revision: "2"

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