note
	description: "Document MIME type and encoding"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-18 7:58:22 GMT (Friday 18th February 2022)"
	revision: "10"

class
	EL_DOC_TYPE

inherit
	ANY

	EL_MODULE_ENCODING
		rename
			Encoding as Mod_encoding
		export
			{ANY} Mod_encoding
		end

create
	make

feature {NONE} -- Initialization

	make (a_type: STRING; a_encoding: NATURAL)
		require
			valid_encoding: Mod_encoding.is_valid (a_encoding)
		do
			create encoding.make (a_encoding)
			type := a_type; specification := new_specification
		end

feature -- Access

	encoding: EL_ENCODING

	specification: STRING

	type: STRING

feature -- Comparison

	same_as (other: EL_DOC_TYPE): BOOLEAN
		do
			Result := encoding.same_as (other.encoding) and type ~ other.type
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
end