note
	description: "A class for creating line-orientated parsers of Eiffel source code"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EL_EIFFEL_SOURCE_LINE_STATE_MACHINE

inherit
	EL_PLAIN_TEXT_LINE_STATE_MACHINE
		redefine
			call, make
		end

	EL_EIFFEL_KEYWORDS

feature {NONE} -- Initialization

	make
		do
			Precursor
			create code_line.make_empty
		end

feature {NONE} -- Implementation

	call (line: ZSTRING)
		local
			cl: ZSTRING
		do
			cl := code_line; cl.wipe_out
			cl.append (line); cl.prune_all_leading ('%T')
			tab_count := line.count - cl.count
			if cl.count > 0 then
				cl.right_adjust
			end
			Precursor (line)
		end

	code_line_is_class_declaration: BOOLEAN
		do
			Result := code_line_starts_with_one_of (0, Class_declaration_keywords)
		end

	code_line_is_feature_declaration: BOOLEAN
			-- True if code line begins declaration of attribute or routine
		local
			first_character: CHARACTER_32
		do
			if not code_line.is_empty then
				first_character := code_line [1]
				Result := tab_count = 1 and then (first_character.is_alpha or else first_character = '@')
			end
		end

	code_line_is_verbatim_string_end: BOOLEAN
		do
			Result := across Close_verbatim_string_markers as marker some code_line.ends_with (marker.item) end
		end

	code_line_is_verbatim_string_start: BOOLEAN
		do
			Result := across Open_verbatim_string_markers as marker some code_line.ends_with (marker.item) end
		end

	code_line_starts_with_one_of (indent_count: INTEGER; keywords: LIST [ZSTRING]): BOOLEAN
		do
			Result := keywords.there_exists (agent code_line_starts_with (indent_count, ?))
		end

	code_line_starts_with (indent_count: INTEGER; keyword: ZSTRING): BOOLEAN
		local
			cl: like code_line
		do
			if tab_count = indent_count then
				cl := code_line
				if cl.starts_with (keyword) then
					Result := cl.count > keyword.count implies cl.unicode_item (keyword.count + 1).is_space
				end
			end
		end

feature {NONE} -- Implementation attributes

	code_line: ZSTRING

	tab_count: INTEGER

feature {NONE} -- Constants

	Close_verbatim_string_markers: ARRAY [ZSTRING]
		once
			Result := << "]%"", "}%"" >>
		end

	Open_verbatim_string_markers: ARRAY [ZSTRING]
		once
			Result := << "%"[", "%"{" >>
		end

end
