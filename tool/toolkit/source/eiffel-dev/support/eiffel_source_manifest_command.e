﻿note
	description: "Summary description for {EL_EIFFEL_SOURCE_MANIFEST_COMMAND}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-03-04 18:17:07 GMT (Friday 4th March 2016)"
	revision: "6"

deferred class
	EIFFEL_SOURCE_MANIFEST_COMMAND

inherit
	EL_COMMAND

	EL_MODULE_LOG

feature {EL_COMMAND_LINE_SUB_APPLICATION} -- Initialization

	make (source_manifest_path: EL_FILE_PATH)
		do
			create manifest.make_from_file (source_manifest_path)
		end

feature -- Basic operations

	execute
		local
			file_list: like manifest.file_list
		do
			if is_ordered then
				file_list := manifest.sorted_file_list
			else
				file_list := manifest.file_list
			end
			across file_list as file_path loop
				log_or_io.put_labeled_string ("Class", file_path.item.without_extension.base.as_upper); log_or_io.put_new_line
				process_file (file_path.item)
			end
		end

	process_file (source_path: EL_FILE_PATH)
		deferred
		end

feature -- Access

	manifest: EIFFEL_SOURCE_MANIFEST

feature -- Status query

	is_ordered: BOOLEAN
		do
		end

end
