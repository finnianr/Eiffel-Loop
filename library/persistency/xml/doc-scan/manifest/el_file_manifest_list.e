note
	description: "A file manifest list"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-09-13 19:13:27 GMT (Friday 13th September 2024)"
	revision: "25"

class
	EL_FILE_MANIFEST_LIST

inherit
	EL_SORTABLE_ARRAYED_LIST [EL_FILE_MANIFEST_ITEM]
		rename
			make as make_list,
			make_empty as make_empty_list
		end

	EL_FILE_PERSISTENT_BUILDABLE_FROM_XML
		rename
			make_default as make_empty
		undefine
			is_equal, copy
		redefine
			make_empty
		end

	EL_FILE_OPEN_ROUTINES
		rename
			Append as Append_mode
		end

	EL_CHARACTER_32_CONSTANTS

	EL_SHARED_CYCLIC_REDUNDANCY_CHECK_32

create
	make_empty, make_from_template_and_output, make_from_file, make_from_string

feature {NONE} -- Initialization

	make_empty
		do
			make_empty_list
			compare_objects
			Precursor
		end

feature -- Access

	digest: NATURAL

	manifest_digest: NATURAL
		local
			l_found: BOOLEAN
		do
			if output_path.exists then
				if attached open_lines (output_path, Utf_8) as line_source then
					across line_source as lines until l_found loop
						if attached lines.shared_item as line and then line.has_substring (Digest_attribute) then
							Result := line.substring_between (Digest_attribute, char ('"'), 1).to_natural_32
							l_found := True
						end
					end
					line_source.close
				end
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
			summator: EL_CONTAINER_ARITHMETIC [EL_FILE_MANIFEST_ITEM, INTEGER]
		do
			create summator.make (Current)
			Result := summator.sum (agent {EL_FILE_MANIFEST_ITEM}.byte_count)
		end

feature -- Element change

	append_files (list: LIST [FILE_PATH])
		local
			crc: like crc_generator
		do
			crc := crc_generator
			crc.set_checksum (digest)
			list.do_all (agent crc.add_file)
			digest := crc.checksum
			grow (list.count + count)
			across list as path loop
				extend (create {EL_FILE_MANIFEST_ITEM}.make (path.item))
			end
		end

	set_digest (a_digest: like digest)
		do
			digest := a_digest
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
				[Var_current, agent: ITERABLE [EL_FILE_MANIFEST_ITEM] do Result := Current end]
			>>)
		end

feature {NONE} -- Build from XML

	building_action_table: EL_PROCEDURE_TABLE [STRING]
			-- Nodes relative to root element: smil
		do
			create Result.make (<<
				["file",	agent do set_collection_context (Current, create {EL_FILE_MANIFEST_ITEM}.make_default) end]
			>>)
		end

feature {NONE} -- Constants

	Digest_attribute: ZSTRING
		once
			Result := "digest=%""
		end

	Template: STRING = "[
		<?xml version = "1.0" encoding = "$encoding_name"?>
		<file-list digest="$digest">
		#foreach $file in $Current loop
			<file>
				<name>$file.name</name>
				<byte-count>$file.byte_count</byte-count>
				<modification-time>$file.modification_time</modification-time>
			</file>
		#end
		</file-list>
	]"

end