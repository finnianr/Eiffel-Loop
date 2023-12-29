note
	description: "64-bit implementation of [$source EL_BIT_COUNTABLE]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-07-27 5:01:57 GMT (Thursday 27th July 2023)"
	revision: "1"

deferred class
	EL_64_BIT_IMPLEMENTATION

inherit
	EL_BIT_COUNTABLE

feature -- Measurement

	Bit_count: INTEGER = 64

end