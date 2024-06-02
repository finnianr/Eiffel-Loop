note
	description: "Library class"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-06-01 13:06:25 GMT (Saturday 1st June 2024)"
	revision: "18"

class
	EIFFEL_LIBRARY_CLASS

inherit
	EIFFEL_CLASS
		redefine
			make_default, is_library, getter_function_table, further_information_fields,
			sink_source_substitutions
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
		do
			Precursor -- crc reset in precursor

			if attached Once_crc_generator as crc and then attached Once_class_table as table then
				across repository.example_classes as class_list until table.count = Maximum_examples loop
					if attached class_list.item as e_class and then e_class.has_class_name (name) then
						table.put (e_class, e_class.name)
					end
				end
				client_examples := table.item_list
				across client_examples as example loop
					crc.add_path (example.item.relative_source_path)
				end
				current_digest := crc.checksum
			end
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

	Once_class_table: EL_HASH_TABLE [EIFFEL_CLASS, ZSTRING]
		once
			create result.make_size (Maximum_examples)
		end
end