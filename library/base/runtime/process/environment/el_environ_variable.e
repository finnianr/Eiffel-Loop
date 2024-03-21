note
	description: "[
		Name-value pair that sets an environment variable when applied.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-03-21 16:10:18 GMT (Thursday 21st March 2024)"
	revision: "12"

class
	EL_ENVIRON_VARIABLE

inherit
	ANY
		redefine
			default_create
		end

	EL_MODULE_EXECUTION_ENVIRONMENT

	EL_STRING_GENERAL_ROUTINES

create
	make, make_assigned, default_create

convert
	make_assigned ({STRING_32, STRING_8, ZSTRING})

feature {NONE} -- Initialization

	default_create
		do
			create name.make_empty
			create value.make_empty
		end

	make (a_name, a_value: READABLE_STRING_GENERAL)
		do
			name := as_zstring (a_name); value := as_zstring (a_value)
		end

	make_assigned (str: READABLE_STRING_GENERAL)
		local
			parts: EL_ZSTRING_LIST
		do
			create parts.make_split (str, '=')
			if parts.count = 2 then
				make (parts.first, parts.last)
			else
				default_create
			end
		end

feature -- Access

	name: ZSTRING

	value: ZSTRING

	substituted_value: ZSTRING
		local
			template: EL_TEMPLATE [ZSTRING]
		do
			create template.make (value)
			Result := template.environ_substituted
		end

feature -- Status query

	is_valid: BOOLEAN
		do
			Result := not is_empty and then is_valid_name
		end

	is_empty: BOOLEAN
		do
			Result := name.is_empty and value.is_empty
		end

	is_valid_name: BOOLEAN
		do
			Result := name.count > 0 and then name.is_code_identifier
		end

feature -- Basic operations

	apply
		require
			valid_name_value_pair: is_valid
		do
			if value.has ('$') then
				Execution_environment.put (substituted_value, name)
			else
				Execution_environment.put (value, name)
			end
		ensure
			assigned: not value.has ('$') implies Execution_environment.item (name) ~ value
			assigned_path: value.has ('$') implies Execution_environment.item (name) ~ substituted_value
		end

end