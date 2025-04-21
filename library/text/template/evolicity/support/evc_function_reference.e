note
	description: "Evolicity function reference"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-21 11:34:38 GMT (Monday 21st April 2025)"
	revision: "16"

class
	EVC_FUNCTION_REFERENCE

inherit
	EVC_VARIABLE_REFERENCE
		rename
			make as make_variable
		redefine
			arguments_count, new_result, set_context
		end

	EL_TYPE_UTILITIES
		export
			{NONE} all
		undefine
			as_structure, copy, is_equal, out
		end

	EL_MODULE_CONVERT_STRING; EL_MODULE_EIFFEL; EL_MODULE_TUPLE

create
	make

feature {NONE} -- Initialization

	make (parser: EVC_PARSE_ACTIONS; start_index, end_index: INTEGER)
		require
			valid_interval: end_index > start_index
			starts_with_at_sign: parser.tokens_text.code (start_index) = Token.at_sign
			ends_with_right_bracket: parser.tokens_text.code (end_index) = Token.right_bracket
		local
			i, name_index, left_bracket_index: INTEGER; i_th_token: NATURAL_32; string_arg: ZSTRING
		do
			left_bracket_index := parser.index_of (Token.Left_bracket, start_index + 1, end_index)

			make_variable (parser, start_index + 1, left_bracket_index - 1)
			context := Default_context
			create arguments.make (parser.occurrences (Token.comma_sign, left_bracket_index + 1, end_index) + 1)

			if attached parser.tokens_text as tokens_text then
				from i := left_bracket_index + 1 until i > end_index loop
					i_th_token := tokens_text.code (i)
					if i_th_token = Token.unqualified_name then
						name_index := i
						i := parser.index_of (Token.comma_sign, name_index, end_index)
						if i = 0 then
							i := parser.index_of (Token.right_bracket, name_index, end_index)
						end
						arguments.extend (create {EVC_VARIABLE_REFERENCE}.make (parser, name_index, i - 1))

					elseif i_th_token = Token.Literal_string then
						string_arg := parser.token_text (i)
						string_arg.remove_ends
						if string_arg.is_valid_as_string_8 then
							arguments.extend (string_arg.to_string_8)
						else
							arguments.extend (string_arg)
						end

					elseif i_th_token = Token.literal_real then
						arguments.extend (parser.token_text (i).to_real_64)

					elseif i_th_token = Token.Literal_integer then
						arguments.extend (parser.token_text (i).to_integer_64)

					end
					i := i + 1
				end
			end
		end

feature -- Access

	arguments: EL_ARRAYED_LIST [ANY]
		-- Arguments for eiffel context function with open arguments

	context: EVC_CONTEXT

	new_result (function: FUNCTION [ANY]): detachable ANY
		do
			if attached new_operands (function) as operands
				and then function.valid_operands (operands)
			then
				Result := function.item (operands)
			end
		end

feature -- Measurement

	arguments_count: INTEGER
		do
			Result := arguments.count
		end

feature -- Element change

	set_context (a_context: EVC_CONTEXT)
		do
			context := a_context
		end

feature {NONE} -- Implementation

	function_info (function: FUNCTION [ANY]): EL_FUNCTION_INFO
		do
			if attached internal_function_info as info
				and then {ISE_RUNTIME}.dynamic_type (function) = info.type.type_id
			then
				Result := info
			else
				create Result.make (last_step, function.generating_type)
				internal_function_info := Result
			end
		end

	new_operands (function: FUNCTION [ANY]): TUPLE
		local
			type: TYPE [ANY]; value: ANY
			value_type_id: INTEGER
		do
			if attached function_info (function) as info then
				Result := info.new_tuple_argument
				if attached info.argument_types as argument_types then
					across arguments as arg loop
						type := argument_types [arg.cursor_index]; value := arg.item
						if attached {EVC_VARIABLE_REFERENCE} value as variable
							and then attached context.referenced_item (variable) as target_value
						then
							value := target_value
							value_type_id := {ISE_RUNTIME}.dynamic_type (value)
						else
							value_type_id := 0
						end
						if value_type_id = type.type_id then
							Result.put (value, arg.cursor_index)

						elseif type.is_expanded and then same_abstract_types (type.type_id, value_type_id) then
							Tuple.set_i_th_as_expanded (Result, arg.cursor_index, value)

						elseif attached {READABLE_STRING_GENERAL} value as general then
							Result.put (Convert_string.to_type (general, type), arg.cursor_index)
						end
					end
				end
			else
				create Result
			end
		end


feature {NONE} -- Internal attributes

	internal_function_info: detachable EL_FUNCTION_INFO

feature {NONE} -- Constants

	Default_context: EVC_CONTEXT_IMP
		once ("PROCESS")
			create Result.make
		end
end