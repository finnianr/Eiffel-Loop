note
	description: "Tl string"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-10-27 17:10:03 GMT (Sunday   27th   October   2019)"
	revision: "1"

class
	TL_STRING

inherit
	MANAGED_POINTER
		rename
			make as make_sized
		export
			{NONE} all
			{ANY} item
		end

	TL_STRING_CPP_API undefine copy, is_equal end

	STRING_HANDLER undefine copy, is_equal end

	EL_SHARED_ONCE_STRING_8


create
	make

feature {NONE} -- Initialization

	make
		local
			n: INTEGER
		do
			n := c_size_of_utf16
			make_sized (c_size_of)
		end

feature -- Conversion

	to_string: ZSTRING
		do
			create Result.make (0)
		end

feature {NONE} -- Implementation

	shared_content: STRING
		do
			Result := empty_once_string_8
			Result.grow (size)
			Result.set_count (size)
		end

	size: INTEGER
		do
			Result := cpp_size (item)
		end

end
