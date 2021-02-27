note
	description: "Multi-core distributed class parser"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-02-27 18:15:46 GMT (Saturday 27th February 2021)"
	revision: "4"

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

	make (a_repository: like repository)
		do
			make_distributer (a_repository.thread_count)
			repository := a_repository
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
				Class_source_table.put_class (e_class)

				l_result.item.directory.class_list.extend (e_class)
				if e_class.is_example then
					repository.example_classes.extend (e_class)
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

	repository: REPOSITORY_PUBLISHER

	result_list: ARRAYED_LIST [like Result_type]

end