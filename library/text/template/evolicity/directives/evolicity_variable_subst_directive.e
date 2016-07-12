note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-07-05 17:26:14 GMT (Tuesday 5th July 2016)"
	revision: "7"

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
					output.put_string (string_value)

				elseif attached {EL_PATH} value as path_value then
					output.put_string_z (path_value.to_string) -- Escaping is useful for OS commands

				elseif attached {REAL_REF} value as real_ref then
					put_double_value (output, real_ref.out)

				elseif attached {DOUBLE_REF} value as double_ref then
					put_double_value (output, double_ref.out)

				elseif attached {INTEGER_REF} value as integer_ref then
					output.put_integer (integer_ref.item)

				elseif attached {NATURAL_32_REF} value as natural_ref then
					output.put_natural (natural_ref.item)

				else
					output.put_string (value.out)
				end
			else
				output.put_string (Variable_template #$ [variable_path.joined ('.')])
			end
		end

feature {NONE} -- Implementation

	put_double_value (output: EL_OUTPUT_MEDIUM; value: STRING)
			-- ensure value is always output using dot as decimal separator
		local
			pos_comma: INTEGER
		do
			pos_comma := value.index_of (',', 1)
			if pos_comma > 0 then
				value [pos_comma] := '.'
			end
			output.put_string (value)
		end

	variable_path: EVOLICITY_VARIABLE_REFERENCE

feature {NONE} -- Constants

	Variable_template: ZSTRING
		once
			Result := "${%S}"
		end

end
