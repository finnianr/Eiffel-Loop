note
	description: "Text substitution template for date-to-text functions defined in `function_table'"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-03-25 15:34:19 GMT (Monday 25th March 2024)"
	revision: "7"

class
	EL_DATE_TEXT_TEMPLATE

inherit
	EL_TEMPLATE [ZSTRING]
		rename
			make as make_template,
			substituted as substituted_template
		end

create
	make

feature {NONE} -- Initialization

	make (a_template: READABLE_STRING_GENERAL; a_function_table: like function_table)
		do
			function_table := a_function_table
			make_template (a_template)
		ensure
			valid_variables: valid_variables
		end

feature -- Access

	substituted (date: DATE): ZSTRING
			--
		do
			across place_holder_table as name loop
				if function_table.has_key (name.key) then
					name.item.share (function_table.found_item (date))
				end
			end
			Result := substituted_template
		end

feature -- Contract Support

	valid_variables: BOOLEAN
		do
			Result := place_holder_table.current_keys.for_all (agent function_table.has)
		end

feature {NONE} -- Internal attributes

	function_table: EL_DATE_FUNCTION_TABLE

end