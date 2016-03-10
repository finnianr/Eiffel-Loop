note
	description: "${description}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-06-28 17:09:01 GMT (Friday 28th June 2013)"
	revision: "2"

class
	EL_XML_ELEMENT_LIST_EDITIONS [STORABLE_TYPE -> EL_STORABLE_XML_ELEMENT create make end]

inherit
	EL_MODULE_STRING

create
	make

feature {NONE} -- Initialization

	make (a_target_list: like target_list; a_file_path: EL_FILE_PATH)
			--
		do
			create crc
			create storage_file_path.make_from_string (File.swap_extension (a_file_path, "editions.xml"))

			if File.exists (storage_file_path) then
				set_editions_text
			else
				create editions_text.make_empty
			end

			creation_actions := creation_action_table
			target_list := a_target_list
		end

feature -- Access

	file_size_kb: REAL
		do
			Result := (storage_file.count / 1024).truncated_to_real
		end

	replace_or_extend_count: INTEGER

feature -- Element change

	put_replacement (element: STORABLE_TYPE; a_index: INTEGER)
			--
		do
			store_edition (create {like Type_replacement_edition}.make (element, a_index))
		end

	put_extension (element: STORABLE_TYPE)
			--
		do
			store_edition (create {like Type_extension_edition}.make (element))
		end

	put_removal (a_index: INTEGER)
			--
		do
			store_edition (create {like Type_removal_edition}.make (a_index))
		end

	put_blank
		do
			storage_file.put_character (' ')
		end

	set_storage_file_path (a_storage_file_path: like storage_file_path)
		do
			storage_file_path := a_storage_file_path
			storage_file.change_name (storage_file_path.string)
		end

feature -- Basic operations

	apply
			-- Apply list-editions to target list
		local
			root_node: EL_XPATH_ROOT_NODE_CONTEXT
			edition_node_list: EL_XPATH_NODE_CONTEXT_LIST
			edition_node: EL_XPATH_NODE_CONTEXT
			template: EL_SUBSTITUTION_TEMPLATE
		do
			if not editions_text.is_empty then
				create template.make (XML_template)
				template.set_string ("EDITIONS_LIST", editions_text)

				create root_node.make_from_string (template.substituted)

				edition_node_list := root_node.context_list ("/list-editions/*")
				from edition_node_list.start until edition_node_list.after loop
					edition_node := edition_node_list.context
					edition_node.find_node ("*")
					apply_edition (creation_actions.item (edition_node.name).item ([edition_node]))
					edition_node_list.forth
				end
				create storage_file.make_open_append (storage_file_path)
			else
				create storage_file.make_open_write (storage_file_path)
			end
			create editions_text.make_empty
		end

	reset
			--
		do
			storage_file.close; reopen
		end

	close_and_delete
			--
		do
			storage_file.close; storage_file.delete
		end

	close
			--
		do
			storage_file.close
		end

	reopen
			--
		do
			storage_file.open_write
		end

feature -- Status query

	is_empty: BOOLEAN
			--
		do
			Result := storage_file.is_empty
		end

feature {NONE} -- Implementation

	set_editions_text
			-- Set editions text ommitting any possibley corrupted editions
		local
			editions_file: PLAIN_TEXT_FILE
			line, edition: STRING
			corruption_found: BOOLEAN
			editions_checksum_node: EL_XPATH_ROOT_NODE_CONTEXT
		do
			create editions_file.make_open_read (storage_file_path)
			create edition.make_empty
			create editions_text.make (editions_file.count)
			from until corruption_found or editions_file.after loop
				editions_file.read_line
				line := editions_file.last_string
				if line.starts_with (Editions_checksum_beginning) then
					edition.remove_tail (1) -- remove carriage return
					crc.add_string (edition)
					create editions_checksum_node.make_from_string (line)
					if crc.checksum /= editions_checksum_node.attributes.natural ("value") then
						corruption_found := True
					else
						editions_text.append (edition)
						edition.wipe_out
					end
				else
					if line.substring_index (Tag_replace, 1) = 2 or else line.substring_index (Tag_extend, 1) = 2 then
						replace_or_extend_count := replace_or_extend_count + 1
					end
					edition.append (line); edition.append_character ('%N')
				end
			end
			editions_file.close
		end

	is_opening_tag (tag_name, text: STRING): BOOLEAN
		do
			if text.starts_with (once "<") and then text.substring_index (tag_name, 2) = 2 then
				Result := True
			end
		end

	is_closing_tag (tag_name, text: STRING): BOOLEAN
		do
			if text.starts_with (once "</") and then text.substring_index (tag_name, 3) = 3 then
				Result := True
			end
		end

	apply_edition (edition: like Type_edition)
			--
		do
			edition.apply (target_list)
		end

	store_edition (edition: like Type_edition)
			--
		local
			xml: STRING

		do
			xml := edition.to_xml
			xml.prune_all ('%U') -- Needed because of bug in manifest strings
			storage_file.put_string (xml); storage_file.put_new_line
			crc.add_string (xml)
			storage_file.put_string (String.template (Editions_checksum_template).substituted (<< crc.checksum >>))
			storage_file.put_new_line
			storage_file.flush
		end

	extension_edition (edition_node: EL_XPATH_NODE_CONTEXT): like Type_extension_edition
			--
		do
			create Result.make (create {STORABLE_TYPE}.make)
			prepare_element (Result.element)
			Result.element.set_from_xpath_node (edition_node.found_node)
		end

	replacement_edition (edition_node: EL_XPATH_NODE_CONTEXT): like Type_replacement_edition
			--
		do
			create Result.make (create {STORABLE_TYPE}.make, edition_node.attributes.integer ("index"))
			prepare_element (Result.element)
			Result.element.set_from_xpath_node (edition_node.found_node)
		end

	removal_edition (edition_node: EL_XPATH_NODE_CONTEXT): like Type_removal_edition
			--
		do
			create Result.make (edition_node.attributes.integer ("index"))
		end

	prepare_element (element: STORABLE_TYPE)
			-- prepare element for setting by xpath node
		do
		end

	creation_action_table: EL_HASH_TABLE [
		FUNCTION [EL_XML_ELEMENT_LIST_EDITIONS [STORABLE_TYPE], TUPLE [EL_XPATH_NODE_CONTEXT], like Type_edition],
		STRING
	]
			--
		do
			create Result.make (<<
				[Tag_extend, agent extension_edition],
				[Tag_remove, agent removal_edition],
				[Tag_replace, agent replacement_edition]
			>>)
			Result.compare_objects
		end

feature {NONE} -- Implementation: attributes

	storage_file_path: EL_FILE_PATH

	storage_file: PLAIN_TEXT_FILE

	creation_actions: like creation_action_table

	target_list: LIST [STORABLE_TYPE]

	editions_text: STRING

	crc: EL_CYCLIC_REDUNDANCY_CHECK_32

feature {NONE} -- Type definitions

	Type_edition: EL_XML_ELEMENT_EDITION [STORABLE_TYPE]

	Type_extension_edition: EL_EXTENSION_EDITION [STORABLE_TYPE]

	Type_replacement_edition: EL_REPLACEMENT_EDITION [STORABLE_TYPE]

	Type_removal_edition: EL_REMOVAL_EDITION [STORABLE_TYPE]

feature {NONE} -- Constants

	XML_template: STRING =
		--

	"[
		<?xml version="1.0" encoding="iso-8859-1"?>
		<list-editions>
		$EDITIONS_LIST
		</list-editions>
	]"

	Editions_checksum_template: STRING = "<editions-checksum value=%"$S%"/>"

	Editions_checksum_beginning: STRING
		once
			Result := Editions_checksum_template.substring (1, Editions_checksum_template.index_of ('=', 1))
		end

	Tag_remove: STRING
		once
			Result := (create {like Type_removal_edition}).tag_name
		end

	Tag_replace: STRING
		once
			Result := (create {like Type_replacement_edition}).tag_name
		end

	Tag_extend: STRING
		once
			Result := (create {like Type_extension_edition}).tag_name
		end

end
