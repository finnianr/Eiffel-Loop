note
	description: "[
		Parses text for type name links of the form `${type-name}' and creates a map
		list, mapping the compact interval of the occurrence to following metadata:
		
		1. path to ISE or configured library
		2. flag indicating if it is an ISE class
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-21 10:44:10 GMT (Sunday 21st January 2024)"
	revision: "2"

class
	CLASS_REFERENCE_MAP_LIST

inherit
	EL_ARRAYED_MAP_LIST [INTEGER_64, TUPLE [path: detachable FILE_PATH; is_ise_path: BOOLEAN]]
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

feature -- Measurement

	adjusted_count (line: ZSTRING): INTEGER
		-- `line.count' adjusted to exclude "${}" characters for valid class substitutions
		local
			start_index, end_index, type_start_index, type_end_index, index_bracket, type_name_count: INTEGER
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
						Result := Result - Class_marker_count
					end
					list.forth
				end
			end
		end

feature -- Status query

	has_invalid_class: BOOLEAN

feature -- Iteration item status

	item_has_path: BOOLEAN
		do
			Result := attached item_value.path
		end

feature -- Iteration item

	item_class_name: ZSTRING
		local
			bracket_index: INTEGER
		do
			Result := item_type_name
			bracket_index := Result.index_of ('[', 1)
			if bracket_index > 0 then
				-- remove class parameter
				Result.keep_head (bracket_index - 1)
				Result.right_adjust
			end
		end

	item_end_index: INTEGER
		local
			ir: EL_INTERVAL_ROUTINES
		do
			Result := ir.to_upper (item_key)
		end

	item_start_index: INTEGER
		local
			ir: EL_INTERVAL_ROUTINES
		do
			Result := ir.to_lower (item_key)
		end

	item_type_name: ZSTRING
		do
			Result := code_text.substring (item_start_index + 2, item_end_index - 1)
		end

feature -- Element change

	parse (a_code_text: ZSTRING)
		local
			start_index, end_index, type_start_index, type_end_index, index_bracket, type_name_count: INTEGER
			eif: EL_EIFFEL_SOURCE_ROUTINES; class_name: ZSTRING; occurrence_interval: INTEGER_64
			ir: EL_INTERVAL_ROUTINES
		do
			code_text := a_code_text
			wipe_out
			has_invalid_class := False
			dollor_intervals.wipe_out
			dollor_intervals.fill_by_string (a_code_text, Dollor_left_brace, 0)

			if attached dollor_intervals as list then
				from list.start until list.after loop
					type_start_index := list.item_upper + 1
					start_index := list.item_lower
					end_index := a_code_text.index_of ('}', type_start_index)
					if end_index > 0 then
						type_end_index := end_index - 1
						type_name_count := type_end_index - type_start_index + 1
					else
						type_name_count := 0
					end
					if type_name_count <= Maximum_type_length then
						if attached buffer.copied_substring (a_code_text, type_start_index, type_end_index) as type_name
							and then eif.is_type_name (type_name)
						then
							occurrence_interval := ir.compact (start_index, end_index)
							index_bracket := type_name.index_of ('[', 1)
							if index_bracket > 0 then
								type_name.keep_head (index_bracket - 1)
								type_name.right_adjust
							end
							if Class_path_table.has_class (type_name) then
								extend (occurrence_interval, [Class_path_table.found_item, False])

							elseif ISE_class_table.has_class (type_name) then
								extend (occurrence_interval, [ISE_class_table.found_item, True])
							else
								has_invalid_class := True
								extend (occurrence_interval, [Void, False])
							end
						end
					end
					list.forth
				end
			end
		end

feature {NONE} -- Internal attributes

	buffer: EL_ZSTRING_BUFFER

	code_text: ZSTRING

	dollor_intervals: EL_OCCURRENCE_INTERVALS

feature {NONE} -- Constants

	Class_marker_count: INTEGER = 3
		-- same as: `("${}").count'

	Maximum_type_length: INTEGER = 80

end