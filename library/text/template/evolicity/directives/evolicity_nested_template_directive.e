note
	description: "Summary description for {EVOLICITY_NESTED_TEMPLATE_DIRECTIVE}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-12 18:21:01 GMT (Thursday 12th October 2017)"
	revision: "2"

deferred class
	EVOLICITY_NESTED_TEMPLATE_DIRECTIVE

inherit
	EVOLICITY_COMPOUND_DIRECTIVE
		undefine
			execute
		redefine
			make
		end

	EL_MODULE_EVOLICITY_TEMPLATES
		undefine
			is_equal, copy
		end

feature -- Initialization

	make
			--
		do
			Precursor
			create tabs.make_empty
			create variable_ref.make_empty
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

	variable_ref: EVOLICITY_VARIABLE_REFERENCE

	tabs: STRING

end