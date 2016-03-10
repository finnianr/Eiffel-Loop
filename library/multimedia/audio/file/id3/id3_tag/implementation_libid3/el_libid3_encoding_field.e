note
	description: "Summary description for {EL_LIBID3_ENCODING_FIELD}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:34:36 GMT (Thursday 11th December 2014)"
	revision: "4"

class
	EL_LIBID3_ENCODING_FIELD

inherit
	EL_LIBID3_FIELD
		redefine
			encoding, type, set_encoding, is_encoding
		end

create
    make_from_pointer

feature -- Access

	encoding: INTEGER
			--
		do
			Result := libid3_encoding_to_standard (integer)
		end

	type: INTEGER
			--
		do
			Result := Type_encoding
		end

feature -- Element change

	set_encoding (a_encoding: INTEGER)
		do
			set_data_integer (standard_encoding_to_libid3 (a_encoding))
		end

feature -- Status query

	is_encoding: BOOLEAN
		do
			Result := True
		end
end
