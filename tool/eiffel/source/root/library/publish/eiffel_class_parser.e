note
	description: "Eiffel class parser"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-04-03 11:20:13 GMT (Friday 3rd April 2020)"
	revision: "1"

class
	EIFFEL_CLASS_PARSER

inherit
	ANY

	EL_MODULE_LOG_MANAGER

create
	make

feature {NONE} -- Initialization

	make (a_repository: REPOSITORY_PUBLISHER)
		do
			repository := a_repository
--			if Log_manager.is_logging_active then
--				create {EL_LOGGED_PROCEDURE_DISTRIBUTER [like Current]} distributer.make (publisher.thread_count)
--			end
			create distributer.make (a_repository.thread_count)
			create result_list.make (100)
		end

feature -- Basic operations

	queue (ecf: EIFFEL_CONFIGURATION_FILE; directory: SOURCE_DIRECTORY; source_path: EL_FILE_PATH)
		do
			distributer.wait_apply (agent new_class (ecf, directory, source_path))
		end

	update (final: BOOLEAN)
		local
			e_class: EIFFEL_CLASS
		do
			if final then
				distributer.do_final
				distributer.collect_final (result_list)
			else
				distributer.collect (result_list)
			end
			across result_list as l_result loop
				e_class := l_result.item.e_class
				l_result.item.directory.class_list.extend (e_class)
				if not attached {LIBRARY_CLASS} e_class then
					repository.example_classes.extend (e_class)
				end
			end
			result_list.wipe_out
		end

feature {NONE} -- Separate

	new_class (ecf: EIFFEL_CONFIGURATION_FILE; directory: SOURCE_DIRECTORY; source_path: EL_FILE_PATH): like result_list.item
		-- create new class and bind to directory in separate thread
		local
			e_class: EIFFEL_CLASS
		do
			if ecf.is_library then
				create {LIBRARY_CLASS} e_class.make (source_path, ecf, repository)
			else
				create e_class.make (source_path, ecf, repository)
			end
			Result := [directory, e_class]
		end

feature {NONE} -- Internal attributes

	repository: REPOSITORY_PUBLISHER

	example_classes: LIST [EIFFEL_CLASS]

	distributer: EL_FUNCTION_DISTRIBUTER [like new_class]

	result_list: ARRAYED_LIST [TUPLE [directory: SOURCE_DIRECTORY; e_class: EIFFEL_CLASS]]

end
