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
	date: "2024-09-22 14:15:12 GMT (Sunday 22nd September 2024)"
	revision: "9"

class
	EL_PYXIS_FTP_CONFIGURATION

inherit
	EL_BUILDABLE_FROM_PYXIS

	EL_PLAIN_TEXT_LINE_STATE_MACHINE
		rename
			make as make_machine
		end

	EL_FILE_OPEN_ROUTINES

	EL_MODULE_TUPLE; EL_MODULE_STRING

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

	gather_quoted_strings (line: ZSTRING)
		-- gather the 3 quoted strings for nodes: `encrypted_url', `salt' and `digest'
		do
			if attached shared_floating (line) as floating then
				if floating.count = 0 or floating.starts_with_character ('#') then
				-- Ignore comments and empty lines
					do_nothing

				elseif floating.starts_with_character ('"') and then floating.ends_with_character ('"') then
					pyxis_lines.extend (line)
					quoted_string_count := quoted_string_count + 1
					if quoted_string_count = 3 then
						state := final
					end

				elseif floating.ends_with_character (':') then
					pyxis_lines.extend (line)
				end
			end
		end

	find_encrypted_url (line: ZSTRING)
		local
			last_line: ZSTRING
		do
			if attached shared_floating (line) as floating then
				if floating.count = 0 or floating.starts_with_character ('#') then
				-- Ignore comments and empty lines
					do_nothing

				elseif floating.ends_with_character (':') then
					if floating.same_string (Pyxis_node.encrypted_url) then
						encrypted_url_found := True
						last_line := pyxis_lines [last_node_index]
						ftp_node_name := last_line.substring_to (':')
						ftp_node_name.left_adjust

						if attached pyxis_lines as list then
							from list.go_i_th (4) until list.item = last_line loop
								list.remove
							end
						end
						pyxis_lines.extend (line)
						state := agent gather_quoted_strings
					else
						pyxis_lines.extend (line)
						if pyxis_lines.count = 3 then
							pyxis_lines.finish
							pyxis_lines.replace (Pyxis_node.configuration)
						end
						last_node_index := pyxis_lines.count
					end
				else
					pyxis_lines.extend (line)
				end
			end
		ensure
			valid_indent: encrypted_url_found implies pyxis_lines.last.leading_occurrences ('%T') = 2
		end

feature {NONE} -- Build from Pyxis

	building_action_table: EL_PROCEDURE_TABLE [STRING]
		do
			create Result.make_assignments (<<
				[ftp_node_name, 	agent do set_next_context (ftp) end]
			>>)
		end

feature {NONE} -- Internal attributes

	ftp_node_name: STRING

	pyxis_lines: EL_ZSTRING_LIST

	quoted_string_count: INTEGER

	last_node_index: INTEGER

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