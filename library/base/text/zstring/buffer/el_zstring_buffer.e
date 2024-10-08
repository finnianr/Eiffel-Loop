note
	description: "Implementation of ${EL_ZSTRING_BUFFER_I}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-08-20 11:12:23 GMT (Tuesday 20th August 2024)"
	revision: "4"

class
	EL_ZSTRING_BUFFER

inherit
	EL_ZSTRING_BUFFER_I
		redefine
			default_create
		end

feature {NONE} -- Initialization

	default_create
		do
			create buffer.make (20)
		end

feature {NONE} -- Internal attributes

	buffer: ZSTRING

end