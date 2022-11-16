note
	description: "Tl shared frame id bytes"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "4"

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