note
	description: "A class for creating line-orientated parsers of Eiffel source code"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-05-07 6:37:09 GMT (Wednesday 7th May 2025)"
	revision: "25"

class
	EL_EIFFEL_SOURCE_LINE_STATE_MACHINE

inherit
	EL_PLAIN_TEXT_LINE_STATE_MACHINE
		redefine
			call, make
		end

	TP_EIFFEL_FACTORY
		rename
			comment_prefix as pattern_comment_prefix
		end

	TP_SHARED_OPTIMIZED_FACTORY

feature {NONE} -- Initialization

	make
		do
			Precursor
			create code_line.make_empty
			core := optimal_core (code_line)
		end

feature {NONE} -- Implementation

	call (line: ZSTRING)
		do
			if attached code_line as cl then
				cl.wipe_out
				cl.append (line); cl.prune_all_leading ('%T')
				tab_count := line.count - cl.count
				if cl.count > 0 then
					cl.right_adjust
				end
			end
			Precursor (line)
		end

	code_line_class_name: ZSTRING
		do
			create Result.make_empty
			across code_line.split (' ') as word until not Result.is_empty loop
				if word.item.count > 0 and then not Class_declaration_keywords.has (word.item) then
					Result.append (word.item)
					if Result.has ('[') then
						Result.keep_head (Result.index_of ('[', 1))
						Result.right_adjust
					end
				end
			end
		end

	code_line_is_class_declaration: BOOLEAN
		local
			eif: EL_EIFFEL_SOURCE_ROUTINES
		do
			Result := eif.is_class_definition_start (code_line)
		end

	code_line_is_class_name: BOOLEAN
		do
			Result := code_line.matches (Class_name)
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

	code_line_is_type_identifier: BOOLEAN
		do
			Result := code_line.matches (class_type)
		end

	code_line_is_verbatim_string_end: BOOLEAN
		local
			index: INTEGER
		do
			if attached code_line as line and then line.count >= 2 then
				index := line.last_index_of ('"', line.count)
				if index > 1 and then Verbatim_markers.close.has (line.item_8 (index - 1)) then
					if index < line.count then
						Result := line.item_8 (index + 1) = ')'
					else
						Result := True
					end
				end
			end
		end

	code_line_is_verbatim_string_start: BOOLEAN
		local
			index: INTEGER
		do
		-- passes test for comment line: "%T%T-- index of %"${%""
		-- See CLASS_LINK `start_index'
			if attached code_line as line and then line.count >= 2 then
				index := line.last_index_of ('"', 1)
				if index > 0 and then line.valid_index (index + 1)
					and then Verbatim_markers.open.has (line.item_8 (index + 1))
				then
					Result := line.leading_white_count = index - 1
				end
			end
		end

	code_line_starts_with_one_of (indent_count: INTEGER; keywords: LIST [ZSTRING]): BOOLEAN
		do
			Result := keywords.there_exists (agent code_line_starts_with (indent_count, ?))
		end

	code_line_starts_with (indent_count: INTEGER; a_keyword: ZSTRING): BOOLEAN
		local
			cl: like code_line
		do
			if tab_count = indent_count then
				cl := code_line
				if cl.starts_with (a_keyword) then
					Result := cl.count > a_keyword.count implies cl [a_keyword.count + 1].is_space
				end
			end
		end

feature {NONE} -- Implementation attributes

	code_line: ZSTRING

	core: TP_OPTIMIZED_FACTORY

	tab_count: INTEGER

feature {NONE} -- Constants

	Verbatim_markers: TUPLE [open, close: STRING]
		once
			create Result
			Tuple.fill (Result, "{[,]}")
		end

end