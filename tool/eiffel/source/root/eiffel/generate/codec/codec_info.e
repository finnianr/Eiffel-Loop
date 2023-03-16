note
	description: "Codec information extracted from C source file"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-03-16 11:25:01 GMT (Thursday 16th March 2023)"
	revision: "18"

class
	CODEC_INFO

inherit
	EL_FILE_PARSER
		rename
			new_pattern as assignment_pattern
		export
			{NONE} all
		redefine
			make_default
		end

	EVOLICITY_EIFFEL_CONTEXT
		redefine
			make_default
		end

	TP_C_LANGUAGE_FACTORY

	EL_MODULE_LIO

create
	make

feature {NONE} -- Initialization

	make (a_codec_name: ZSTRING)
			--
		do
			make_default
			codec_name := a_codec_name
		end

	make_default
		local
			i: INTEGER
		do
			create default_unicode_info.make (0)
			create latin_table.make_filled (default_unicode_info, 0, 255)
			create latin_characters.make (128)
			from i := 0 until i > 255 loop
				latin_table [i] := create {LATIN_CHARACTER}.make_with_unicode (i.to_natural_32, i.to_natural_32)
				i := i + 1
			end
			create lower_case_offsets.make (7)
			create upper_case_offsets.make (7)
			create single_case_character_set.make (2)

			create unicode_intervals.make (7)

			Precursor {EL_FILE_PARSER}
			Precursor {EVOLICITY_EIFFEL_CONTEXT}
		end

feature -- Access

	alpha_set: CODE_INTERVAL_LIST
		do
			create Result.make_latin_subset (latin_table, agent {LATIN_CHARACTER}.is_alpha)
		end

	codec_base_name: ZSTRING
		do
			if codec_name.has_substring ("iso") then
				Result := "ISO_8859"
			else
				Result := "WINDOWS"
			end
		end

	codec_id: INTEGER
		do
			Result := codec_name.substring_end (codec_name.last_index_of ('_', codec_name.count) + 1).to_integer
		end

	codec_name: ZSTRING

	lower_case_offsets: CASE_OFFSETS_TABLE

	numeric_set: CODE_INTERVAL_LIST
		do
			create Result.make_latin_subset (latin_table, agent {LATIN_CHARACTER}.is_digit)
		end

	unicode_intervals: ARRAYED_LIST [UNICODE_INTERVAL]

	upper_case_offsets: CASE_OFFSETS_TABLE

feature -- Element change

	add_assignment (text: ZSTRING)
			--
		do
			set_source_text (text)
			parse
		end

feature -- Basic operations

	set_case_change_offsets
		local
			table: EL_ARRAYED_LIST [LATIN_CHARACTER]; latin_character: LATIN_CHARACTER
			case_offsets: like lower_case_offsets; case_type: STRING
			i: INTEGER; unicode, unicode_changed: CHARACTER_32
		do
			create table.make_from_array (latin_table)
			from i := 0 until i = 256 loop
				latin_character := latin_table.item (i)
				unicode := latin_character.unicode.to_character_32
				unicode_changed := '%U'
				if latin_character.is_alpha then
					if unicode.is_upper then
						case_type := "Upper"
						unicode_changed := unicode.as_lower; case_offsets := upper_case_offsets
					elseif unicode.is_lower then
						case_type := "Lower"
						unicode_changed := unicode.as_upper; case_offsets := lower_case_offsets
					end
					if unicode_changed = '%U' then
						lio.put_string_field ("Alpha is neither upper or lower", latin_character.unicode_string)
						lio.put_new_line
					else
						table.find_first_equal (unicode_changed.natural_32_code, agent {LATIN_CHARACTER}.unicode)
						if table.after then
							single_case_character_set.extend (latin_character)
							lio.put_string_field (case_type + " case character", latin_character.unicode_string)
							lio.put_string_field (" has no latin case change", latin_character.inverse_case_unicode_string)
							lio.put_new_line
						else
							case_offsets.extend (i.to_character_8, (table.index - 1).to_character_8)
						end
					end
				end
				i := i + 1
			end
		end

	set_unicode_intervals
		local
			ascending_unicodes: SORTABLE_ARRAY [LATIN_CHARACTER]
			differing_unicodes: ARRAYED_LIST [LATIN_CHARACTER]
			i, unicode: INTEGER; lc: LATIN_CHARACTER
		do
			create differing_unicodes.make (128)
			from i := 0 until i = 256 loop
				lc := latin_table.item (i)
				if lc.code /= lc.unicode then
					differing_unicodes.extend (lc)
				end
				i := i + 1
			end

			create ascending_unicodes.make_from_array (differing_unicodes.to_array)
			ascending_unicodes.sort
			unicode := ascending_unicodes.item (1).unicode.to_integer_32
			unicode_intervals.extend (unicode |..| unicode)
			unicode_intervals.last.extend_latin (ascending_unicodes.item (1))
			from i := 2 until i > ascending_unicodes.count loop
				unicode := ascending_unicodes.item (i).unicode.to_integer_32
				if unicode_intervals.last.upper + 1 = unicode then
					unicode_intervals.last.extend (unicode)
				else
					unicode_intervals.extend (unicode |..| unicode)
				end
				unicode_intervals.last.extend_latin (ascending_unicodes.item (i))
				i := i + 1
			end
			unicode_intervals := sorted_unicode_intervals (unicode_intervals)
		end

feature {NONE} -- Pattern definitions

	assignment_pattern: like all_of
			--
		do
			Result := all_of (<<
				string_literal ("%T%T"), identifier, character_literal ('['),
				hexadecimal_constant |to| agent on_latin_code,
				string_literal ("] = (char) ("),
				hexadecimal_constant |to| agent on_unicode,
				string_literal (");"),
				optional (
					all_of (<<
						optional_nonbreaking_white_space,
						character_literal ('/'),
						one_character_from ("/*"),
						one_or_more (any_character) |to| agent on_comment
					>>)
				)
			>>)
		end

feature {NONE} -- Match actions

	on_comment (start_index, end_index: INTEGER)
			--
		local
			l_name: ZSTRING
		do
			l_name := source_substring (start_index, end_index, True)
			l_name.left_adjust
			l_name.prune_all_trailing ('/')
			l_name.prune_all_trailing ('*')
			latin_table.item (last_latin_code).set_name (l_name)
		end

	on_latin_code (start_index, end_index: INTEGER)
			--
		local
			hex: EL_HEXADECIMAL_CONVERTER
		do
			last_latin_code := hex.to_integer (source_substring (start_index, end_index, False))
			latin_characters.extend (create {LATIN_CHARACTER}.make (last_latin_code.to_natural_32))
			latin_table [last_latin_code] := latin_characters.last
		end

	on_unicode (start_index, end_index: INTEGER)
			--
		local
			hex: EL_HEXADECIMAL_CONVERTER; unicode: NATURAL
		do
			unicode := hex.to_natural_32 (source_substring (start_index, end_index, False))
			latin_table.item (last_latin_code).set_unicode (unicode)
		end

feature {NONE} -- Implementation

	is_case_changeable (latin: LATIN_CHARACTER): BOOLEAN
		do
			Result := across lower_case_offsets as set some set.item.has_character (latin) end
							or else across upper_case_offsets as set some set.item.has_character (latin) end
		end

	sorted_unicode_intervals (a_unicode_intervals: like unicode_intervals): like unicode_intervals
		local
			sortable: SORTABLE_ARRAY [UNICODE_INTERVAL]
		do
			create sortable.make_from_array (a_unicode_intervals.to_array)
			sortable.sort
			create Result.make_from_array (sortable)
		end

feature {NONE} -- Internal attributes

	default_unicode_info: LATIN_CHARACTER

	last_latin_code: INTEGER

	latin_characters: ARRAYED_LIST [LATIN_CHARACTER]

	latin_table: ARRAY [LATIN_CHARACTER]

	single_case_character_set: ARRAYED_LIST [LATIN_CHARACTER]

feature {NONE} -- Evolicity fields

	get_case_set_string (case_offsets: like lower_case_offsets): STRING
		do
			create Result.make (80)
			across case_offsets.to_string_table as case_set loop
				if case_set.cursor_index > 1 then
					Result.append (", ")
				end
				Result.append (case_set.item)
			end
		end

	get_unchangeable_case_set_string: STRING
			-- alpha characters which are only available in a single case
		do
			create Result.make_empty
			across latin_table as l_character loop
				if l_character.item.is_alpha and then not is_case_changeable (l_character.item) then
					if not Result.is_empty then
						Result.append (", ")
					end
					Result.append_natural_32 (l_character.item.code)
				end
			end
		end

	getter_function_table: like getter_functions
			--
		do
			create Result.make (<<
				["has_thai_numerals",				agent: BOOLEAN_REF do Result := (codec_id = 11).to_reference end],
				["codec_name", 						agent: ZSTRING do Result := codec_name.as_upper end],
				["codec_base_name", 					agent: ZSTRING do Result := codec_base_name end],
				["latin_characters", 				agent: ITERABLE [LATIN_CHARACTER] do Result := latin_characters end],
				["lower_case_offsets", 				agent: ITERABLE [STRING] do Result := lower_case_offsets.to_string_table end],
				["upper_case_offsets", 				agent: ITERABLE [STRING] do Result := upper_case_offsets.to_string_table end],
				["lower_case_set_string", 			agent: STRING do Result := get_case_set_string (lower_case_offsets) end],
				["upper_case_set_string", 			agent: STRING do Result := get_case_set_string (upper_case_offsets) end],
				["unchangeable_case_set_string", agent get_unchangeable_case_set_string],
				["alpha_set_string", 				agent: STRING do Result := alpha_set.to_string end],
				["numeric_set_string",				agent: STRING do Result := numeric_set.to_string end],
				["codec_id",							agent: INTEGER_REF do Result := codec_id.to_reference end],
				["single_case_character_set", 	agent: ITERABLE [LATIN_CHARACTER] do Result := single_case_character_set end],
				["unicode_intervals", 				agent: ITERABLE [UNICODE_INTERVAL] do Result := unicode_intervals end]
			>>)
		end

end