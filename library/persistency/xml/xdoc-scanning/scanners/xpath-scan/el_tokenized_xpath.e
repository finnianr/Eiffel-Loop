note
	description: "Tokenized form of xpath"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:29 GMT (Sunday 16th December 2012)"
	revision: "1"

class
	EL_TOKENIZED_XPATH

inherit
	ARRAYED_STACK [INTEGER_16]
		rename
			make as stack_make
		export
			{NONE} all
			{ANY} remove, out, first, last, occurrences, count, wipe_out, i_th, prunable, writable
		redefine
			put,
			remove,
			out
		end

	HASHABLE
		undefine
			is_equal, copy, out
		end

	EL_MODULE_LOGGING
		undefine
			is_equal, copy, out
		end

create
	make

feature {NONE} -- Initialization

	make (a_step_id_table: HASH_TABLE [INTEGER_16, STRING_32])
			--
		do
			stack_make (13)

			token_table := a_step_id_table

			token_table.put (Child_element_step_id, Child_element)
			token_table.put (Descendant_or_self_node_step_id, Descendant_or_self_node)
			token_table.put (Comment_node_step_id.to_integer_16, Comment_node)
			token_table.put (Text_node_step_id.to_integer_16, Text_node)
		end

feature -- Element change

	remove
			--
		do
			Precursor
			internal_hash_code := 0
			is_path_to_element := true
		end

	append_step (step_name: STRING_32)
			--
		do
			put (token (step_name))
			if step_name.item (1).is_equal ('@') then
				is_path_to_element := false
			else
				inspect last.to_integer

				when Comment_node_step_id then
					is_path_to_element := false

				when Text_node_step_id  then
					is_path_to_element := false

				else
					is_path_to_element := true
				end
			end
		end

	append_xpath (xpath: STRING)
			-- Convert an xpath to compressed form
			-- eg. "/publisher/author/book" -> {1,2,3}
			-- 1 = publisher, 2 = author, 3 = book
		local
			xpath_step_list: LIST [STRING]
		do
--			log.enter ("append_xpath")
			if xpath.substring_index ("//", 1) = 1 then
				xpath.insert_string (Descendant_or_self_node, 2)
			end
			xpath_step_list := xpath.split ('/')
			from xpath_step_list.start until xpath_step_list.after loop
				if not xpath_step_list.item.is_empty then
					append_step (xpath_step_list.item)
				end
				xpath_step_list.forth
			end
--			log.exit
		end

feature -- Access

	is_path_to_element: BOOLEAN

	hash_code: INTEGER
			-- Hash code value
		local
			i, nb: INTEGER
			l_area: like area
		do
			Result := internal_hash_code
			if Result = 0 then
					-- The magic number `8388593' below is the greatest prime lower than
					-- 2^23 so that this magic number shifted to the left does not exceed 2^31.
				from
					i := 0
					nb := count
					l_area := area
				until
					i = nb
				loop
					Result := ((Result \\ 8388593) |<< 8) + l_area.item (i)
					i := i + 1
				end
				internal_hash_code := Result
			end
		end

	out: STRING
			--
		local
			pos: INTEGER
		do
			create Result.make (count * 3)
			from
				pos := 1
			until
				pos > count
			loop
				if pos > 1 then
					Result.append_character ('-')
				end
				Result.append_string (i_th (pos).out)
				pos := pos + 1
			end
			start
		end

feature -- Status report

	has_wild_cards: BOOLEAN
			--
		do
			Result := false
			from start until after or Result = true loop
				if item = Child_element_step_id or item = Descendant_or_self_node_step_id then
					 Result := true
				end
				forth
			end
			start
		end

	matches_wildcard (wildcard_xpath: like Current): BOOLEAN
			--
		require
			valid_wildcard: wildcard_xpath.has_wild_cards
		local
			pos, wildcard_pos, from_pos, wildcard_from_pos: INTEGER
		do
			Result := true
			if wildcard_xpath.last = Child_element_step_id and not is_path_to_element then
				Result := false
			else
				from_pos := 1
				wildcard_from_pos := 1
				if wildcard_xpath.first = Descendant_or_self_node_step_id then
					from_pos := count - (wildcard_xpath.count - 1) + 1
					wildcard_from_pos := 2
				end
				if from_pos < 1 then
					Result := false
				else
					from
						pos := from_pos
						wildcard_pos := wildcard_from_pos
					until
						pos > count or Result = false
					loop
						if wildcard_xpath.i_th (wildcard_pos) /= Child_element_step_id
							and then i_th (pos) /= wildcard_xpath.i_th (wildcard_pos)
						then
							Result := false
						end
						pos := pos + 1
						wildcard_pos := wildcard_pos + 1
					end
				end
			end
		end

feature {NONE} -- Implementation

	token_table: HASH_TABLE [INTEGER_16, STRING_32]

	internal_hash_code: INTEGER

	token (xpath_step: STRING_32): INTEGER_16
			-- token value of xpath step
		do
			token_table.search (xpath_step)
			if token_table.found then
				Result := token_table.found_item
			else
				Result := token_table.count.to_integer_16 + 1
				token_table.put (Result, xpath_step)
			end
		ensure
			not_using_reserved_id:
				not token_table.found implies Result > Num_step_id_constants
		end

	put (v: like item)
		do
			Precursor (v)
			internal_hash_code := 0
		end

feature -- Constants

	Comment_node: STRING_32
			--
		once
			Result := "comment()"
		end

	Child_element: STRING_32
			--
		once
			Result := "*"
		end

	Text_node: STRING_32
			--
		once
			Result := "text()"
		end

	Descendant_or_self_node: STRING_32
			--
		once
			Result := "descendant-or-self::node()"
		end

	Child_element_step_id: INTEGER_16 = Unique

--	// is short for /descendant-or-self::node()/

	Descendant_or_self_node_step_id: INTEGER_16 = Unique

	Comment_node_step_id: INTEGER = Unique

	Text_node_step_id: INTEGER = Unique

  	Num_step_id_constants: INTEGER = 4

end -- class EL_COMPRESSED_XPATH_STRING

