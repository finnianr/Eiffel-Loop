note
	description: "Tl shared frame id bytes"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-03-19 12:10:12 GMT (Thursday 19th March 2020)"
	revision: "3"

deferred class
	TL_SHARED_BYTE_VECTOR

inherit
	EL_ANY_SHARED

feature {NONE} -- Constants

	Once_byte_vector: TL_BYTE_VECTOR
		once
			create Result.make_empty
		end

end
