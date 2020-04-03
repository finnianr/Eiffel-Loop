note
	description: "Multi-core distributed class parser"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-04-03 18:29:49 GMT (Friday 3rd April 2020)"
	revision: "2"

class
	EIFFEL_CLASS_PARSER

inherit
	EL_FUNCTION_DISTRIBUTER [TUPLE [directory: SOURCE_DIRECTORY; e_class: EIFFEL_CLASS]]
		rename
			make as make_distributer
		export
			{NONE} all
		end

	EL_MODULE_LIO

	SHARED_HTML_CLASS_SOURCE_TABLE

	PUBLISHER_CONSTANTS

create
	make

feature {NONE} -- Initialization

	make (a_example_classes: like example_classes; thread_count: INTEGER)
		do
			make_distributer (thread_count)
			example_classes := a_example_classes
			create result_list.make (100)
		end

feature -- Basic operations

	queue (ecf: EIFFEL_CONFIGURATION_FILE; directory: SOURCE_DIRECTORY; source_path: EL_FILE_PATH)
		do
			wait_apply (agent new_class (ecf, directory, source_path))
		end

	update (final: BOOLEAN)
		local
			e_class: EIFFEL_CLASS
		do
			if final then
				do_final; collect_final (result_list)
			else
				collect (result_list)
			end
			across result_list as l_result loop
				e_class := l_result.item.e_class
				Class_source_table.put (e_class.relative_source_path.with_new_extension (Html), e_class.name)

				l_result.item.directory.class_list.extend (e_class)
				if e_class.is_example then
					example_classes.extend (e_class)
				end
			end
			result_list.wipe_out
		end

feature {NONE} -- Separate function

	new_class (ecf: EIFFEL_CONFIGURATION_FILE; directory: SOURCE_DIRECTORY; source_path: EL_FILE_PATH): like Result_type
		-- create new class and bind to directory in separate thread
		do
			Result := [directory, ecf.new_class (source_path)]
		end

feature {NONE} -- Internal attributes

	example_classes: LIST [EIFFEL_CLASS]

	result_list: ARRAYED_LIST [like Result_type]

end
