note
	description: "Summary description for {EL_SERVLET_CONFIG}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-09-02 10:55:12 GMT (Tuesday 2nd September 2014)"
	revision: "5"

class
	EL_SERVLET_CONFIG

inherit
	GOA_SERVLET_CONFIG
		rename
			document_root as document_root_utf8
		end

	EL_BUILDABLE_FROM_PYXIS
		redefine
			make_default, make_from_file, building_action_table
		end

	EL_MODULE_LOG

	EL_MODULE_ARGS

create
	make_default, make_from_file

feature {NONE} -- Initialization

	make_default
			--
		do
			create document_root_dir
			create document_root_utf8.make_empty
			create error_messages.make_empty
			server_port := Default_port
			phrase := new_pass_phrase
			Precursor
		end

	make_from_file (a_file_path: EL_FILE_PATH)
		do
			if a_file_path.exists then
				Precursor (a_file_path)
			else
				error_messages.extend ("Invalid path: ")
				error_messages.last.append (a_file_path.to_string)
			end
		end

feature -- Access

	document_root_dir: EL_DIR_PATH

	error_messages: EL_ASTRING_LIST

	phrase: like new_pass_phrase

feature -- Status query

	is_valid: BOOLEAN
		do
			Result := error_messages.is_empty
		end

feature {NONE} -- Build from XML

	building_action_table: like Type_building_actions
			--
		do
			create Result.make (<<
				["@port", agent do server_port := node.to_integer end],
				["document-root/text()", agent do set_document_root_dir (node.to_string) end],
				["phrase", agent do set_next_context (phrase) end]
			>>)
		end

	Root_node_name: STRING = "config"

feature {NONE} -- Implementation

	set_document_root_dir (a_document_root_dir: like document_root_dir)
		do
			document_root_dir := a_document_root_dir
			document_root_utf8 := document_root_dir.to_string.to_utf8
		end

	new_pass_phrase: EL_BUILDABLE_PASS_PHRASE
		do
			create Result.make_default
		end

feature {NONE} -- Constants

	Default_port: INTEGER = 8000

end
