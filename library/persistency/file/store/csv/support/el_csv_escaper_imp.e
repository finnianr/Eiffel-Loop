note
	description: "Abstract implementation for [$source EL_CSV_ESCAPER]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-01-05 9:51:45 GMT (Thursday 5th January 2023)"
	revision: "1"

deferred class
	EL_CSV_ESCAPER_IMP [S -> STRING_GENERAL create make end]

inherit
	EL_STRING_ESCAPER_IMP [S]
		redefine
			append_escape_sequence
		end

feature -- Basic operations

	append_escape_sequence (str: S; escape_code, code: NATURAL; table: HASH_TABLE [NATURAL, NATURAL])
		-- Escape " as ""
		do
			if code = Double_quote then
				str.append_code (Double_quote); str.append_code (Double_quote)
			else
				Precursor (str, escape_code, code, table)
			end
		end

feature {NONE} -- Constants

	Double_quote: NATURAL = 34
end