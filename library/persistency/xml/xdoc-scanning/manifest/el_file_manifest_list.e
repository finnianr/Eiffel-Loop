note
	description: "A file manifest list"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-01-08 18:37:47 GMT (Tuesday 8th January 2019)"
	revision: "2"

class
	EL_FILE_MANIFEST_LIST

inherit
	EL_SORTABLE_ARRAYED_LIST [EL_FILE_MANIFEST_ITEM]
		rename
			make as make_list
		end

	EL_FILE_PERSISTENT_BUILDABLE_FROM_XML
		undefine
			is_equal, copy
		redefine
			make_default
		end

	EL_MODULE_CRC_32
		undefine
			is_equal, copy
		end

	EL_ZSTRING_CONSTANTS
		undefine
			is_equal, copy
		end

create
	make_from_template_and_output, make_from_file, make_from_string

feature {NONE} -- Initialization

	make_default
		do
			make_list (0)
			compare_objects
			Precursor
		end

feature -- Access

	digest: NATURAL

	manifest_digest: NATURAL
		local
			lines: EL_FILE_LINE_SOURCE
			l_found: BOOLEAN
		do
			if output_path.exists then
				create lines.make (output_path)
				across lines as line until l_found loop
					if line.item.has_substring (Digest_attribute) then
						Result := line.item.substring_between (Digest_attribute, character_string ('"'), 1).to_natural_32
						l_found := True
					end
				end
				lines.close
			end
		end

	name_set: EL_HASH_SET [ZSTRING]
		do
			create Result.make_equal (count)
			across Current as file loop
				Result.put (file.item.name)
			end
		end

	total_byte_count: INTEGER
		local
			summator: EL_CHAIN_SUMMATOR [EL_FILE_MANIFEST_ITEM, INTEGER]
		do
			create summator
			Result := summator.sum (Current, agent {EL_FILE_MANIFEST_ITEM}.byte_count)
		end

feature -- Element change

	append_files (list: LIST [EL_FILE_PATH])
		local
			crc: like Crc_32.crc_generator
		do
			crc := Crc_32.crc_generator
			crc.set_checksum (digest)
			list.do_all (agent crc.add_file)
			digest := crc.checksum
			grow (list.count + count)
			across list as path loop
				extend (create {EL_FILE_MANIFEST_ITEM}.make (path.item))
			end
		end

feature -- Status query

	is_modified: BOOLEAN
		do
			Result := digest /= manifest_digest
		end

feature {NONE} -- Evolicity

	getter_function_table: like getter_functions
			--
		do
			create Result.make (<<
				["digest", agent: NATURAL_32_REF do Result := digest.to_reference end],
				["current", agent: ITERABLE [EL_FILE_MANIFEST_ITEM] do Result := Current end]
			>>)
		end

feature {NONE} -- Build from XML

	building_action_table: EL_PROCEDURE_TABLE
			-- Nodes relative to root element: smil
		do
			create Result.make (<<
				["file", agent extend_list]
			>>)
		end

	extend_list
			--
		do
			extend (create {EL_FILE_MANIFEST_ITEM}.make_default)
			set_next_context (last)
		end

feature {NONE} -- Constants

	Digest_attribute: ZSTRING
		once
			Result := "digest=%""
		end

	Root_node_name: STRING = "file-list"

	Template: STRING = "[
		<?xml version = "1.0" encoding = "$encoding_name"?>
		<file-list digest="$digest">
		#foreach $file in $current loop
			<file>
				<name>$file.name</name>
				<byte-count>$file.byte_count</byte-count>
				<modification-time>$file.modification_time</modification-time>
			</file>
		#end
		</file-list>
	]"

end
