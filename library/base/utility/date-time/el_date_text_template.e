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

create
	make

feature {NONE} -- Initialization

	make (a_template: STRING; a_function_table: like function_table)
		do
			function_table := a_function_table
			create variables.make_with_separator (a_template, '$', False)
			variables.start; variables.remove
			variables.right_adjust
			create result_list.make (variables.count)
			across variables as name loop
				result_list.extend (name.item)
			end
		ensure
			valid_variables: valid_variables
		end

feature -- Access

	substituted (date: DATE): ZSTRING
			--
		do
			across variables as name loop
				if function_table.has_key (name.item) then
					result_list [name.cursor_index] := function_table.found_item (date)
				end
			end
			Result := result_list.joined_words
		end

feature -- Contract Support

	valid_variables: BOOLEAN
		do
			Result := variables.for_all (agent function_table.has)
		end

feature {NONE} -- Implementation

	function_table: EL_DATE_FUNCTION_TABLE

	result_list: EL_ZSTRING_LIST

	variables: EL_STRING_8_LIST
		-- variable name list

end
