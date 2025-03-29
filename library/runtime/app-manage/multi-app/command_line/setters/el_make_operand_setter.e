note
	description: "[
		Sets the command operands for the generic `command' in class ${EL_COMMAND_LINE_APPLICATION}
	]"
	tests: "Class ${COMMAND_ARGUMENTS_TEST_SET}"
	descendants: "[
			EL_MAKE_OPERAND_SETTER* [G]
				${EL_OPERAND_SETTER [G]}
				${EL_MAKEABLE_FROM_ZSTRING_OPERAND_SETTER}
				${EL_BOOLEAN_OPERAND_SETTER}
				${EL_PATH_OPERAND_SETTER [G -> EL_PATH create make_expanded end]}
					${EL_BUILDABLE_FROM_FILE_OPERAND_SETTER}
				${EL_STRING_TABLE_OPERAND_SETTER}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-03-29 12:04:55 GMT (Saturday 29th March 2025)"
	revision: "32"

deferred class
	EL_MAKE_OPERAND_SETTER [G]

inherit
	ANY; EL_MODULE_NAMING

feature {EL_FACTORY_CLIENT} -- Initialization

	make (a_argument: like argument)
		do
			argument := a_argument
		end

	make_list (a_argument: like argument)
		do
			make (a_argument)
			is_bag := True
		end

feature -- Basic operations

	try_put_operand
		local
			string_value: ZSTRING; ref_argument: ANY
			has_argument, has_default_argument: BOOLEAN
		do
			if argument.has_value then
				string_value := argument.string_value
				has_argument := True
			else
				create string_value.make_empty
				if operands.is_reference_item (index) then
					if attached operands.reference_item (index) as ref_item then
						ref_argument := ref_item
						has_default_argument := True
					end
				else
					has_default_argument := True
				end
			end
			if argument.is_required and not has_argument then
				extend_errors (agent {EL_COMMAND_ARGUMENT_ERROR}.set_required_error)

			elseif has_argument or has_default_argument then
				if string_value.is_empty then
					if attached {G} ref_argument as l_value then
						try_put_value (l_value)
					end
				else
					across new_list (string_value) as str until argument.manager.has_error loop
						if is_convertible (str.item) then
							try_put_value (value (str.item))
						else
							extend_errors (agent {EL_COMMAND_ARGUMENT_ERROR}.set_type_error (type_description))
						end
					end
				end
			else
				extend_errors (agent {EL_COMMAND_ARGUMENT_ERROR}.set_no_default_argument)
			end
		end

feature {NONE} -- Factory

	new_error: EL_COMMAND_ARGUMENT_ERROR
		do
			create Result.make (argument.word_option)
		end

	new_list (string_value: ZSTRING): EL_ZSTRING_LIST
		local
			separator: CHARACTER_32
		do
			if is_bag then
				if argument.is_value_list then
					Result := argument.as_value_list
				else
					separator := ';'
					if not string_value.has (separator) then
						separator := ','
					end
					create Result.make_adjusted_split (string_value, separator, {EL_SIDE}.Left)
				end
			else
				create Result.make (1)
				Result.extend (string_value)
			end
		end

feature {NONE} -- Implementation

	default_argument_setter (a_value: like value; a_description: ZSTRING): PROCEDURE [EL_COMMAND_ARGUMENT_ERROR]
		do
			Result := agent {EL_COMMAND_ARGUMENT_ERROR}.set_invalid_argument (a_description)
		end

	extend_errors (set_error_type: PROCEDURE [EL_COMMAND_ARGUMENT_ERROR])
		require
			valid_operands: set_error_type.valid_operands ([new_error])
		do
			if attached new_error as error then
				set_error_type (error)
				argument.manager.put (error)
			end
		end

	index: INTEGER
		-- operand index for argument
		do
			Result := argument.index
		end

	is_convertible (string_value: ZSTRING): BOOLEAN
		do
			Result := True
		end

	operands: TUPLE
		do
			Result := argument.operands
		end

	put_reference (a_value: like value)
		do
			operands.put_reference (a_value, index)
		end

	try_put_value (a_value: like value)
		do
			validate (a_value)
			if not argument.manager.has_error then
				if is_bag and then attached {BAG [G]} operands.item (index) as list then
					list.extend (a_value)
				else
					put_reference (a_value)
				end
			end
		end

	type_description: ZSTRING
		do
			Result := value_description
			if is_bag then
				Result.prepend_string_general ("a list of ")
				Result.append_character ('s')
			end
		end

	validate (a_value: like value)
		local
			l_operands: TUPLE; description: ZSTRING; valid_value: PREDICATE
		do
			across argument.validation_table as table loop
				description := table.key; valid_value := table.item

				inspect valid_value.open_count
					when 1 then
						l_operands := [a_value]
					when 2 then
						-- Example: is_valid_path (path: EL_PATH; is_optional: BOOLEAN): BOOLEAN
						l_operands := [a_value, not argument.is_required]
				else
					l_operands := []
				end
				if valid_value.valid_operands (l_operands) then
					valid_value.set_operands (l_operands)
					valid_value.apply

					if not valid_value.last_result then
						if description.has ('%S') then
							if is_bag then
								description := description #$ [a_value]
							else
								-- Example: "The %S number must be within range 1 to 65535"
								description := description #$ [argument.word_option]
							end
						end
						extend_errors (default_argument_setter (a_value, description))
					end
				else
					check
						validation_operands_valid: False
					end
				end
			end
		end

	value (str: ZSTRING): G
		deferred
		end

	value_description: ZSTRING
		do
			if attached Naming.new_type_words ({G}) as words then
				words.remove_el_prefix
				Result := words.as_word_string
			end
			Result.to_lower
		end

feature {NONE} -- Internal attributes

	argument: EL_COMMAND_ARGUMENT

	is_bag: BOOLEAN

end