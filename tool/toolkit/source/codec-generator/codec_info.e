note
	description: "Summary description for {CODEC_INFO}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-07-26 10:50:57 GMT (Friday 26th July 2013)"
	revision: "5"

class
	CODEC_INFO

inherit
	EL_FILE_PARSER
		rename
			new_pattern as assignment_pattern,
			make as make_parser
		end

	EVOLICITY_EIFFEL_CONTEXT

	EL_MODULE_LOG
	EL_MODULE_STRING

	EL_TEXTUAL_PATTERN_FACTORY

create
	make

feature {NONE} -- Initialization

	make (a_codec_name: EL_ASTRING)
			--
		local
			i: INTEGER
		do
			make_parser
			codec_name := a_codec_name
			create default_unicode_info.make (0)
			create latin_table.make_filled (default_unicode_info, 0, 255)
			create latin_characters.make (128)
			from i := 0 until i > 255 loop
				latin_table [i] := create {LATIN_CHARACTER}.make_with_unicode (i.to_natural_32, i.to_natural_32)
				i := i + 1
			end
			create lower_case_offsets.make (7)
			create upper_case_offsets.make (7)
			create case_change_substitutes

			create unicode_intervals.make (7)

			make_eiffel_context
		end

feature -- Access

	alpha_set: ARRAYED_LIST [INTEGER_INTERVAL]
		do
			Result := character_set (agent {LATIN_CHARACTER}.is_alpha)
		end

	numeric_set: ARRAYED_LIST [INTEGER_INTERVAL]
		do
			Result := character_set (agent {LATIN_CHARACTER}.is_digit)
		end

	codec_base_name: EL_ASTRING
		do
			if codec_name.has_substring ("iso") then
				Result := "ISO_8859"
			else
				Result := "WINDOWS"
			end
		end

	codec_id: INTEGER
		do
			Result := codec_name.substring (codec_name.last_index_of ('_', codec_name.count) + 1, codec_name.count).to_integer
		end

	codec_name: EL_ASTRING

	lower_case_offsets: HASH_TABLE [ARRAYED_LIST [INTEGER_INTERVAL], NATURAL]

	upper_case_offsets: HASH_TABLE [ARRAYED_LIST [INTEGER_INTERVAL], NATURAL]

	unicode_intervals: ARRAYED_LIST [UNICODE_INTERVAL]

feature -- Element change

	add_assignment (text: EL_ASTRING)
			--
		do
			set_source_text (text)
			match_full
			if full_match_succeeded then
				consume_events
			end
--			log.put_string ("Result [")
--			log.put_string (latin_characters.last.code.to_hex_string.substring (7, 8))
--			log.put_string ("] := ")
--			log.put_string (latin_characters.last.code.to_hex_string.substring (5, 8))
--			log.put_new_line
		end

feature -- Status query

	changeable_case_set_has_character (code: INTEGER; case_set: like lower_case_offsets): BOOLEAN
		do
			Result :=	across case_set as interval_list some
								across interval_list.item as interval some interval.item.has (code) end
							end
		end

feature -- Basic operations

	set_case_change_offsets
		local
			i: INTEGER
			unicode, unicode_changed: CHARACTER_32
			table: EL_ARRAYED_LIST [LATIN_CHARACTER]
			case_offsets: like lower_case_offsets
			case_type: STRING
			latin_character: LATIN_CHARACTER
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
						log_or_io.put_string_field ("Alpha is neither upper or lower", character_string (unicode).to_utf8)
						log_or_io.put_new_line
					else
						table.find_first (unicode_changed.natural_32_code, agent {LATIN_CHARACTER}.unicode)
						if table.after then
							case_change_substitutes [character_string (unicode)] := character_string (unicode_changed)
							log_or_io.put_string_field (case_type + " case character", character_string (unicode).to_utf8)
							log_or_io.put_string_field (" has no latin case change", character_string (unicode_changed).to_utf8)
							log_or_io.put_new_line
						else
							extend_offset_interval (case_offsets, i.to_character_8, (table.index - 1).to_character_8)
						end
					end
				end
				i := i + 1
			end
		end

	set_unicode_intervals
		local
			i, unicode: INTEGER
			lc: LATIN_CHARACTER
			ascending_unicodes: SORTABLE_ARRAY [LATIN_CHARACTER]
			differing_unicodes: ARRAYED_LIST [LATIN_CHARACTER]
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

	assignment_pattern: EL_MATCH_ALL_IN_LIST_TP
			--
		do
			Result := all_of (<<
				string_literal ("%T%T"), c_identifier, string_literal ("[0x"),
				alpha_numeric #occurs (2 |..| 2) |to| agent on_latin_code,
				string_literal ("] = (char) (0x"),
				alpha_numeric #occurs (4 |..| 4) |to| agent on_unicode,
				string_literal (");"),
				optional (
					all_of (<<
						maybe_non_breaking_white_space,
						character_literal ('/'),
						one_character_from ("/*"),
						one_or_more (any_character) |to| agent on_comment
					>>)
				)
			>>)
		end

feature {NONE} -- Match actions

	on_latin_code (hexadecimal: EL_STRING_VIEW)
			--
		do
			last_latin_code := String.hexadecimal_to_integer (hexadecimal.view)
			latin_characters.extend (create {LATIN_CHARACTER}.make (last_latin_code.to_natural_32))
			latin_table [last_latin_code] := latin_characters.last
		end

	on_unicode (hexadecimal: EL_STRING_VIEW)
			--
		do
			latin_table.item (last_latin_code).set_unicode (String.hexadecimal_to_integer (hexadecimal).to_natural_32)
		end

	on_comment (a_comment: EL_STRING_VIEW)
			--
		local
			l_name: EL_ASTRING
		do
			l_name := a_comment
			l_name.left_adjust
			l_name.prune_all_trailing ('/')
			l_name.prune_all_trailing ('*')
			latin_table.item (last_latin_code).set_name(l_name)
		end

feature {NONE} -- Implementation

	character_string (unicode: CHARACTER_32): EL_ASTRING
		do
			create Result.make (1)
			Result.append_unicode (unicode.natural_32_code)
		end

	character_set (filter: PREDICATE [LATIN_CHARACTER, TUPLE]): ARRAYED_LIST [INTEGER_INTERVAL]
		local
			i: INTEGER
			interval: INTEGER_INTERVAL
		do
			create Result.make (10)
			from i := 0 until i = 256 loop
				if filter.item ([latin_table [i]]) then
					if Result.is_empty or else interval.upper + 1 /= i then
						interval := i |..| i
						Result.extend (interval)
					else
						interval.extend (i)
					end
				end
				i := i + 1
			end
		end

	extend_offset_interval (case_offsets: like lower_case_offsets; c1, c2: CHARACTER)
		local
			offset: NATURAL
			interval_list: ARRAYED_LIST [INTEGER_INTERVAL]
			code: INTEGER
		do
			if c1 < c2 then
				offset := c2.natural_32_code - c1.natural_32_code
			elseif c1 > c2 then
				offset := c1.natural_32_code - c2.natural_32_code
			end
			if offset > 0 then
				case_offsets.search (offset)
				if case_offsets.found then
					interval_list := case_offsets.found_item
				else
					create interval_list.make (5)
					case_offsets.extend (interval_list, offset)
				end
				code := c1.natural_32_code.to_integer_32
				if interval_list.is_empty then
					interval_list.extend (code |..| code)
				elseif interval_list.last.upper + 1 = code then
					interval_list.last.extend (code)
				else
					interval_list.extend (code |..| code)
				end
			end
		end

	code_intervals_string (intervals_list: ARRAYED_LIST [INTEGER_INTERVAL]): STRING
		do
			create Result.make (10)
			across intervals_list as interval loop
				if interval.cursor_index > 1 then
					Result.append (", ")
				end
				Result.append_integer (interval.item.lower)
				if interval.item.count > 1 then
					Result.append ("..")
					Result.append_integer (interval.item.upper)
				end
			end
		end

	case_change_offsets_string_table (case_offsets: like lower_case_offsets): HASH_TABLE [STRING, INTEGER_REF]
			-- Eg. {32: "97..122, 224..246, 248..254"}
		do
			create Result.make (case_offsets.count)
			across case_offsets as code_intervals loop
				Result [code_intervals.key.to_integer_32.to_reference] := code_intervals_string (code_intervals.item)
			end
		end

	sorted_unicode_intervals (a_unicode_intervals: like unicode_intervals): like unicode_intervals
		local
			sortable: SORTABLE_ARRAY [UNICODE_INTERVAL]
		do
			create sortable.make_from_array (a_unicode_intervals.to_array)
			sortable.sort
			create Result.make_from_array (sortable)
		end

	latin_table: ARRAY [LATIN_CHARACTER]

	latin_characters: ARRAYED_LIST [LATIN_CHARACTER]

	default_unicode_info: LATIN_CHARACTER

	last_latin_code: INTEGER

	case_change_substitutes: EL_ASTRING_HASH_TABLE [EL_ASTRING]

feature {NONE} -- Evolicity fields

	get_case_set_string (case_offsets: like lower_case_offsets): STRING
		do
			create Result.make (80)
			across case_change_offsets_string_table (case_offsets) as case_set loop
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
				if l_character.item.is_alpha
					and then not changeable_case_set_has_character (l_character.item.code.to_integer_32, lower_case_offsets)
					and then not changeable_case_set_has_character (l_character.item.code.to_integer_32, upper_case_offsets)
				then
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
				["codec_name", 		agent: EL_ASTRING do Result := codec_name.as_upper end],
				["codec_base_name", 	agent: EL_ASTRING do Result := codec_base_name end],
				["latin_characters", agent: ITERABLE [LATIN_CHARACTER] do Result := latin_characters end],
				["lower_case_offsets", agent: ITERABLE [STRING]
					do Result := case_change_offsets_string_table (lower_case_offsets) end
				],
				["upper_case_offsets", agent: ITERABLE [STRING]
					do Result := case_change_offsets_string_table (upper_case_offsets) end
				],
				["lower_case_set_string", agent: STRING do Result := get_case_set_string (upper_case_offsets) end],
				["upper_case_set_string", agent: STRING do Result := get_case_set_string (lower_case_offsets) end],
				["unchangeable_case_set_string", agent get_unchangeable_case_set_string],
				["alpha_set_string", agent: STRING do Result := code_intervals_string (alpha_set) end],
				["numeric_set_string", agent: STRING do Result := code_intervals_string (numeric_set) end],
				["codec_id", agent: INTEGER_REF do Result := codec_id.to_reference end],
				["case_change_substitutes", agent: ITERABLE [STRING] do Result := case_change_substitutes end],
				["unicode_intervals", agent: ITERABLE [UNICODE_INTERVAL] do Result := unicode_intervals end]
			>>)
		end

end
