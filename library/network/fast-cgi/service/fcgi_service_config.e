note
	description: "Servlet service configuration parsed from Pyxis format"
	notes: "[
		A minimal configuration looks like this:
		
			pyxis-doc:
				version = 1.0; encoding = "UTF-8"

			config:
				port = 8001

				document-root:
					"/home/john/www"
					
		It can easily be extended to include other information.
		
		The attribute `server_socket_path' is for future use with Unix sockets.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-07-09 12:49:59 GMT (Friday 9th July 2021)"
	revision: "10"

class
	FCGI_SERVICE_CONFIG

inherit
	EL_BUILDABLE_FROM_PYXIS
		redefine
			make_default, make_from_file, building_action_table
		end

	FCGI_SOCKET_FACTORY

create
	make, make_default, make_from_file

feature {NONE} -- Initialization

	make (a_server_socket_path: like server_socket_path; a_server_port: like server_port)
		-- make with either a UNIX socket path or a TCP port
		do
			make_default
			server_socket_path := a_server_socket_path; server_port := a_server_port
		end

	make_default
			--
		do
			create document_root_dir
			create error_messages.make_empty
			create server_socket_path
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
		ensure then
			valid_socket_parameter: server_port = 0 implies (not server_socket_path.is_empty)
		end

feature -- Access

	document_root_dir: EL_DIR_PATH

	error_messages: EL_ZSTRING_LIST

	server_port: INTEGER
		-- Port server is listening on

	server_socket_path: EL_FILE_PATH
		-- Unix socket path to listen on

feature -- Element change

	check_validity
		do
			if not unix_socket_exists then
				error_messages.extend ("Invalid socket path: " + server_socket_path.to_string)
			end
		end

feature -- Status query

	is_valid: BOOLEAN
		do
			Result := error_messages.is_empty
		end

	unix_socket_exists: BOOLEAN
		do
			Result := not server_socket_path.is_empty implies server_socket_path.parent.exists
		end

feature {NONE} -- Build from XML

	Root_node_name: STRING = "config"

	building_action_table: EL_PROCEDURE_TABLE [STRING]
			--
		do
			create Result.make (<<
				["@port", agent do server_port := node end],
				["@socket_path", agent do server_socket_path := node.to_expanded_file_path end],
				["document-root/text()", agent do set_document_root_dir (node.to_expanded_dir_path) end]
			>>)
		end

feature {NONE} -- Implementation

	set_document_root_dir (a_document_root_dir: EL_DIR_PATH)
		do
			document_root_dir := a_document_root_dir
		end

end