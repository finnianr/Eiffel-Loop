note
	description: "Evolicity compiled template"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-07-10 14:30:05 GMT (Monday 10th July 2023)"
	revision: "10"

class
	EVOLICITY_COMPILED_TEMPLATE

inherit
	EVOLICITY_COMPOUND_DIRECTIVE
		rename
			make as make_directive
		end

create
	make

feature {NONE} -- Initialization

	make (directives: ARRAY [EVOLICITY_DIRECTIVE]; a_modification_time: INTEGER; a_encoding: like encoding)
		do
			make_from_array (directives)
			modification_time := a_modification_time
			encoding := a_encoding
		end

feature -- Access

	modification_time: INTEGER

	encoding: EL_ENCODEABLE_AS_TEXT

feature -- Status query

	has_file_source: BOOLEAN
		do
			Result := encoding.encoding_type.to_boolean
		end

feature -- Element change

	set_modification_time (a_modification_time: INTEGER)
		do
			modification_time := a_modification_time
		end

end