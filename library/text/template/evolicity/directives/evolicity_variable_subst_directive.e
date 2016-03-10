note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-07-22 18:08:03 GMT (Monday 22nd July 2013)"
	revision: "4"

class
	EVOLICITY_VARIABLE_SUBST_DIRECTIVE

inherit
	EVOLICITY_DIRECTIVE

	EL_MODULE_STRING

create
	make

feature {NONE} -- Initialization

	make (a_variable_path: like variable_path)
			--
		do
			variable_path := a_variable_path
		end

feature -- Basic operations

	execute (context: EVOLICITY_CONTEXT; output: IO_MEDIUM; utf8_encoded: BOOLEAN)
			--
		do
			if attached {ANY} context.referenced_item (variable_path) as value then
				if attached {EL_ASTRING} value as l_str then
					put_string (output, l_str, utf8_encoded)

				elseif attached {STRING} value as str8 then
					output.put_string (str8)

				elseif attached {REAL_REF} value as real_ref then
					put_double_value (output, real_ref.out)

				elseif attached {DOUBLE_REF} value as double_ref then
					put_double_value (output, double_ref.out)

				else
					output.put_string (value.out)
				end
			else
				output.put_string ("${" + String.joined (variable_path, ".") + "}")
			end
		end

feature {NONE} -- Implementation

	put_double_value (output: IO_MEDIUM; value: STRING)
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

end -- class EVOLICITY_VARIABLE_SUBST_DIRECTIVE
