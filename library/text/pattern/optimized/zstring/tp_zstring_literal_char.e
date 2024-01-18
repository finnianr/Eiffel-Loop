note
	description: "Matches single literal character in a ${ZSTRING}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-21 14:24:59 GMT (Monday 21st November 2022)"
	revision: "3"

class
	TP_ZSTRING_LITERAL_CHAR

inherit
	TP_LITERAL_CHAR
		redefine
			make, i_th_matches
		end

	TP_OPTIMIZED_FOR_ZSTRING

create
	make, make_with_action

feature {NONE} -- Initialization

	make (uc: CHARACTER_32)
			--
		do
			Precursor (uc)
			z_code := Codec.as_z_code (uc)
		end

feature {NONE} -- Implementation

	i_th_matches (i: INTEGER; text: ZSTRING): BOOLEAN
		do
			Result := text.z_code (i) = z_code
		end

feature -- Access

	z_code: NATURAL_32

end

