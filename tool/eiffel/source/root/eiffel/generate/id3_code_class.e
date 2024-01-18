note
	description: "Id3 code class"
	notes: "[
		**Note on 21 July 2023**
		
		It looks perhaps as though this class was never used as there were missing lines of code.
		The target class ${TL_FRAME_ID_ENUM} was likely created manually instead.
		Missing code completed on above date with update of code for ${EVOLICITY_TUPLE_CONTEXT}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-12-22 12:03:41 GMT (Friday 22nd December 2023)"
	revision: "7"

class
	ID3_CODE_CLASS

inherit
	EVOLICITY_SERIALIZEABLE

	EL_STRING_8_CONSTANTS

create
	make

feature {NONE} -- Initialization

	make (a_generator: ID3_FRAME_CODE_CLASS_GENERATOR; a_version: INTEGER; output_dir: DIR_PATH)
		local
			l_file_path: FILE_PATH; s: EL_STRING_8_ROUTINES
		do
			version := a_version
			l_file_path := output_dir + class_name.as_lower
			l_file_path.add_extension ("e")
			create field_list.make (a_generator.field_table.count)
			across a_generator.field_table as table loop
				if attached s.joined_list_with (table.item, Empty_string_8) as code then
					field_list.extend (new_context (code, table.key))
				end
			end
			make_from_file (l_file_path)
		end

feature -- Implementation

	class_name: STRING
		do
			Result := "TL_FRAME_CODES_2_" + version.out
		end

	new_context (code, description: STRING): EVOLICITY_TUPLE_CONTEXT
		do
			create Result.make ([code, description], once "code, description")
		end

feature {NONE} -- Evolicity reflection

	getter_function_table: like getter_functions
			--
		do
			create Result.make (<<
				["class_name",			agent class_name],
				["field_list",	agent: like field_list do Result := field_list end]
			>>)
		end

feature {NONE} -- Internal attributes

	field_list: ARRAYED_LIST [like new_context]

	version: INTEGER

feature {NONE} -- Constants

	Template: STRING = "[
		class
			$class_name
		
		feature -- Access
		
		#across $field_list as $list loop
			$field.item.code: NATURAL_8
				-- $list.item.description
		#end
	]"

end