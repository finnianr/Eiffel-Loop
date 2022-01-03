note
	description: "Id3 code class"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-01-03 15:52:09 GMT (Monday 3rd January 2022)"
	revision: "2"

class
	ID3_CODE_CLASS

inherit
	EVOLICITY_SERIALIZEABLE

create
	make

feature {NONE} -- Initialization

	make (a_generator: ID3_FRAME_CODE_CLASS_GENERATOR; version: INTEGER; output_dir: DIR_PATH)
		local
			l_file_path: FILE_PATH
		do
			name := Class_name_root + version.out
			l_file_path := output_dir + name.as_lower
			l_file_path.add_extension ("e")
			create field_table.make (a_generator.field_table.count)
			across field_table as field loop
			end
			make_from_file (l_file_path)
		end

feature {NONE} -- Evolicity reflection

	getter_function_table: like getter_functions
			--
		do
			create Result.make (<<
				["name", agent: ZSTRING do Result :=  name end],
				["field_table", agent: like field_table do Result := field_table end ]
			>>)
		end

feature {NONE} -- Internal attributes

	name: ZSTRING

	field_table: HASH_TABLE [EVOLICITY_TUPLE_CONTEXT, STRING]

feature {NONE} -- Constants

	Class_name_root: ZSTRING
		once
			Result := "TL_FRAME_CODES_2_"
		end

	Template: STRING = "[
		class
			$name
		
		feature -- Access
		
		#across $field_table as $field loop
			$field.key = "$field.item.code"
			#across $field.item.description as $line loop
				-- $line.item
			#end
			
		#end
	]"

	Tuple_fields: STRING = "code, description"
end

