note
	description: "FTP file synchronization initializeable from XML/Pyxis builder"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

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

	building_action_table: EL_PROCEDURE_TABLE
		do
			create Result.make (<<
				["@url", 		agent do ftp.make_write (create {FTP_URL}.make (node.to_string_8)) end],
				["@user-home", agent do ftp.set_home_directory (node.to_string) end],
				["@sync-path", agent do sync_table.set_from_file (node.to_expanded_file_path) end]
			>>)
		end

end
