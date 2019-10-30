note
	description: "Libid3 default field"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-10-29 12:10:54 GMT (Tuesday   29th   October   2019)"
	revision: "2"

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
