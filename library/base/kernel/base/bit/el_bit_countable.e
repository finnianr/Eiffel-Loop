note
	description: "[
		Object that operates on data with a bit-size characteristic corresponding to **bit_count**
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-07-27 5:49:23 GMT (Thursday 27th July 2023)"
	revision: "1"

deferred class
	EL_BIT_COUNTABLE

inherit
	ANY
		undefine
			copy, default_create, is_equal, out
		end

feature -- Measurement

	bit_count: INTEGER
		-- number of bits
		deferred
		end

end