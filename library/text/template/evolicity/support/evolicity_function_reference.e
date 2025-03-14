note
	description: "Evolicity function reference"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-03-14 11:34:34 GMT (Friday 14th March 2025)"
	revision: "11"

class
	EVOLICITY_FUNCTION_REFERENCE

inherit
	EVOLICITY_VARIABLE_REFERENCE
		rename
			make as make_variable
		redefine
			arguments_count, new_result, set_context
		end

	EL_MODULE_CONVERT_STRING

create
	make

feature {NONE} -- Initialization

	make (parser: EVOLICITY_PARSE_ACTIONS; start_index, end_index, left_bracket_index: INTEGER)
		require
			is_left_bracket: parser.tokens_text.code (left_bracket_index) = Token.left_bracket
			is_right_bracket: parser.tokens_text.code (end_index) = Token.right_bracket
		local
			i, name_index: INTEGER; i_th_token: NATURAL_32; string_arg: ZSTRING
		do
			make_variable (parser, start_index, left_bracket_index - 1)
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
						arguments.extend (create {EVOLICITY_VARIABLE_REFERENCE}.make (parser, name_index, i - 1))

					elseif i_th_token = Token.quoted_string then
						string_arg := parser.source_text_for_token (i)
						string_arg.remove_quotes
						if string_arg.is_valid_as_string_8 then
							arguments.extend (string_arg.to_string_8)
						else
							arguments.extend (string_arg)
						end

					elseif i_th_token = Token.double_constant then
						arguments.extend (parser.source_text_for_token (i).to_double)

					elseif i_th_token = Token.integer_64_constant then
						arguments.extend (parser.source_text_for_token (i).to_integer_64)

					end
					i := i + 1
				end
			end
		end

feature -- Access

	arguments: EL_ARRAYED_LIST [ANY]
		-- Arguments for eiffel context function with open arguments

	context: EVOLICITY_CONTEXT

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

	set_context (a_context: EVOLICITY_CONTEXT)
		do
			context := a_context
		end

feature {NONE} -- Implementation

	new_operands (function: FUNCTION [ANY]): TUPLE
		local
			type: TYPE [ANY]; value: ANY; function_info: EL_FUNCTION_INFO
		do
			if attached internal_function_info as info
				and then {ISE_RUNTIME}.dynamic_type (function) = info.type.type_id
			then
				function_info := info
			else
				create function_info.make (last_step, function.generating_type)
				internal_function_info := function_info
			end

			Result := function_info.new_tuple_argument
			if attached function_info.argument_types as argument_types then
				across arguments as arg loop
					type := argument_types [arg.cursor_index]; value := arg.item
					if attached {EVOLICITY_VARIABLE_REFERENCE} value as variable
						and then attached context.referenced_item (variable) as target_value
					then
						value := target_value
					end
					if value.generating_type ~ type then
						Result.put (value, arg.cursor_index)

					elseif attached {READABLE_STRING_GENERAL} value as general then
						Result.put (Convert_string.to_type (general, type), arg.cursor_index)
					end
				end
			end
		end


feature {NONE} -- Internal attributes

	internal_function_info: detachable EL_FUNCTION_INFO

feature {NONE} -- Constants

	Default_context: EVOLICITY_CONTEXT_IMP
		once ("PROCESS")
			create Result.make
		end
end