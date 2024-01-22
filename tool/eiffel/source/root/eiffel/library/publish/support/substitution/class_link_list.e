note
	description: "List of HTML links to Eiffel class documentation pages"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-22 10:21:33 GMT (Monday 22nd January 2024)"
	revision: "1"

class
	CLASS_LINK_LIST

inherit
	EL_ARRAYED_LIST [CLASS_LINK]
		redefine
			make
		end

	PUBLISHER_CONSTANTS

	SHARED_CLASS_PATH_TABLE; SHARED_ISE_CLASS_TABLE

create
	make

feature {NONE} -- Initialization

	make (n: INTEGER)
		do
			Precursor (n)
			create buffer
			create dollor_intervals.make_sized (n)
		end

feature -- Status query

	has_invalid_class: BOOLEAN
		-- `True' if at least one item entry has class_category = Unknown_class

feature -- Measurement

	adjusted_count (line: ZSTRING): INTEGER
		-- `line.count' adjusted to exclude "${}" characters for valid class substitutions
		local
			start_index, end_index, type_start_index, type_end_index, type_name_count: INTEGER
			eif: EL_EIFFEL_SOURCE_ROUTINES
		do
			Result := line.count
			if attached dollor_intervals as list then
				list.wipe_out
				list.fill_by_string (line, Dollor_left_brace, 0)
				from list.start until list.after loop
					type_start_index := list.item_upper + 1
					start_index := list.item_lower
					end_index := line.index_of ('}', type_start_index)
					if end_index > 0 then
						type_end_index := end_index - 1
						type_name_count := type_end_index - type_start_index + 1
					else
						type_name_count := 0
					end
					if type_name_count <= Maximum_type_length
						and then attached buffer.copied_substring (line, type_start_index, type_end_index) as type_name
						and then eif.is_type_name (type_name)
					then
						Result := Result - Class_marker_count -- subtract "${}" characters
					end
					list.forth
				end
			end
		end

feature -- Element change

	parse (code_text: ZSTRING)
		local
			start_index, end_index, type_start_index, type_end_index, index_bracket, type_name_count: INTEGER
			eif: EL_EIFFEL_SOURCE_ROUTINES; link: CLASS_LINK
		do
			wipe_out
			has_invalid_class := False
			dollor_intervals.wipe_out
			dollor_intervals.fill_by_string (code_text, Dollor_left_brace, 0)

			if attached dollor_intervals as list then
				from list.start until list.after loop
					type_start_index := list.item_upper + 1
					start_index := list.item_lower
					end_index := code_text.index_of ('}', type_start_index)
					if end_index > 0 then
						type_end_index := end_index - 1
						type_name_count := type_end_index - type_start_index + 1
					else
						type_name_count := 0
					end
					if type_name_count <= Maximum_type_length then
						if attached buffer.copied_substring (code_text, type_start_index, type_end_index) as type_name
							and then eif.is_type_name (type_name)
						then
							index_bracket := type_name.index_of ('[', 1)
							if index_bracket > 0 then
								type_name.keep_head (index_bracket - 1)
								type_name.right_adjust
							end
							if Class_path_table.has_class (type_name) then
								create {DEVELOPER_CLASS_LINK} link.make (
									Class_path_table.found_item, code_text, start_index, end_index
								)
							elseif ISE_class_table.has_class (type_name) then
								create {ISE_CLASS_LINK} link.make (
									ISE_class_table.found_item, code_text, start_index, end_index
								)
							else
								has_invalid_class := True
								create link.make (Invalid_class, code_text, start_index, end_index)
							end
							extend (link)
						end
					end
					list.forth
				end
			end
		end

feature -- Basic operations

	add_to_crc (crc: EL_CYCLIC_REDUNDANCY_CHECK_32)
		do
			from start until after loop
				if item.is_valid then
					crc.add_path (item.path)
				end
				forth
			end
		end

feature {NONE} -- Internal attributes

	buffer: EL_ZSTRING_BUFFER

	dollor_intervals: EL_OCCURRENCE_INTERVALS

feature {NONE} -- Constants

	Class_marker_count: INTEGER = 3
		-- same as: `("${}").count'

	Maximum_type_length: INTEGER = 80

	Invalid_class: FILE_PATH
		once
			Result := "invalid-class-name"
		end

end