note
	description: "FTP configuration"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-03-27 11:30:56 GMT (Saturday 27th March 2021)"
	revision: "3"

class
	EL_FTP_CONFIGURATION

inherit
	FTP_URL
		rename
			make as make_url
		end

	EL_EIF_OBJ_BUILDER_CONTEXT
		rename
			make_default as make_context,
			on_context_exit as analyze
		export
			{NONE} all
		undefine
			analyze, is_equal
		end

	EL_FTP_CONSTANTS

create
	make, make_default, make_from_tuple

convert
	make_from_tuple ({TUPLE [STRING, EL_DIR_PATH]})

feature {NONE} -- Initialization

	make_from_tuple (args: TUPLE [address: STRING; user_home_dir: EL_DIR_PATH])
		do
			make (args.address, args.user_home_dir)
		end

	make (a_address: STRING; a_user_home_dir: EL_DIR_PATH)
		do
			make_url (a_address)
			user_home_dir := a_user_home_dir
			make_context
		end

	make_default
		do
			make (Default_url, "/")
		end

feature -- Access

	user_home_dir: EL_DIR_PATH

	url: STRING
		do
			Result := address
		end

feature -- Element change

	set_user_home_dir (a_user_home_dir: EL_DIR_PATH)
		require
			is_absolute: a_user_home_dir.is_absolute
		do
			user_home_dir := a_user_home_dir
		end

feature {NONE} -- Build from XML

	building_action_table: EL_PROCEDURE_TABLE [STRING]
		do
			create Result.make (<<
				["@url", 		agent do address := node.to_string_8 end],
				["@user-home", agent do user_home_dir.set_path (node.to_string) end],
				["@user", 		agent do username := node.to_string_8 end]
			>>)
		end
end