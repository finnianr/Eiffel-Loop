note
	description: "Library class"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:27 GMT (Saturday 20th January 2024)"
	revision: "17"

class
	EIFFEL_LIBRARY_CLASS

inherit
	EIFFEL_CLASS
		redefine
			make_default, is_library, getter_function_table, sink_source_substitutions, further_information_fields
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

	sink_source_substitutions
		-- sink the values of ${<type-name>} occurrences `code_text'. Eg. ${CLASS_NAME}
		-- and populate `client_examples' while adding the client paths to `current_digest'
		-- in alphabetical order of class name.
		local
			crc: like crc_generator; list: like Name_to_class_map_list
			previous_name: ZSTRING
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
			if not list.is_empty then
				list.sort_by_key (True)
				-- Remove duplicate names Eg. BUILD_INFO as example of using DIR_PATH
				list.start
				previous_name := list.item_key
				from list.forth until list.after loop
					if previous_name ~ list.item_key then
						list.remove
					else
						previous_name := list.item_key
						list.forth
					end
				end
			end
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

	Name_to_class_map_list: EL_ARRAYED_MAP_LIST [EL_ZSTRING, EIFFEL_CLASS]
		once
			create result.make (Maximum_examples)
		end
end