note
	description: "Abstract implementation for [$source EL_CSV_ESCAPER]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-08-02 14:36:21 GMT (Wednesday 2nd August 2023)"
	revision: "3"

deferred class
	EL_CSV_ESCAPER_IMP [S -> STRING_GENERAL create make end]

inherit
	EL_STRING_ESCAPER_IMP [S]
		redefine
			append_escape_sequence
		end

feature -- Basic operations

	append_escape_sequence (escaper: EL_STRING_ESCAPER [S]; str: S; code: NATURAL)
		-- Escape " as ""
		do
			if code = Double_quote then
				str.append_code (Double_quote); str.append_code (Double_quote)
			else
				Precursor (escaper, str, code)
			end
		end

feature {NONE} -- Constants

	Double_quote: NATURAL = 34
end