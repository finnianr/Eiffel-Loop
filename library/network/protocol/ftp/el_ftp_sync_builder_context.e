note
	description: "FTP file synchronization initializeable from XML/Pyxis builder"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-03-17 11:01:21 GMT (Wednesday 17th March 2021)"
	revision: "3"

class
	EL_FTP_SYNC_BUILDER_CONTEXT

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

	force_authentication
		do
			ftp.authenticator.password.share (node)
			ftp.authenticator.force_authenticated
		end

	building_action_table: EL_PROCEDURE_TABLE [STRING]
		do
			create Result.make (<<
				["@url", 		agent do ftp.make_write (create {FTP_URL}.make (node)) end],
				["@user-home", agent do ftp.set_home_directory (node.to_string) end],
				["@sync-path", agent do sync_table.set_from_file (node.to_expanded_file_path) end],
				["@user", 		agent do ftp.authenticator.username.share (node) end],
				["@password", 	agent force_authentication]
			>>)
		end

end