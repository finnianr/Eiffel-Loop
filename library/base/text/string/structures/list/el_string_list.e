note
	description: "List of strings conforming to ${STRING_GENERAL}"
	descendants: "See end of class"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-15 11:25:36 GMT (Tuesday 15th April 2025)"
	revision: "43"

class
	EL_STRING_LIST [S -> STRING_GENERAL create make end]

inherit
	EL_STRING_CHAIN [S]
		rename
			subchain as array_subchain,
			accommodate as grow
		export
			{NONE} array_subchain
		undefine
			item_area, make_from, joined_chain, new_cursor, pop_cursor, push_cursor, to_array,
		-- measurement
			count,
		-- item query
			first, last, i_th, at,
		-- cursor movement
			finish, move, go_i_th, find_next_item, search, start,
		-- query
			is_equal, is_inserted, has, there_exists, isfirst, islast, off, readable, valid_index,
		-- basic operations
			do_all, for_all, do_if,
		-- element change
			append_sequence, copy, force, put_i_th, prune, prune_all, remove,
		-- reorder
			order_by, swap
		redefine
			checksum, hash_code, is_equal
		end

	EL_ARRAYED_LIST [S]
		rename
			joined as joined_chain,
			subchain as array_subchain
		export
			{ANY} insert
			{NONE} array_subchain
		undefine
			sort
		redefine
			is_equal, initialize, make_from_tuple
		end

create
	make, make_empty, make_filled, make_split, make_with_lines,
	make_word_split, make_from_array, make_from, make_from_tuple, make_from_general

convert
	make_from_array ({ARRAY [S]})

feature {NONE} -- Initialization

	initialize
		do
			Precursor; compare_objects
		end

	make_from_general (list: ITERABLE [READABLE_STRING_GENERAL])
		do
			make (Iterable.count (list))
			append_general (list)
		end

	make_from_tuple (tuple: TUPLE)
		do
			make (tuple.count)
			append_tuple (tuple)
		end

feature -- Measurement

	checksum: NATURAL
		local
			i: INTEGER
		do
			if attached area_v2 as l_area and then attached crc_generator as crc then
				from until i = l_area.count loop
					add_to_checksum (crc, l_area [i])
					i := i + 1
				end
				Result := crc.checksum
			end
		end

	hash_code: INTEGER
		-- Hash code value
		local
			i: INTEGER; b: EL_BIT_ROUTINES
		do
			if attached area_v2 as l_area then
				from until i = l_area.count loop
					Result := b.extended_hash (Result, l_area [i].hash_code)
					i := i + 1
				end
				Result := Result.abs
			end
		end

feature -- Duplication

	subchain (index_from, index_to: INTEGER ): EL_STRING_LIST [S]
		do
			if attached {EL_ARRAYED_LIST [S]} array_subchain (index_from, index_to) as l_list then
				create Result.make_from_array (l_list.to_array)
			end
		end

feature -- Comparison

	is_equal (other: like Current): BOOLEAN
			-- Is array made of the same items as `other'?
		local
			i: INTEGER
		do
			if other = Current then
				Result := True
			elseif count = other.count and then object_comparison = other.object_comparison then
				if attached area_v2 as l_area and then attached other.area_v2 as o_area then
					Result := True
					from until i = l_area.count or not Result loop
						Result := l_area [i] ~ o_area [i]
						i := i + 1
					end
				end
			end
		end

feature -- Removal

	curtail (maximum_count, leading_percent: INTEGER)
		-- curtail list to `maximum_count' characters keeping `leading_percent' of `maximum_count'
		-- at the head and leaving `100 - leading_percent' at the tail
		-- and inserting two ellipsis (..) at the head and tail boundary mark
		local
			line_list: like Current; dots: like item
		do
			if maximum_count < character_count then
				dots := new_string (Shared_super_8.filled ('.', 2))
				line_list := twin
				keep_character_head ((maximum_count * leading_percent / 100).rounded)
				last.append (dots)

				line_list.keep_character_tail ((maximum_count * (100 - leading_percent) / 100).rounded)
				line_list.first.prepend (dots)
				append (line_list)
			end
		end

	keep_character_head (n: INTEGER)
		-- remove `character_count - n' characters from end of list
		local
			new_count: INTEGER; last_line: detachable like item
			head_count: INTEGER
		do
			new_count := n.min (character_count)

			from until count = 0 or else character_count < new_count loop
				last_line := last
				remove_last
			end
			if attached last_line as line then
				head_count := new_count - character_count
				if head_count > 0 then
					extend (line.substring (1, head_count))
				end
			end
		ensure
			definition: old joined_strings.substring (1, n.min (character_count)) ~ joined_strings
		end

	keep_character_tail (n: INTEGER)
		-- remove `character_count - n' characters from end of list
		local
			new_count: INTEGER; first_line: detachable like item
			tail_count: INTEGER
		do
			new_count := n.min (character_count)

			from until count = 0 or else character_count < new_count loop
				first_line := first
				remove_head (1)
			end
			if attached first_line as line then
				tail_count := new_count - character_count
				if tail_count > 0 then
					put_front (line.substring (line.count - tail_count + 1, line.count))
				end
			end
		ensure
			definition: joined_strings ~ old joined_tail (n.min (character_count))
		end

feature -- Contract Support

	joined_tail (n: INTEGER): like item
		local
			l_count: INTEGER
		do
			l_count := character_count
			Result := joined_strings.substring (l_count - n + 1, l_count)
		end

note
	descendants: "[
			EL_STRING_LIST [S -> ${STRING_GENERAL} create make end]
				${EL_STRING_8_LIST}
					${EVC_VARIABLE_REFERENCE}
						${EVC_FUNCTION_REFERENCE}
					${AIA_CANONICAL_REQUEST}
				${EL_STRING_32_LIST}
				${EL_ZSTRING_LIST}
					${EL_XHTML_STRING_LIST}
					${XML_TAG_LIST}
						${XML_PARENT_TAG_LIST}
						${XML_VALUE_TAG_PAIR}
					${TB_HTML_LINES}
					${EL_ERROR_DESCRIPTION}
						${EL_COMMAND_ARGUMENT_ERROR}
				${EL_TEMPLATE_LIST* [S -> STRING_GENERAL create make end, KEY -> READABLE_STRING_GENERAL]}
					${EL_SUBSTITUTION_TEMPLATE [S -> STRING_GENERAL create make, make_empty end]}
						${EL_STRING_8_TEMPLATE}
						${EL_STRING_32_TEMPLATE}
						${EL_ZSTRING_TEMPLATE}
					${EL_TEMPLATE [S -> STRING_GENERAL create make, make_empty end]}
						${EL_DATE_TEXT_TEMPLATE}
	]"
end