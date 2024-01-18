note
	description: "Implementation of ${EL_STRING_32_BUFFER_I}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:04 GMT (Tuesday 15th November 2022)"
	revision: "2"

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