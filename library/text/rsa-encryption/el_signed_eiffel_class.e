note
	description: "Eiffel class with signed fields"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-07-22 13:00:56 GMT (Thursday 22nd July 2021)"
	revision: "1"

class
	EL_SIGNED_EIFFEL_CLASS

inherit
	EVOLICITY_REFLECTIVE_SERIALIZEABLE
		rename
			escaped_field as unescaped_field,
			export_name as export_default,
			field_included as is_any_field
		export
			{NONE} all
			{ANY} serialize
		redefine
			initialize_fields
		end

create
	make

feature {NONE} -- Initialization

	make (a_output_path: EL_FILE_PATH; a_serial_number: STRING)
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
			Result := output_path.base_sans_extension
			Result.to_upper
		end

	getter_function_table: like getter_functions
			--
		do
			create Result.make (<<
				["name", agent get_name]
			>>)
		end

feature {NONE} -- Constants

	Template: STRING = "[
		class
			$name
			
		feature {NONE} -- Implementation
		
		#across $field_list as $list loop
			signed_${list.item.name}_base64: STRING
				-- Signed "$list.item.name" for public key serial Number: $serial_number
				do
					Result := Base_64.joined ($manifest_open
					#across $list.item.base_64_lines as $line loop
						$line.item
					#end
					$manifest_close)
				end
		
		#end
		end
	]"
end