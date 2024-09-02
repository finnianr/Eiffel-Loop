note
	description: "Codec information extracted from C source file"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-09-01 11:23:20 GMT (Sunday 1st September 2024)"
	revision: "23"

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

	EL_SHARED_UNICODE_PROPERTY

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
			create latin_table.make_empty (0x100)
			create latin_characters.make (128)
			from i := 0 until i > 0xFF loop
				latin_table.extend (i.to_natural_32)
				i := i + 1
			end
			create lower_case_offsets.make ("Lower")
			create upper_case_offsets.make ("Upper")

			create single_case_character_set.make (2)

			create unicode_intervals.make_empty

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
			Result := if codec_name.has_substring ("iso") then "ISO_8859" else "WINDOWS" end
		end

	codec_id: INTEGER
		do
			Result := codec_name.substring_end (codec_name.last_index_of ('_', codec_name.count) + 1).to_integer
		end

	codec_name: ZSTRING

	numeric_set: CODE_INTERVAL_LIST
		do
			create Result.make_latin_subset (latin_table, agent {LATIN_CHARACTER}.is_digit)
		end

	unicode_intervals: EL_SORTABLE_ARRAYED_LIST [UNICODE_INTERVAL]

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
			case_offsets: like lower_case_offsets
			i: INTEGER; unicode, unicode_changed: CHARACTER_32
		do
			create table.make_from_special (latin_table)

			from i := 0 until i = 256 loop
				latin_character := latin_table [i]
				if latin_character.is_alpha then
					unicode := latin_character.unicode.to_character_32
					unicode_changed := '%U'
					if unicode.is_upper then
						unicode_changed := unicode.as_lower; case_offsets := upper_case_offsets
					elseif unicode.is_lower then
						unicode_changed := unicode.as_upper; case_offsets := lower_case_offsets
					end
					if unicode_changed = '%U' then
						lio.put_string_field ("Alpha is neither upper or lower", latin_character.unicode_string)
						lio.put_new_line
					else
						table.find_first_equal (unicode_changed.natural_32_code, agent {LATIN_CHARACTER}.unicode)
						if table.after then
							single_case_character_set.extend (latin_character)
							lio.put_string_field (case_offsets.name + " case character", latin_character.unicode_string)
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
		do
			unicode_intervals := new_unicode_intervals
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
			latin_characters.extend (last_latin_code.to_natural_32)
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

	differing_unicodes: EL_ARRAYED_LIST [LATIN_CHARACTER]
		local
			i: INTEGER
		do
			create Result.make (128)
			from i := 0 until i > 0xFF loop
				if attached latin_table [i] as lc and then lc.code /= lc.unicode then
					Result.extend (lc)
				end
				i := i + 1
			end
		end

	is_case_changeable (latin: LATIN_CHARACTER): BOOLEAN
		do
			Result := across lower_case_offsets as set some set.item.has_character (latin) end
							or else across upper_case_offsets as set some set.item.has_character (latin) end
		end

	latin_1_disjoint_set: STRING
		local
			intervals: EL_SEQUENTIAL_INTERVALS; item: STRING
		do
			if codec_id = 1 then
				create Result.make_empty
			else
				create Result.make (100)
				create intervals.make (50)
				if attached differing_unicodes as code_list then
					across code_list as list loop
						intervals.extend_upper (list.item.code.to_integer_32)
					end
					from intervals.start until intervals.after loop
						item := quoted_manifest (intervals.item_lower)
						if intervals.item_count > 2 then
							item := item + ".." + quoted_manifest (intervals.item_upper)
						end
						if Result.count > 0 then
							Result.append (", ")
						end
						Result.append (item)
						intervals.forth
					end
				end
			end
		end

	new_unicode_intervals: like unicode_intervals
		local
			ascending_unicodes: EL_ARRAYED_LIST [LATIN_CHARACTER]
			i, unicode: INTEGER; is_unused: EL_PREDICATE_QUERY_CONDITION [LATIN_CHARACTER]
		do
			is_unused := agent {LATIN_CHARACTER}.is_unused
			ascending_unicodes := differing_unicodes.query (not is_unused)
			ascending_unicodes.sort (True)
			unicode := ascending_unicodes.first.unicode.to_integer_32
			create Result.make (ascending_unicodes.count)
			Result.extend (unicode |..| unicode)
			Result.last.extend_latin (ascending_unicodes.first)
			from i := 2 until i > ascending_unicodes.count loop
				unicode := ascending_unicodes [i].unicode.to_integer_32
				if Result.last.upper + 1 = unicode then
					Result.last.extend (unicode)
				else
					Result.extend (unicode |..| unicode)
				end
				Result.last.extend_latin (ascending_unicodes [i])
				i := i + 1
			end
			Result.ascending_sort
		end

	quoted_manifest (code: INTEGER): STRING
		local
			c: CHARACTER
		do
			c := code.to_character_8
			inspect code
			-- c.is_printable not working
				when 0x21 .. 0x7E,  0xA2 .. 0xAC,  0xAE .. 0xFF then
					create Result.make_filled ('%'', 3)
					Result [2] := c
					inspect c
						when '%'', '%%' then
							Result.insert_character ('%%', 2)
					else
					end
			else
			-- Decimal representation
				create Result.make (6)
				Result.append ("'%%/0")
				Result.append_integer (code)
				Result.append ("/'")
			end
		end

feature {NONE} -- Internal attributes

	last_latin_code: INTEGER

	latin_characters: ARRAYED_LIST [LATIN_CHARACTER]

	latin_table: SPECIAL [LATIN_CHARACTER]

	lower_case_offsets: CASE_OFFSETS_TABLE

	single_case_character_set: ARRAYED_LIST [LATIN_CHARACTER]

	upper_case_offsets: CASE_OFFSETS_TABLE

feature {NONE} -- Evolicity fields

	get_unchangeable_case_set_string: STRING
		-- alpha characters which are only available in a single case
		do
			create Result.make_empty
			across latin_table as lc loop
				if lc.item.is_alpha and then not is_case_changeable (lc.item) then
					if not Result.is_empty then
						Result.append (", ")
					end
					Result.append_natural_32 (lc.item.code)
				end
			end
		end

	getter_function_table: like getter_functions
			--
		do
			create Result.make (<<
				["codec_id",							agent: INTEGER_REF do Result := codec_id.to_reference end],
				["has_thai_numerals",				agent: BOOLEAN_REF do Result := (codec_id = 11).to_reference end],
				["latin_characters",					agent: ITERABLE [LATIN_CHARACTER] do Result := latin_characters end],
				["lower_case_offsets",				agent: ITERABLE [STRING] do Result := lower_case_offsets.to_string_table end],
				["single_case_character_set",		agent: ITERABLE [LATIN_CHARACTER] do Result := single_case_character_set end],
				["upper_case_offsets",				agent: ITERABLE [STRING] do Result := upper_case_offsets.to_string_table end],
				["unicode_intervals",				agent: ITERABLE [UNICODE_INTERVAL] do Result := unicode_intervals end],

--				String values
				["alpha_set_string",					agent: STRING do Result := alpha_set.to_string end],
				["codec_name",							agent: ZSTRING do Result := codec_name.as_upper end],
				["codec_base_name",					agent: ZSTRING do Result := codec_base_name end],
				["latin_1_disjoint_set",			agent latin_1_disjoint_set],
				["lower_case_set_string",			agent: STRING do Result := lower_case_offsets.case_set_string end],
				["numeric_set_string",				agent: STRING do Result := numeric_set.to_string end],
				["upper_case_set_string",			agent: STRING do Result := upper_case_offsets.case_set_string end],
				["unchangeable_case_set_string",	agent get_unchangeable_case_set_string]
			>>)
		end

end