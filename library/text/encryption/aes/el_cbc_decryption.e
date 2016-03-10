note
	description: "Summary description for {EL_CBC_DECRYPTION}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:31 GMT (Sunday 16th December 2012)"
	revision: "1"

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
