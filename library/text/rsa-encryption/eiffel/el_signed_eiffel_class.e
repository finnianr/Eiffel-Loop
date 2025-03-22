note
	description: "Eiffel class with signed fields"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-03-21 12:31:58 GMT (Friday 21st March 2025)"
	revision: "14"

class
	EL_SIGNED_EIFFEL_CLASS

inherit
	EVC_REFLECTIVE_SERIALIZEABLE
		rename
			escaped_field as unescaped_field,
			field_included as is_any_field,
			field_list as current_field_list,
			foreign_naming as eiffel_naming
		export
			{NONE} all
			{ANY} serialize
		redefine
			initialize_fields
		end

create
	make

feature {NONE} -- Initialization

	make (a_output_path: FILE_PATH; a_serial_number: STRING)
		do
			make_from_file (a_output_path)
			serial_number := a_serial_number
		end

	initialize_fields
		-- set fields that have not already been initialized with a value
		do
			Precursor
			create field_list.make (3)
			manifest_close := "]%""
			manifest_open := "%"["
		end

feature -- Access

	serial_number: STRING

	field_list: EL_ARRAYED_LIST [EL_SIGNED_EIFFEL_FIELD]

	manifest_close: STRING

	manifest_open: STRING

feature {NONE} -- Implementation

	get_name: STRING
		do
			Result := output_path.base_name
			Result.to_upper
		end

	getter_function_table: like getter_functions
			--
		do
			create Result.make_one ("name", agent get_name)
		end

feature {NONE} -- Constants

	Template: STRING
		once
			Result := "[
				class
					$name

				feature {NONE} -- Implementation

				#across $field_list as $list loop
					signed_${list.item.name}_base_64: STRING
						-- Signed "$list.item.name" with X509 key serial number: $serial_number
						do
							Result := $manifest_open
							#across $list.item.data_lines as $line loop
								$line.item
							#end
							$manifest_close
						end

				#end
				end
			]"
		end
end