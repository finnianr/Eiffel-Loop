note
	description: "Tokenized form of xpath"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-15 12:35:50 GMT (Monday 15th January 2024)"
	revision: "13"

class
	EL_TOKENIZED_XPATH

inherit
	ARRAYED_STACK [NATURAL_16]
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

	EL_XPATH_NODE_CONSTANTS

	HASHABLE
		undefine
			is_equal, copy, out
		end

	DEBUG_OUTPUT
		undefine
			is_equal, copy, out
		end

create
	make

feature {NONE} -- Initialization

	make
		do
			stack_make (13)
		end

feature -- Element change

	append_step (step_name: READABLE_STRING_8; a_type: INTEGER)
			--
		local
			code: NATURAL_16
		do
			type := a_type
			inspect type
				when Type_comment, Type_text then
					put (a_type.to_natural_16)

				when Type_processing_instruction then
					put (a_type.to_natural_16)
					put (token_table.code (step_name))
			else
				if step_name.count > 0 then
					code := token_table.code (step_name)
					if a_type = Type_attribute then
						put (Attribute_flag | code)
					else
						put (code)
					end
				end
			end
		end

	append_xpath (xpath: STRING)
			-- Convert an xpath to compressed form
			-- eg. "/publisher/author/book" -> {1,2,3}
			-- 1 = publisher, 2 = author, 3 = book
		local
			empty_count, item_count: INTEGER; step: IMMUTABLE_STRING_8
			steps, pi_parts: EL_SPLIT_IMMUTABLE_STRING_8_LIST
		do
			if xpath.has_substring (Node_name [Type_processing_instruction]) then
			end
			create steps.make_shared_adjusted (xpath, '/', 0)
			from steps.start until steps.after loop
				item_count := steps.item_count
				if item_count = 0 then
					empty_count := empty_count + 1
					if steps.index = 2 and then empty_count = 2 then
--						matched //
						append_step (Node_name [Type_descendant_or_self], Type_descendant_or_self)
					end

				elseif xpath [steps.item_lower] = '@' then
					step := steps.item
					append_step (step.shared_substring (2, item_count), Type_attribute)

				elseif steps.item.starts_with (Node_name [Type_processing_instruction]) then
					create pi_parts.make (steps.item, '%'')
					append_step (pi_parts.i_th (2), Type_processing_instruction)

				elseif token_table.has_key (xpath) and then token_table.found_item <= Type_text then
					append_step (steps.item, token_table.found_item)

				else
					append_step (steps.item, Type_element)
				end
				steps.forth
			end
		end

	remove
			--
		do
			Precursor
			internal_hash_code := 0
			type := Type_element
		end

feature -- Access

	hash_code: INTEGER
			-- Hash code value
		local
			i, nb: INTEGER; b: EL_BIT_ROUTINES
		do
			Result := internal_hash_code
			if Result = 0 and then attached area as l_area then
				from
					i := 0; nb := count
				until
					i = nb
				loop
					Result := b.extended_hash (Result, l_area [i].as_integer_32)
					i := i + 1
				end
				internal_hash_code := Result
			end
		end

	is_path_to_element: BOOLEAN
		do
			inspect type
				when Type_element, Type_descendant_or_self then
					Result := True
			else
			end
		end

	debug_output, out: STRING
			--
		local
			i: INTEGER; token: NATURAL_16
		do
			create Result.make (count * 3)
			if attached area as l_area then
				from until i = l_area.count loop
					if i > 0 then
						Result.append_character ('-')
					end
					token := l_area [i]
					if (Attribute_flag & token).to_boolean then
						Result.append_character ('@')
						token := token - Attribute_flag
					end
					Result.append_natural_16 (token)
					i := i + 1
				end
			end
		end

feature -- Status report

	has_wild_cards: BOOLEAN
			--
		local
			i: INTEGER
		do
			if attached area as l_area then
				from until i = l_area.count or Result loop
					inspect l_area [i].as_integer_32
						when Type_any, Type_descendant_or_self then
							 Result := True
					else
					end
					i := i + 1
				end
			end
		end

	matches_wildcard (wildcard_xpath: like Current): BOOLEAN
		require
			valid_wildcard: wildcard_xpath.has_wild_cards
		local
			i, j, from_pos, wildcard_from_pos, l_count: INTEGER
			l_area, wildcard_area: like area; wildcard_token: NATURAL_16
		do
			Result := True
			if wildcard_xpath.last.as_integer_32 = Type_any and not is_path_to_element then
				Result := False
			else
				from_pos := 1
				wildcard_from_pos := 1
				if wildcard_xpath.first.as_integer_32 = Type_descendant_or_self then
					from_pos := count - (wildcard_xpath.count - 1) + 1
					wildcard_from_pos := 2
				end
				if from_pos < 1 then
					Result := False
				else
					l_count := count; l_area := area; wildcard_area := wildcard_xpath.area
					from
						i := from_pos - 1; j := wildcard_from_pos - 1
					until
						not Result or i = l_count
					loop
						wildcard_token := wildcard_area [j]
						if wildcard_token.as_integer_32 /= Type_any and then l_area [i] /= wildcard_token then
							Result := False
						end
						i := i + 1; j := j + 1
					end
				end
			end
		end

feature {NONE} -- Implementation

	put (v: like item)
		do
			Precursor (v)
			internal_hash_code := 0
		end

feature {NONE} -- Internal attributes

	internal_hash_code: INTEGER

	type: INTEGER

feature {NONE} -- Constants

	Attribute_flag: NATURAL_16 = 0x8000

	Token_table: EL_XPATH_TOKEN_TABLE
		once
			create Result.make (23)
		end

end