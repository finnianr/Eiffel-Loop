note
	description: "Id3 integer field"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "2"

deferred class
	ID3_INTEGER_FIELD

inherit
	ID3_FRAME_FIELD

feature -- Access

	integer: INTEGER
			--
		deferred
		end

	type: NATURAL_8
		do
			Result := Field_type.integer
		end

feature -- Element change

	set_integer (a_integer: like integer)
			--
		deferred
		ensure
			is_set: integer = a_integer
		end
end