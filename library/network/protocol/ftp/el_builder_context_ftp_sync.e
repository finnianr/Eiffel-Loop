note
	description: "FTP file synchronization initializeable from XML/Pyxis builder"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-01-18 12:36:19 GMT (Friday 18th January 2019)"
	revision: "2"

class
	EL_BUILDER_CONTEXT_FTP_SYNC

inherit
	EL_FTP_SYNC
		rename
			make as make_ftp_sync,
			make_default as make
		redefine
			make
		end

	EL_EIF_OBJ_BUILDER_CONTEXT
		rename
			make_default as make
		redefine
			make
		end

create
	make

feature {NONE} -- Initialization

	make
			--
		do
			Precursor {EL_FTP_SYNC}
			Precursor {EL_EIF_OBJ_BUILDER_CONTEXT}
		end

feature {NONE} -- Build from XML

	building_action_table: EL_PROCEDURE_TABLE [STRING]
		do
			create Result.make (<<
				["@url", 		agent do ftp.make_write (create {FTP_URL}.make (node.to_string_8)) end],
				["@user-home", agent do ftp.set_home_directory (node.to_string) end],
				["@sync-path", agent do sync_table.set_from_file (node.to_expanded_file_path) end]
			>>)
		end

end
