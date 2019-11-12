note
	description: "Tl shared frame id bytes"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-11-12 19:57:27 GMT (Tuesday 12th November 2019)"
	revision: "2"

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
