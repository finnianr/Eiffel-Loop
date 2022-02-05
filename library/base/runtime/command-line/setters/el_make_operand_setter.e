note
	description: "[
		Sets the command operands for the generic `command` in class `[$source EL_COMMAND_LINE_APPLICATION]`
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-05 14:46:40 GMT (Saturday 5th February 2022)"
	revision: "15"

deferred class
	EL_MAKE_OPERAND_SETTER [G]

inherit
	ANY

	EL_ZSTRING_CONSTANTS

	EL_MODULE_ARGS

feature {EL_FACTORY_CLIENT} -- Initialization

	make (a_make_routine: like make_routine; a_argument: like argument)
		do
			make_routine := a_make_routine; argument := a_argument
		end

	make_list (a_make_routine: like make_routine; a_argument: like argument)
		do
			make (a_make_routine, a_argument)
			is_list := True
		end

feature -- Basic operations

	set_operand (i: INTEGER)
		local
			string_value: ZSTRING; ref_argument: ANY
			has_argument, has_default_argument: BOOLEAN
		do
			if Args.has_value (argument.word_option) then
				string_value := Args.value (argument.word_option)
				has_argument := True
			else
				create string_value.make_empty
				if make_routine.operands.is_reference_item (i) then
					if attached make_routine.operands.reference_item (i) as ref_item then
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
						try_put_value (l_value, i)
					end
				else
					across new_list (string_value) as str loop
						if is_convertible (str.item) then
							try_put_value (value (str.item), i)
						else
							extend_errors (agent {EL_COMMAND_ARGUMENT_ERROR}.set_type_error (type_description))
						end
					end
				end
			else
				extend_errors (agent {EL_COMMAND_ARGUMENT_ERROR}.set_no_default_argument)
			end
		end

feature {NONE} -- Implementation

	default_argument_setter (a_value: like value; a_description: ZSTRING): PROCEDURE [EL_COMMAND_ARGUMENT_ERROR]
		do
			Result := agent {EL_COMMAND_ARGUMENT_ERROR}.set_invalid_argument (a_description)
		end

	is_convertible (string_value: ZSTRING): BOOLEAN
		do
			Result := True
		end

	try_put_value (a_value: like value; i: INTEGER)
		do
			validate (a_value)
			if not make_routine.has_argument_errors then
				if is_list and then attached {CHAIN [like value]} make_routine.operands.item (i) as list then
					list.extend (a_value)
				else
					put_reference (a_value, i)
				end
			end
		end

	new_list (string_value: ZSTRING): EL_ZSTRING_LIST
		local
			separator: CHARACTER_32
		do
			if is_list then
				separator := ';'
				if not string_value.has (separator) then
					separator := ','
				end
				create Result.make_adjusted_split (string_value, separator, {EL_STRING_ADJUST}.Left)
			else
				create Result.make_from_array (<< string_value >>)
			end
		end

	put_reference (a_value: like value; i: INTEGER)
		do
			make_routine.operands.put_reference (a_value, i)
		end

	extend_errors (set_error_type: PROCEDURE [EL_COMMAND_ARGUMENT_ERROR])
		require
			valid_operands: set_error_type.valid_operands ([new_error])
		do
			if attached new_error as error then
				set_error_type (error)
				make_routine.extend_errors (error)
			end
		end

	new_error: EL_COMMAND_ARGUMENT_ERROR
		do
			create Result.make (argument.word_option)
		end

	value (str: ZSTRING): G
		deferred
		end

	validate (a_value: like value)
		local
			operands: TUPLE; description: ZSTRING; is_valid_value: PREDICATE
		do
			across argument.validation_table as table loop
				description := table.key; is_valid_value := table.item

				inspect is_valid_value.open_count
					when 1 then
						operands := [a_value]
					when 2 then
						-- Example: is_valid_path (path: EL_PATH; is_optional: BOOLEAN): BOOLEAN
						operands := [a_value, not argument.is_required]
				else
					operands := []
				end
				if is_valid_value.valid_operands (operands) then
					is_valid_value.set_operands (operands)
					is_valid_value.apply

					if not is_valid_value.last_result then
						if description.has ('%S') then
							-- Example: "The %S number must be within range 1 to 65535"
							description := description #$ [argument.word_option]
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

	value_description: ZSTRING
		local
			type: TYPE [like value]; name: STRING
			s: EL_STRING_8_ROUTINES
		do
			type := {like value}
			name := type.name.as_lower
			if name.starts_with ("el_") then
				name.remove_head (3)
			end
			s.replace_character (name, '_', ' ')
			Result := name
		end

	type_description: ZSTRING
		do
			Result := value_description
			if is_list then
				Result.prepend_string_general ("a list of ")
				Result.append_character ('s')
			end
		end

feature {NONE} -- Internal attributes

	make_routine: EL_MAKE_PROCEDURE_INFO

	argument: EL_COMMAND_ARGUMENT

	is_list: BOOLEAN

end