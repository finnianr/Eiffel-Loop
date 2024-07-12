note
	description: "Document text MIME type and encoding"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-07-12 12:54:07 GMT (Friday 12th July 2024)"
	revision: "13"

class
	EL_DOC_TYPE

inherit
	ANY

	EL_MODULE_ENCODING
		rename
			Encoding as Encoding_
		export
			{ANY} Encoding_
		end

	EL_SHARED_DOC_TEXT_TYPE_ENUM

create
	make, make_with_code

convert
	make_with_code ({NATURAL})

feature {NONE} -- Initialization

	make (a_type: like type; a_encoding: NATURAL)
		require
			valid_encoding: Encoding_.is_valid (a_encoding)
		do
			create encoding.make (a_encoding)
			type := a_type; specification := new_specification
		end

	make_with_code (type_and_encoding: NATURAL)
		require
			valid_type_and_encoding: valid_type_and_encoding (type_and_encoding)
		do
			make (Text_type.name ((type_and_encoding |>> 16).to_natural_8), type_and_encoding & Encoding_mask)
		end

feature -- Access

	encoding: EL_ENCODING

	specification: STRING

	type: READABLE_STRING_8

feature -- Status query

	is_utf_8_encoded: BOOLEAN
		do
			Result := encoding.encoded_as_utf (8)
		end

feature -- Comparison

	same_as (other: EL_DOC_TYPE): BOOLEAN
		do
			Result := encoding.same_as (other.encoding) and type ~ other.type
		end

feature -- Contract Support

	valid_type_and_encoding (type_and_encoding: NATURAL): BOOLEAN
		do
			if Text_type.is_valid_value ((type_and_encoding |>> 16).to_natural_8) then
				Result := Encoding_.is_valid (type_and_encoding & Encoding_mask)
			end
		end

feature {NONE} -- Implementation

	new_specification: STRING
		do
			Result := Mime_type_template #$ [type, encoding.name]
		end

feature {NONE} -- Constants

	Mime_type_template: ZSTRING
		once
			Result := "text/%S; charset=%S"
		end

feature -- Constants

	Encoding_mask: NATURAL = 0xFFFF

end