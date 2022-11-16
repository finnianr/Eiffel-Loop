note
	description: "[
		[$source GROUPED_ECF_LINES] to expand shorthand for 'platform' or 'custom' conditions
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:04 GMT (Tuesday 15th November 2022)"
	revision: "3"

class
	CONDITION_ECF_LINE

inherit
	GROUPED_ECF_LINES
		redefine
			make, set_variables, template
		end

	EL_STRING_8_CONSTANTS

create
	make

feature {NONE} -- Initialization

	make
		do
			Precursor
			template := Custom_template
		end

feature -- Access

	tag_name: STRING
		do
			Result := Name.condition
		end

feature {NONE} -- Implementation

	set_variables (nvp: ECF_NAME_VALUE_PAIR)
		do
			if across Element_list as list some nvp.name.same_string (list.item) end then
				template := Element_template
				template.put (Var.element, nvp.name)
			else
				template := Custom_template
				template.put (Var.name, nvp.name)
			end
			if nvp.is_excluded_value then
				template.put (Var.excluded_prefix, Name.excluded_)
			else
				template.put (Var.excluded_prefix, Empty_string_8)
			end
			template.put (Var.value, nvp.value)
		end

feature {NONE} -- Internal attributes

	template: EL_TEMPLATE [STRING]

feature {NONE} -- Constants

	Element_list: EL_STRING_8_LIST
		-- condition elements
		once
			Result := "concurrency, dotnet, platform"
		end

end