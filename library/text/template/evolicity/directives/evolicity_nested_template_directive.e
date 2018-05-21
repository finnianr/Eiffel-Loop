note
	description: "Evolicity nested template directive"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 17:36:22 GMT (Saturday 19th May 2018)"
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