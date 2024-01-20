note
	description: "[
		Initialize `ftp: ${EL_FTP_CONFIGURATION}' instance from any Pyxis file with
		named elements **encrypted_url** etc as shown in notes below.
	]"
	notes: "[
		**Configuration Example**
		
		Note that the **ftp-site** element name can be anything.
		
			pyxis-doc:
				version = 1.0; encoding = "UTF-8"
			publish-repository:
				ftp-site:
					encrypted_url:
						"HVQPk8fnB04fXvnHdSsvfGjfu0FMt2N1QWbjiSDK+a4QI2aB4XY3QEUC3tfn6wMhiVZrUz4rP59JmXjfdIbktQ=="
					credential:
						salt:
							"QmOh7tMBAGEyOrOBgMU9BJoJJ1R/dr67"
						digest:
							"66i62a1zmjfTUvaSSFUFSL7teSuOejiJlAa+4lEmIj0="

	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:26 GMT (Saturday 20th January 2024)"
	revision: "5"

class
	EL_PYXIS_FTP_CONFIGURATION

inherit
	EL_BUILDABLE_FROM_PYXIS

	EL_PLAIN_TEXT_LINE_STATE_MACHINE
		rename
			make as make_machine
		end

	EL_FILE_OPEN_ROUTINES

	EL_MODULE_TUPLE

create
	make

feature {NONE} -- Initialization

	make (file_path: FILE_PATH)
		do
			make_machine
			create ftp.make_default
			create pyxis_lines.make (20)
			if attached open_lines (file_path, Utf_8) as config_lines then
				do_with_lines (agent find_encrypted_url, config_lines)
			end
			make_from_string (pyxis_lines.joined_lines.to_utf_8)
		ensure
			encrypted_url_found: encrypted_url_found
		end

feature -- Access

	ftp: EL_FTP_CONFIGURATION

feature -- Status query

	encrypted_url_found: BOOLEAN
		-- `True' if element node "encrypted_url" was found

feature {NONE} -- Implementation

	find_digest (line: ZSTRING)
		do
			pyxis_lines.extend (line)
			if line.ends_with (Pyxis_node.digest) then
				state := agent find_digest_value
			end
		end

	find_digest_value (line: ZSTRING)
		do
			pyxis_lines.extend (line)
			if line.occurrences ('"') = 2 then
				state := final
			end
		end

	find_encrypted_url (line: ZSTRING)
		local
			last_line: ZSTRING
		do
			if line_number = 1 then
				pyxis_lines.extend (line)
				pyxis_lines.extend (Pyxis_node.configuration)

			elseif line.ends_with (Pyxis_node.encrypted_url) then
				encrypted_url_found := True
				if attached pyxis_lines as list then
					last_line := list.last
					ftp_element_name := last_line.substring_to (':')
					ftp_element_name.left_adjust

					from list.go_i_th (3) until list.item = last_line loop
						list.remove
					end
				end
				pyxis_lines.extend (line)
				state := agent find_digest

			elseif line.ends_with_character (':') then
				pyxis_lines.extend (line)
			end
		ensure
			valid_indent: encrypted_url_found implies pyxis_lines.last.leading_occurrences ('%T') = 2
		end

feature {NONE} -- Build from Pyxis

	building_action_table: EL_PROCEDURE_TABLE [STRING]
		do
			create Result.make (<<
				[ftp_element_name, 	agent do set_next_context (ftp) end]
			>>)
		end

feature {NONE} -- Internal attributes

	ftp_element_name: STRING

	pyxis_lines: EL_ZSTRING_LIST

feature {NONE} -- Constants

	Pyxis_node: TUPLE [configuration, digest, encrypted_url: ZSTRING]
		once
			create Result
			Tuple.fill (Result, "configuration:, digest:, encrypted_url:")
		end

	Root_node_name: STRING
		once
			Result := Pyxis_node.configuration
			Result.remove_tail (1)
		end

end