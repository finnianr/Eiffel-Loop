note
	description: "Implementation of [$source EL_STRING_32_BUFFER_I]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-05-16 18:48:35 GMT (Sunday 16th May 2021)"
	revision: "1"

class
	EL_STRING_32_BUFFER

inherit
	EL_STRING_32_BUFFER_I
		redefine
			default_create
		end

feature {NONE} -- Initialization

	default_create
		do
			create buffer.make (20)
		end

feature {NONE} -- Internal attributes

	buffer: STRING_32
end