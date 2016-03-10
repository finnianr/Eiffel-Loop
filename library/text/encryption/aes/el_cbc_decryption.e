note
	description: "Summary description for {EL_CBC_DECRYPTION}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:34:35 GMT (Thursday 11th December 2014)"
	revision: "3"

class
	EL_CBC_DECRYPTION

inherit
	CBC_DECRYPTION
		rename
			last as last_block
		export
			{ANY} last_block
		end

create
	make

end
