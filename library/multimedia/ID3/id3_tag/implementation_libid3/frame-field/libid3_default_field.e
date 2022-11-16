note
	description: "Libid3 default field"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:05 GMT (Tuesday 15th November 2022)"
	revision: "3"

class
	LIBID3_DEFAULT_FIELD

inherit
	LIBID3_FRAME_FIELD
		redefine
			is_field_type_valid
		end

create
	make, default_create

feature -- Access

	type: NATURAL_8
		do
		end

feature -- Constant

	is_field_type_valid: BOOLEAN = True

feature {NONE} -- Constant

	Libid3_types: ARRAY [INTEGER]
		once
			create Result.make_empty
		end
end