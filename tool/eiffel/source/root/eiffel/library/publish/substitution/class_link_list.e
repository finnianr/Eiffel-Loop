note
	description: "List of HTML links to Eiffel class documentation pages"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-03-27 13:21:19 GMT (Wednesday 27th March 2024)"
	revision: "4"

class
	CLASS_LINK_LIST

inherit
	EL_ARRAYED_LIST [CLASS_LINK]
		redefine
			make
		end

	PUBLISHER_CONSTANTS

	SHARED_CLASS_PATH_TABLE; SHARED_ISE_CLASS_TABLE

	EL_ZSTRING_CONSTANTS

create
	make

feature {NONE} -- Initialization

	make (n: INTEGER)
		do
			Precursor (n)
			create dollor_intervals.make_sized (n)
		end

feature -- Status query

	has_invalid_class: BOOLEAN
		-- `True' if at least one item entry has class_category = Unknown_class

feature -- Measurement

	adjusted_count (line: ZSTRING): INTEGER
		-- `line.count' adjusted to exclude "${}" characters for valid class substitutions
		do
			Result := line.count
			if attached dollor_intervals as list and then attached Bracketed_type as type then
				list.wipe_out
				list.fill_by_string (line, Dollor_left_brace, 0)
				from list.start until list.after loop
					set_bracketed_type (type, line, list)
					if type.is_valid then
						Result := Result - Class_marker_count -- subtract "${}" characters
					end
					list.forth
				end
			end
		end

feature -- Element change

	parse (code_text: ZSTRING)
		do
			wipe_out
			has_invalid_class := False
			dollor_intervals.wipe_out
			dollor_intervals.fill_by_string (code_text, Dollor_left_brace, 0)

			if attached dollor_intervals as list and then attached Bracketed_type as type then
				from list.start until list.after loop
					set_bracketed_type (type, code_text, list)
					if type.is_valid then
						extend (new_link (code_text, type.name, type.start_index, type.end_index))
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

feature {NONE} -- Implementation

	new_link (code_text, name: ZSTRING; start_index, end_index: INTEGER): CLASS_LINK
		do
			if Class_path_table.has_class (name) then
				create {DEVELOPER_CLASS_LINK} Result.make (
					Class_path_table.found_item, code_text, start_index, end_index
				)
			elseif ISE_class_table.has_class (name) then
				create {ISE_CLASS_LINK} Result.make (
					ISE_class_table.found_item, code_text, start_index, end_index
				)
			else
				has_invalid_class := True
				create Result.make (Invalid_class, code_text, start_index, end_index)
			end
		end

	set_bracketed_type (type: like Bracketed_type; code_text: ZSTRING; list: EL_OCCURRENCE_INTERVALS)
		local
			start_index, end_index, name_count, index_bracket: INTEGER; eif: EL_EIFFEL_SOURCE_ROUTINES
			type_name: ZSTRING
		do
			start_index := list.item_upper + 1
			type_name := type.name; type_name.wipe_out
			type.is_valid := False
			type.start_index := list.item_lower
			type.end_index := code_text.index_of ('}', start_index)

			if type.end_index > 0 then
				end_index := type.end_index - 1
				name_count := end_index - start_index + 1
			else
				name_count := 0
			end
			if 1 <= name_count and name_count <= Max_type_name_count then
				type_name.append_substring (code_text, start_index, end_index)
				if eif.is_type_name (type_name) then
					type.is_valid := True
					index_bracket := type_name.index_of ('[', 1)
					if index_bracket > 0 then
						type_name.keep_head (index_bracket - 1)
						type_name.right_adjust
					end
				end
			end
		end

feature {NONE} -- Internal attributes

	dollor_intervals: EL_OCCURRENCE_INTERVALS

feature {NONE} -- Constants

	Bracketed_type: TUPLE [name: ZSTRING; is_valid: BOOLEAN; start_index, end_index: INTEGER]
		once
			Result := [Empty_string.twin, False, 0, 0]
		end

	Class_marker_count: INTEGER = 3
		-- same as: `("${}").count'

	Invalid_class: FILE_PATH
		once
			Result := "invalid-class-name"
		end

	Max_type_name_count: INTEGER
		once
			Result := 80
		end

end