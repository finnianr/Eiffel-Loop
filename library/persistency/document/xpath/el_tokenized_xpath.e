note
	description: "Tokenized form of xpath"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "9"

class
	EL_TOKENIZED_XPATH

inherit
	ARRAYED_STACK [INTEGER_16]
		rename
			make as stack_make
		export
			{NONE} all
			{ANY} remove, out, first, last, occurrences, count, wipe_out, i_th, prunable, writable
			{EL_TOKENIZED_XPATH} area
		redefine
			put,
			remove,
			out
		end

	EL_XPATH_CONSTANTS
		undefine
			is_equal, copy, out
		end

	HASHABLE
		undefine
			is_equal, copy, out
		end

create
	make

feature {NONE} -- Initialization

	make (a_token_table: like token_table)
			--
		do
			token_table := a_token_table
			stack_make (13)
		end

feature -- Element change

	remove
			--
		do
			Precursor
			internal_hash_code := 0
			is_path_to_element := true
		end

	append_step (step_name: ZSTRING)
			--
		do
			if step_name.count > 0 then
				put (token (step_name))
				if step_name [1] = '@' then
					is_path_to_element := false
				else
					inspect last.to_integer
						when Comment_node_step_id, Text_node_step_id then
							is_path_to_element := false
					else
						is_path_to_element := true
					end
				end
			end
		end

	append_xpath (xpath: STRING)
			-- Convert an xpath to compressed form
			-- eg. "/publisher/author/book" -> {1,2,3}
			-- 1 = publisher, 2 = author, 3 = book
		local
			steps: LIST [STRING]
		do
			steps := xpath.split ('/')
			if steps.count >= 2 and then steps.i_th (1).is_empty and then steps.i_th (2).is_empty then
				steps [2] := Node_descendant_or_self
			end
			from steps.start until steps.after loop
				if not steps.item.is_empty then
					append_step (steps.item)
				end
				steps.forth
			end
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
		require
			valid_wildcard: wildcard_xpath.has_wild_cards
		local
			i, j, from_pos, wildcard_from_pos, l_count: INTEGER
			l_area, wildcard_area: like area; wildcard_token: INTEGER_16
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
					l_count := count; l_area := area; wildcard_area := wildcard_xpath.area
					from
						i := from_pos - 1; j := wildcard_from_pos - 1
					until
						i = l_count or Result = false
					loop
						wildcard_token := wildcard_area [j]
						if wildcard_token /= Child_element_step_id and then l_area [i] /= wildcard_token then
							Result := false
						end
						i := i + 1; j := j + 1
					end
				end
			end
		end

feature {NONE} -- Implementation

	token_table: EL_XPATH_TOKEN_TABLE

	internal_hash_code: INTEGER

	token (xpath_step: ZSTRING): INTEGER_16
			-- token value of xpath step
		do
			token_table.put ((token_table.count + 1).to_integer_16, xpath_step)
			Result := token_table.found_item
		ensure
			not_using_reserved_id: token_table.inserted implies Result > Num_step_id_constants
		end

	put (v: like item)
		do
			Precursor (v)
			internal_hash_code := 0
		end

end