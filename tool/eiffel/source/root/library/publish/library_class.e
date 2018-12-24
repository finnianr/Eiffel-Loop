note
	description: "Library class"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-12-24 12:21:28 GMT (Monday 24th December 2018)"
	revision: "7"

class
	LIBRARY_CLASS

inherit
	EIFFEL_CLASS
		redefine
			make_default, is_library, getter_function_table, sink_source_subsitutions, further_information_fields
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

feature -- Element change

	sink_source_subsitutions
		-- sink the values of $source occurrences `code_text'. Eg. [$source CLASS_NAME]
		-- and populate `client_examples' while adding the client paths to `current_digest'
		-- in alphabetical order of class name.
		local
			crc: like crc_generator; list: like Name_to_class_map_list
		do
			Precursor
			crc := crc_generator; list := Name_to_class_map_list
			list.wipe_out
			crc.set_checksum (current_digest)
			across repository.example_classes as l_class until list.full loop
				if l_class.item.has_class_name (name) then
					list.extend (l_class.item.name, l_class.item)
				end
			end
			list.sort (True)
			client_examples := list.value_list
			across client_examples as example loop
				crc.add_path (example.item.relative_source_path)
			end
			current_digest := crc.checksum
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
			Result := Precursor + ["client_examples", agent: like client_examples do Result := client_examples end]
		end

feature {NONE} -- Constants

	Maximum_examples: INTEGER
		once
			Result := 20
		end

	Name_to_class_map_list: EL_KEY_SORTABLE_ARRAYED_MAP_LIST [EL_ZSTRING, EIFFEL_CLASS]
		once
			create result.make (Maximum_examples)
		end
end
