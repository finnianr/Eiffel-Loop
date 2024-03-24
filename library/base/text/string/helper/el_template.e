note
	description: "[
		Basic string template to substitute variables names with possible forms:
		
			$a_1 OR ${a_1}
			
		and composed of characters in ranges
			
			'a' .. 'z'
			'A' .. 'Z'
			'0' .. '9'
			'_'
			
		For a literal dollar sign use % to escape it, for example: "USD 100 %$"
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-03-24 12:05:10 GMT (Sunday 24th March 2024)"
	revision: "20"

class
	EL_TEMPLATE [S -> STRING_GENERAL create make, make_empty end]

inherit
	EL_STRING_LIST [S]
		rename
			append_to as substitute_to,
			joined_strings as substituted,
			item as list_item,
			has as has_item,
			put as put_item,
			make as make_list
		export
			{NONE} all
			{ANY} substituted, substitute_to
		end

create
	make

convert
	make ({S})

feature {NONE} -- Initialization

	make (a_template: READABLE_STRING_GENERAL)
		local
			dollor_split: EL_SPLIT_ON_CHARACTER [S]; item: S; previous_end_character: CHARACTER_32
			i, length, start_index, end_index, variable_count: INTEGER; has_braces: BOOLEAN
		do
			create dollor_split.make (new_string (a_template), '$')
			variable_count := a_template.occurrences ('$')
			create variable_values.make_size (variable_count)
			make_list (variable_count * 2)
			across dollor_split as list loop
				item := list.item
				if list.cursor_index = 1 or else previous_end_character = '%%' then
					if previous_end_character = '%%' then
						last.put_code ({EL_ASCII}.Dollar, last.count)
					end
					if not item.is_empty then
						extend (item.twin)
					end
				else
					length := 0; has_braces := False
					from i := 1 until i > item.count loop
						inspect item [i]
							when 'a'.. 'z', 'A'.. 'Z', '0' .. '9', '_', '{' then
								length := length + 1
								i := i + 1
							when '}' then
								length := length + 1
								i := item.count + 1
								has_braces := True
						else
							i := item.count + 1
						end
					end
					if has_braces then
						start_index := 2; end_index := length - 1
					else
						start_index := 1; end_index := length
					end
					put_variable (item.substring (start_index, end_index).to_string_8)
					if length < item.count then
						extend (item.substring (length + 1, item.count))
					end
				end
				if item.count > 0 then
					previous_end_character := item [item.count]
				else
					previous_end_character := '%U'
				end
			end
		end

feature -- Access

	variable_values: EL_STRING_8_TABLE [S]
		-- variable name list

feature -- Element change

	put (name: READABLE_STRING_8; value: S)
		require
			has_name: has (name)
		do
			if variable_values.has_key (name) and then attached variable_values.found_item as place_holder then
				place_holder.keep_head (0)
				place_holder.append (value)
			end
		end

	put_general (name: READABLE_STRING_8; value: READABLE_STRING_GENERAL)
		do
			put (name, new_string (value))
		end

feature -- Status query

	has (name: READABLE_STRING_8): BOOLEAN
		do
			Result := variable_values.has (name)
		end

feature {NONE} -- Implementation

	new_canonical_name (name: READABLE_STRING_8): STRING_8
		-- canonical form of variable name
		do
			Result := "${}"
			Result.insert_string (name, 3)
		end

	put_variable (name: READABLE_STRING_8)
		local
			place_holder: S
		do
			if variable_values.has_key (name) then
			-- same `place_holder' can appear repeatedly in `Current' list
				place_holder := variable_values.found_item
			else
				create place_holder.make_empty
				place_holder.append (new_string (new_canonical_name (name)))
				variable_values.extend (place_holder, name)
			end
			extend (place_holder)
		end

end