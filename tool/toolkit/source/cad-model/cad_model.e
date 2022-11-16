note
	description: "CAD model for wave energy machine"
	notes: "[
		**JSON Assumptions**
		
		This model makes a number of assumptions about the JSON data in order to use the highly efficient
		[$source EL_SPLIT_STRING_8_LIST] class. (avoids creating a new string for each split)
		
		1. The data is all on one line
		2. the arrays are delimited with `"], ["'
		3. the `p' and `q' sections are delimited with `[[' and `]]'
		
		This method is significantly faster than using a full JSON parser. (by at least an order of magnitude)
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:04 GMT (Tuesday 15th November 2022)"
	revision: "13"

class
	CAD_MODEL

inherit
	ANY

	EL_MODULE_FILE

	EL_MODULE_TUPLE

create
	make_from_file, make_from_json, make, make_partial

feature {NONE} -- Initialization

	make (a_polygon_list: like polygon_list)
		do
			polygon_list := a_polygon_list
		end

	make_from_file (json_path: FILE_PATH)
		do
			make_from_json (File.plain_text (json_path))
		end

	make_from_json (json: STRING)

		local
			parts: like new_json_parts
			vertices: like new_vertice_list
		do
			parts := new_json_parts (json)
			vertices := new_vertice_list (parts.p)
			make (new_polygon_list (parts.q, vertices.area))
		end

	make_partial (other: like Current; included: PREDICATE [CAD_POLYGON]; new_part: FUNCTION [CAD_POLYGON, CAD_POLYGON])
		do
			make (other.polygon_list.query_if (included))
			across other.polygon_list.query_if (agent {CAD_POLYGON}.is_wet_and_dry) as polygon loop
				polygon_list.extend (new_part (polygon.item))
			end
		end

feature -- Access

	dry_part: like Current
		-- part of model that is above water
		do
			create Result.make_partial (Current, agent {CAD_POLYGON}.is_dry, agent {CAD_POLYGON}.dry_part)
		end

	polygon_list: EL_ARRAYED_LIST [CAD_POLYGON]
		-- polygons

	wet_part: like Current
		-- part of model that is below water
		do
			create Result.make_partial (Current, agent {CAD_POLYGON}.is_wet, agent {CAD_POLYGON}.wet_part)
		end

	as_json (keep_ref: BOOLEAN): STRING
		local
			vertice_index: like new_vertice_index_table
			buffer: EL_STRING_8_BUFFER_ROUTINES
		do
			vertice_index := new_vertice_index_table
			Result := buffer.empty
--			{
			Result.append_character ('{')
--				"q":
				Result.append (Field.quads); Result.append_character (' ')
				Result.append (Double_brackets.left)
--					[[
					across polygon_list as polygon loop
						if not polygon.is_first then
--							], [
							Result.append (Tuple_delimiter)
						end
						across polygon.item as coord loop
							if not coord.is_first then
--								,
								Result.append (Comma_space)
							end
							Result.append_integer (vertice_index [coord.item])
						end
					end
					Result.append (Double_brackets.right)
--					]]
				Result.append (Comma_space)
--				"p":
				Result.append (Field.points); Result.append_character (' ')
--					[[
					Result.append (Double_brackets.left)
					across vertice_index.current_keys as coord loop
						if not coord.is_first then
--							], [
							Result.append (Tuple_delimiter)
						end
						coord.item.append_to_string (Result)
					end
					Result.append (Double_brackets.right)
--					]]
			Result.append_character ('}')
--			}
			if keep_ref then
				Result := Result.twin
			end
		ensure
			reversible: is_approximately_equal (create {like Current}.make_from_json (Result), 0.1e-14)
		end

feature -- Basic operations

	store_as (file_path: FILE_PATH)
		local
			output: PLAIN_TEXT_FILE
		do
			create output.make_open_write (file_path)
			output.put_string (as_json (False))
			output.close
		end

	print_to (lio: EL_LOGGABLE)
		do
			across polygon_list as polygon loop
				lio.put_integer_field ("Polygon", polygon.cursor_index)
				lio.put_character (' ')
				polygon.item.print_to (lio)
				lio.put_new_line
			end
		end

feature -- Comparison

   is_approximately_equal (other: like Current; precision: DOUBLE): BOOLEAN
   	do
   		if polygon_list.count = other.polygon_list.count then
   			Result := across polygon_list as polygon all
   				polygon.item.is_approximately_equal (other.polygon_list [polygon.cursor_index], precision)
  				end
   		end
   	end

feature {NONE} -- Factory

	new_json_parts (json: STRING): TUPLE [q, p: STRING]
		-- split json into q and p stripping double brackets: [[ ]]
		require
			all_on_one_line: not json.has ('%N')
		local
			index, start_index: INTEGER
		do
			Result := ["", ""]
			index := 1
			across << Field.quads, Field.points >> as marker loop
				index := json.substring_index (marker.item, index)
				if index > 0 then
					index := json.substring_index (Double_brackets.left, index)
					if index > 0 then
						start_index := index + 2
						index := json.substring_index (Double_brackets.right, start_index)
						if index > 0 then
							Result.put_reference (json.substring (start_index, index - 1), marker.cursor_index)
						end
					end
				end
			end
		end

	new_polygon_list (json: STRING; coordinate_array: SPECIAL [SPECIAL [DOUBLE]]): like polygon_list
		local
			tuple_list, index_split_string: EL_SPLIT_STRING_8_LIST
			index_list: ARRAYED_LIST [INTEGER]
		do
			create tuple_list.make_by_string (json, Tuple_delimiter)
			create index_split_string.make_empty
			create index_list.make (4)
			create Result.make (tuple_list.count)
			from tuple_list.start until tuple_list.after loop
				index_split_string.set_target (tuple_list.item_copy, ',', {EL_STRING_ADJUST}.Left)
				index_list.wipe_out
				from index_split_string.start until index_split_string.after loop
					index_list.extend (index_split_string.integer_item)
					index_split_string.forth
				end
				Result.extend (create {CAD_POLYGON}.make (index_list, coordinate_array))
				tuple_list.forth
			end
		ensure
			consistent_with_left_bracket_count: json.occurrences ('[') + 1 = Result.count
			consistent_with_right_bracket_count: json.occurrences (']') + 1 = Result.count
		end

	new_vertice_list (json: STRING): ARRAYED_LIST [SPECIAL [DOUBLE]]
		local
			tuple_list, double_list: EL_SPLIT_STRING_8_LIST
			coordinate: SPECIAL [DOUBLE]
		do
			create tuple_list.make_adjusted_by_string (json, Tuple_delimiter, {EL_STRING_ADJUST}.Left)
			create double_list.make_empty
			create Result.make (tuple_list.count)
			from tuple_list.start until tuple_list.after loop
				double_list.set_target (tuple_list.item_copy, ',', 0)
				from double_list.start until double_list.after loop
					if double_list.index = 1 then
						create coordinate.make_empty (3)
					end
					if coordinate.count <= 3 then
						coordinate.extend (double_list.double_item)
					end
					double_list.forth
				end
				Result.extend (coordinate)
				tuple_list.forth
			end
		ensure
			consistent_with_left_bracket_count: json.occurrences ('[') + 1 = Result.count
			consistent_with_right_bracket_count: json.occurrences (']') + 1 = Result.count
		end

	new_vertice_index_table: HASH_TABLE [INTEGER, COORDINATE_VECTOR]
		do
			create Result.make (polygon_list.count * 4)
			across polygon_list as polygon loop
				across polygon.item as coord loop
					Result.put (Result.count, coord.item)
				end
			end
		end

feature -- Constants

	Comma_space: STRING = ", "

	Double_brackets: TUPLE [left, right: STRING]
		once
			Result := ["[[", "]]"]
		end

	Field: TUPLE [quads, points: STRING]
		once
			create Result
			-- Note: this is the Eiffel way of writing an unescaped string manifest,
			-- similar to Pythons triple quote """ markers.
			Tuple.fill (Result, "[
				"q":, "p":
			]")
		end

	Tuple_delimiter: STRING = "], ["

end