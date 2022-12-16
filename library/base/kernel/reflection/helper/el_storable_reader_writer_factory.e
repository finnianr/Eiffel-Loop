note
	description: "Factory for objects of type [$source EL_STORABLE_READER_WRITER [EL_STORABLE]]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-12-16 18:24:54 GMT (Friday 16th December 2022)"
	revision: "1"

class
	EL_STORABLE_READER_WRITER_FACTORY [G -> EL_STORABLE, S -> EL_STORABLE_READER_WRITER [G] create default_create end]

inherit
	EL_FACTORY [S]

feature -- Access

	new_item: S
		do
			create Result
		end

end