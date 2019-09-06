note
	description: "Text substitution template for date-to-text functions defined in `function_table'"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-12-17 18:41:14 GMT (Monday 17th December 2018)"
	revision: "1"

class
	EL_DATE_TEXT_TEMPLATE

inherit
	ANY

	EL_ZSTRING_CONSTANTS

	EL_MODULE_ZSTRING

create
	make

feature {NONE} -- Initialization

	make (a_template: READABLE_STRING_GENERAL; a_function_table: like function_table)
		local
			list: EL_SPLIT_ZSTRING_LIST
			i, length: INTEGER
		do
			function_table := a_function_table
			create list.make (Zstring.as_zstring (a_template), character_string ('$'))
			create variable_values.make (list.count)
			create result_list.make (list.count * 2)
			from list.start until list.after loop
				if not list.item.is_empty then
					length := 0
					from i := 1 until i > list.item.count loop
						inspect list.item [i]
							when 'a'.. 'z', 'A'.. 'Z', '_' then
								length := length + 1
								i := i + 1
						else
							i := list.item.count + 1
						end
					end
					variable_values.put (create {ZSTRING}.make_empty, list.item.substring (1, length))
					result_list.extend (variable_values.found_item)
					if length < list.item.count then
						result_list.extend (list.item.substring_end (length + 1))
					end
				end
				list.forth
			end
		ensure
			valid_variables: valid_variables
		end

feature -- Access

	substituted (date: DATE): ZSTRING
			--
		do
			across variable_values as name loop
				if function_table.has_key (name.key) then
					name.item.share (function_table.found_item (date))
				end
			end
			Result := result_list.joined_words
		end

feature -- Contract Support

	valid_variables: BOOLEAN
		do
			Result := variable_values.current_keys.for_all (agent function_table.has)
		end

feature {NONE} -- Implementation

	function_table: EL_DATE_FUNCTION_TABLE

	result_list: EL_ZSTRING_LIST

	variable_values: HASH_TABLE [ZSTRING, STRING]
		-- variable name list

end
