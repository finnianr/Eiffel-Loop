note
	description: "Summary description for {EVOLICITY_NESTED_TEMPLATE_DIRECTIVE}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-07-22 18:08:03 GMT (Monday 22nd July 2013)"
	revision: "3"

deferred class
	EVOLICITY_NESTED_TEMPLATE_DIRECTIVE

inherit
	EVOLICITY_COMPOUND_DIRECTIVE
		undefine
			execute
		redefine
			make
		end

	EL_MODULE_EVOLICITY_ENGINE
		undefine
			is_equal, copy
		end

	EL_MODULE_STRING
		undefine
			is_equal, copy
		end

feature -- Initialization

	make
			--
		do
			Precursor
			create tabs.make_empty
			create variable_ref
		end

feature -- Element change

	set_tab_indent (tab_indent: INTEGER)
			--
		do
 			create tabs.make_filled ('%T', tab_indent)
 		end

	set_variable_ref (a_variable_ref: like variable_ref)
			--
		do
			variable_ref := a_variable_ref
		end

feature {NONE} -- Implementation

	put_indented_string (output: IO_MEDIUM; a_string: EL_ASTRING; utf8_encoded: BOOLEAN)
			--
		do
			output.put_string (tabs)
			put_string (output, String.indented_text (a_string, tabs.count), utf8_encoded)
			output.put_string (tabs)
			output.put_character ('%N')
		end

	variable_ref: EVOLICITY_VARIABLE_REFERENCE

	tabs: EL_ASTRING

end
