note
	description: "Evolicity variable subst directive"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-07-31 12:46:07 GMT (Monday 31st July 2023)"
	revision: "8"

class
	EVOLICITY_VARIABLE_SUBST_DIRECTIVE

inherit
	EVOLICITY_DIRECTIVE

create
	make

feature {NONE} -- Initialization

	make (a_variable_path: like variable_path)
			--
		do
			variable_path := a_variable_path
		end

feature -- Basic operations

	execute (context: EVOLICITY_CONTEXT; output: EL_OUTPUT_MEDIUM)
			--
		do
			if attached {ANY} context.referenced_item (variable_path) as value then
				if attached {READABLE_STRING_GENERAL} value as string_value then
					output.put_string_general (string_value)

				elseif attached {EL_PATH} value as path_value then
					output.put_string (path_value.to_string) -- Escaping is useful for OS commands

				elseif attached {REAL_REF} value as real_ref then
					output.put_raw_string_8 (replaced_separator (real_ref.out))

				elseif attached {DOUBLE_REF} value as double_ref then
					output.put_raw_string_8 (replaced_separator (double_ref.out))

				elseif attached {INTEGER_REF} value as integer_ref then
					output.put_integer_32 (integer_ref.item)

				elseif attached {NATURAL_32_REF} value as natural_ref then
					output.put_natural_32 (natural_ref.item)

				else
					output.put_string_8 (value.out)
				end
			else
				output.put_string (Variable_template #$ [variable_path.joined ('.')])
			end
		end

feature {NONE} -- Implementation

	replaced_separator (value: STRING): STRING
		-- ensure value uses dot as decimal separator
		local
			pos_comma: INTEGER
		do
			Result := value
			pos_comma := Result.index_of (',', 1)
			if pos_comma > 0 then
				Result.put ('.', pos_comma)
			end
		end

	variable_path: EVOLICITY_VARIABLE_REFERENCE

feature {NONE} -- Constants

	Variable_template: ZSTRING
		once
			Result := "${%S}"
		end

end