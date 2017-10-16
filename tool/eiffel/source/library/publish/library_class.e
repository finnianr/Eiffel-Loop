note
	description: "Summary description for {LIBRARY_EIFFEL_CLASS}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-10 9:17:38 GMT (Tuesday 10th October 2017)"
	revision: "3"

class
	LIBRARY_CLASS

inherit
	EIFFEL_CLASS
		redefine
			make_default, is_library, getter_function_table, serialize, further_information_fields
		end

create
	make

feature {NONE} -- Initialization

	make_default
		do
			create client_examples.make (5)
			Precursor
		end

feature -- Status query

	is_library: BOOLEAN
		do
			Result := True
		end

feature -- Access

	client_examples: EL_ARRAYED_LIST [EIFFEL_CLASS]

feature -- Basic operations

	serialize
		local
			l_classes: like repository.example_classes
		do
			l_classes := repository.example_classes
			from l_classes.start until l_classes.after or else client_examples.count = Maximum_examples loop
				if l_classes.item.has_class_name (name) then
					client_examples.extend (l_classes.item)
				end
				l_classes.forth
			end
			Precursor
		end

feature {NONE} -- Implementation

	further_information_fields: EL_ZSTRING_LIST
		do
			Result := Precursor
			if not client_examples.is_empty then
				Result.extend ("client examples")
			end
		end

feature {NONE} -- Evolicity fields

	getter_function_table: like getter_functions
			--
		do
			Result := Precursor
			Result.append_tuples (<<
				["client_examples", agent: like client_examples do Result := client_examples end]
			>>)
		end

feature {NONE} -- Constants

	Maximum_examples: INTEGER
		once
			Result := 20
		end
end
