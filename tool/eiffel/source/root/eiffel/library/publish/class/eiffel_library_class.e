note
	description: "Library class"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-06-07 7:16:33 GMT (Friday 7th June 2024)"
	revision: "21"

class
	EIFFEL_LIBRARY_CLASS

inherit
	EIFFEL_CLASS
		redefine
			make_default, is_library, getter_function_table, further_information_fields,
			set_class_use_set, set_client_examples, sink_source_substitutions
		end

create
	make

feature {NONE} -- Initialization

	make_default
		do
			client_examples := Default_client_examples
			Precursor
		end

feature -- Status query

	is_library: BOOLEAN
		do
			Result := True
		end

feature -- Access

	client_examples: ARRAY [EIFFEL_CLASS]

feature -- Element change

	sink_source_substitutions
		-- sink the values of ${<type-name>} occurrences `code_text'. Eg. ${CLASS_NAME}
		-- and populate `client_examples' while adding the client paths to `current_digest'
		-- in alphabetical order of class name.
		do
			Precursor -- crc reset in precursor
			if attached Once_crc_generator as crc then
				across client_examples as example loop
					crc.add_path (example.item.relative_source_path)
				end
				current_digest := crc.checksum
			end
		end

	set_client_examples (class_list: LIST [EIFFEL_CLASS])
		local
			class_name: IMMUTABLE_STRING_8
		do
			if attached Class_buffer_table as table then
				table.wipe_out
				across class_list as list until table.count = Maximum_examples loop
					if attached list.item as example then
					-- use class alias in preference to actual name
						if attached alias_name as l_alias then
							class_name := l_alias.to_shared_immutable_8
						else
							class_name := name.to_shared_immutable_8
						end
						if example.class_use_set.has (class_name) then
							table.put (example, example.name)
						end
					end
				end
				if table.count > 0 then
					table.item_list.trim
					create client_examples.make_from_special (table.item_list.area.twin)
				end
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

	set_class_use_set
		do
			class_use_set := Default_class_use_set
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

	Class_buffer_table: EL_HASH_TABLE [EIFFEL_CLASS, ZSTRING]
		once
			create Result.make_size (Maximum_examples)
		end

	Default_client_examples: ARRAY [EIFFEL_CLASS]
		once
			create Result.make_empty
		end
end