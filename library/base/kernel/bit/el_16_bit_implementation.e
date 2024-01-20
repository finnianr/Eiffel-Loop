note
	description: "16-bit implementation of ${EL_BIT_COUNTABLE}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:24 GMT (Saturday 20th January 2024)"
	revision: "2"

deferred class
	EL_16_BIT_IMPLEMENTATION

inherit
	EL_BIT_COUNTABLE

feature -- Measurement

	Bit_count: INTEGER = 16

end