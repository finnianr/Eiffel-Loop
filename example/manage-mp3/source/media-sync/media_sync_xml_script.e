note
	description: "Summary description for {MEDIA_SYNC_XML_SCRIPT}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-11-01 13:40:03 GMT (Friday 1st November 2013)"
	revision: "3"

class
	MEDIA_SYNC_XML_SCRIPT

inherit
	EL_MODULE_LOG

	EL_MODULE_STRING

	EL_MODULE_FILE_SYSTEM

	EL_ID3_ENCODINGS

create
	make

feature {NONE} -- Initialization

	make (script_path: EL_FILE_PATH)
			--
		local
			source_path, destination_path: EL_DIR_PATH
		do
			log.enter_with_args ("make", << script_path >> )

			create command_actions
			create root_xp_ctx.make_from_file (script_path)
			create deletion_count_max
			create relocation_count_max
			create new_items_count_max

			across root_xp_ctx.context_list ("/media-sync/send") as send loop
				source_path := send.node.string_32_at_xpath ("from")
				source_path.enable_out_abbreviation
				destination_path := send.node.string_32_at_xpath ("to")

				if not (source_path.is_empty or destination_path.is_empty)
					and then send.node.attributes.has (Xml_field_Media_type)
					and then send.node.attributes.has (Xml_field_Sync_method)
				then
					add_source_and_destination_set (send.node, source_path, destination_path)

					add_command_actions (delete_items_not_in_source_set)
					add_command_actions (move_items_relocated_in_source)
					add_command_actions (copy_new_items_from_source)
				else
					log.put_line ("XML node: /media-sync/send")
					log.put_line ("%TMissing parameter: 'media_type' OR 'sync_method' OR 'from' OR 'to'")
					log.put_new_line
				end
			end
			deletion_count_max.set_item (deletion_count)
			relocation_count_max.set_item (relocation_count)
			new_items_count_max.set_item (new_items_count)
			log.exit
		end

feature -- Access

	command_actions: ACTION_SEQUENCE [TUPLE]

	new_items_count: INTEGER

feature {NONE} -- Implementation: routines

	add_source_and_destination_set (send_node: EL_XPATH_NODE_CONTEXT; source_path, destination_path: EL_DIR_PATH)
			--
		require
			send_node.attributes.has (Xml_field_Media_type) and send_node.attributes.has (Xml_field_Sync_method)
		local
			media_type, sync_method : STRING
		do
			log.enter_with_args ("add_source_and_destination_set", << source_path >>)
			media_type := send_node.attributes ["media_type"]
			sync_method := send_node.attributes ["sync_method"]

			destination_ID3_tag_character_encoding := Encoding_unknown
			if send_node.attributes.has (Xml_field_Id3_encoding) and then
				attached {STRING} send_node.attributes [Xml_field_Id3_encoding] as encoding_id

			then
				if encoding_id.as_lower ~ "latin1" then
					destination_ID3_tag_character_encoding := Encoding_ISO_8859_1

				elseif encoding_id.as_lower ~ "utf8" then
					destination_ID3_tag_character_encoding := Encoding_UTF_8

				elseif encoding_id.as_lower ~ "utf16" then
					destination_ID3_tag_character_encoding := Encoding_UTF_16

				elseif encoding_id.as_lower ~ "utf16be" then
					destination_ID3_tag_character_encoding := Encoding_UTF_16_BE

				end
			end

			device_ID3_version := Default_device_ID3_version
			if send_node.attributes.has (Xml_field_Id3_version) and then
				attached {REAL} send_node.attributes.real (Xml_field_Id3_version) as version and then
				Valid_ID3_versions.has (version)
			then
				device_ID3_version := version
			end

			if sync_method ~ "name_AND_size_AND_last_modified" then
				create {MEDIA_ITEM_SET [MEDIA_ITEM]} source_set.make (source_path, media_type)
				create {MEDIA_ITEM_SET [MEDIA_ITEM]} destination_set.make (destination_path, media_type)

			elseif sync_method ~ "ID3_unique_file_ID" then
				create {MEDIA_ITEM_SET [IDENTITY_TAGGED_MP3_MEDIA_ITEM]} source_set.make (source_path, media_type)
				create {MEDIA_ITEM_SET [SMALL_DEVICE_MP3_MEDIA_ITEM]} destination_set.make_with_filter (
					destination_path, media_type, agent is_hexadecimal_file_name
				)
			end
			log.exit
		end

	delete_items_not_in_source_set: ARRAYED_LIST [PROCEDURE [ANY, TUPLE]]
			--
		local
			deletion_list: LINKED_LIST [MEDIA_ITEM]
			delete_command: EL_DELETE_PATH_COMMAND
		do
			log.enter ("delete_items_not_in_source_set")
			create Result.make (20)
			create deletion_list.make

			log.put_new_line
			log.put_integer_field ("destination_set.count", destination_set.count)
			log.put_new_line

			from destination_set.start until destination_set.after loop
				if not source_set.has (destination_set.item.key) then
					deletion_list.extend (destination_set.item)
					create delete_command.make (destination_set.item.mp3_path)
					deletion_count := deletion_count + 1
					command_actions.extend (
						agent prefix_command_with_progress_info (
							delete_command, deletion_count, deletion_count_max
						)
					)
					log_or_io.put_string ("DELETE ")
					log_or_io.put_string (destination_set.item.mp3_path.to_string)
					log_or_io.put_new_line
				end
				destination_set.forth
			end
			deletion_list.do_all (agent destination_set.remove)
			log.put_new_line
			log.put_integer_field ("destination_set.count", destination_set.count)
			log.put_new_line

			log.exit
		end

	move_items_relocated_in_source: ARRAYED_LIST [PROCEDURE [ANY, TUPLE]]
			--
		local
			destination_rel_location, source_rel_location, destination_path: EL_DIR_PATH
			move_command: EL_MOVE_FILE_COMMAND
		do
			log.enter ("move_items_relocated_in_source")
			create Result.make (20)

			from destination_set.start until destination_set.after loop
				source_set.search (destination_set.item.key)

				if source_set.found then
					source_rel_location := source_set.found_item.relative_path.parent
					destination_rel_location := destination_set.item.relative_path.parent

					if source_rel_location /~ destination_rel_location then
						destination_path := destination_set.root_path.joined_dir_path (source_rel_location)
						create move_command.make (destination_set.item.mp3_path, destination_path)
						Result.extend (agent File_system.make_directory (destination_path))
						relocation_count := relocation_count + 1
						Result.extend (
							agent prefix_command_with_progress_info (
								move_command, relocation_count, relocation_count_max
							)
						)

						destination_set.item.mp3_path.enable_out_abbreviation
						log_or_io.put_string ("MOVE ")
						log_or_io.put_string (destination_set.item.mp3_path.out)
						log_or_io.put_string (" TO ")
						log_or_io.put_string (source_rel_location.to_string)
						log_or_io.put_new_line
					end
				end
				destination_set.forth
			end
			log.exit
		end

	copy_new_items_from_source: ARRAYED_LIST [PROCEDURE [ANY, TUPLE]]
			--
		local
			relative_destination_path: EL_DIR_PATH
			destination_path: EL_FILE_PATH
			unique_id_file_name_template: EL_SUBSTITUTION_TEMPLATE [EL_ASTRING]
			copy_command: COPY_UNIQUE_MP3_FILE_COMMAND
		do
			log.enter ("copy_new_items_from_source")
			create Result.make (20)

			from source_set.start until source_set.after loop
				destination_set.search (source_set.item.key)
				if not destination_set.found
					or else source_set.item.last_modified > destination_set.found_item.last_modified
				then
					relative_destination_path := source_set.item.relative_path.parent
					Result.extend (
						agent File_system.make_directory (destination_set.root_path.joined_dir_path (relative_destination_path))
					)
					if attached {UNIQUELY_IDENTIFIABLE_MEDIA_ITEM} source_set.item as mp3_item then
						create unique_id_file_name_template.make ("0x$HEX_VALUE.mp3")
						unique_id_file_name_template.set_variable ("HEX_VALUE", mp3_item.unique_id.to_hex_string)
						unique_id_file_name_template.substitute
						destination_path := destination_set.root_path + (relative_destination_path + unique_id_file_name_template.string)

						create copy_command.make (
							source_set.item.mp3_path, destination_path, device_id3_version, destination_ID3_tag_character_encoding
						)
						copy_command.set_file_destination

						new_items_count := new_items_count + 1
						Result.extend (
							agent prefix_command_with_progress_info (copy_command, new_items_count, new_items_count_max)
						)

						source_set.item.mp3_path.enable_out_abbreviation
						log_or_io.put_string ("COPY ")
						log_or_io.put_string (source_set.item.mp3_path.out)
						log_or_io.put_new_line
					end
				end
				source_set.forth
			end
			log.exit
		end

	add_command_actions (actions: ARRAYED_LIST [PROCEDURE [ANY, TUPLE]])
			--
		do
			actions.do_all (agent command_actions.extend)
		end

	prefix_command_with_progress_info (a_command: EL_OS_COMMAND [EL_COMMAND_IMPL]; count: INTEGER; max_count: INTEGER_REF)
			--
		do
			log.put_new_line
			log_or_io.put_character ('[')
			log_or_io.put_integer (count)
			log_or_io.put_string (" of ")
			log_or_io.put_integer (max_count.item)
			log_or_io.put_string ("] ")
			a_command.execute
		end

feature {NONE} -- Implementation

	is_hexadecimal_file_name (mp3_path: EL_PATH): BOOLEAN
			--
		do
			Result := String.is_hexadecimal (mp3_path.without_extension.base)
		end

feature {NONE} -- Implementation: attributes

	root_xp_ctx: EL_XPATH_ROOT_NODE_CONTEXT

	destination_set: MEDIA_ITEM_SET [MEDIA_ITEM]

	source_set: MEDIA_ITEM_SET [MEDIA_ITEM]

	deletion_count: INTEGER

	deletion_count_max: INTEGER_REF

	relocation_count: INTEGER

	relocation_count_max: INTEGER_REF

	new_items_count_max: INTEGER_REF

	device_ID3_version: REAL

	destination_ID3_tag_character_encoding: INTEGER

feature -- Constants

	Xml_field_Media_type: STRING = "media_type"

	Xml_field_Sync_method: STRING = "sync_method"

	Xml_field_Id3_encoding: STRING = "id3_encoding"

	Xml_field_Id3_version: STRING = "id3_version"

	Default_device_ID3_version: REAL = 2.4

end
