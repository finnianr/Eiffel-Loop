note
	description: "Summary description for {EL_EIFFEL_SOURCE_MANIFEST_COMMAND}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	EIFFEL_SOURCE_MANIFEST_COMMAND

inherit
	EL_COMMAND

	EL_MODULE_LOG

feature {EL_COMMAND_LINE_SUB_APPLICATTION} -- Initialization

	make (source_manifest_path: EL_FILE_PATH)
		do
			create manifest.make_from_file (source_manifest_path)
		end

feature -- Basic operations

	execute
		do
			across manifest.file_list as file_path loop
				log_or_io.put_path_field ("Class", file_path.item); log_or_io.put_new_line
				process_file (file_path.item)
			end
		end

	process_file (source_path: EL_FILE_PATH)
		deferred
		end

feature -- Access

	manifest: EIFFEL_SOURCE_MANIFEST

end
