note
	description: "Matches single literal character in a [$source ZSTRING]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 16:56:49 GMT (Tuesday 15th November 2022)"
	revision: "2"

class
	EL_ZSTRING_LITERAL_CHAR_TP

inherit
	EL_LITERAL_CHAR_TP
		redefine
			make, i_th_matches
		end

	EL_MATCH_OPTIMIZED_FOR_ZSTRING

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