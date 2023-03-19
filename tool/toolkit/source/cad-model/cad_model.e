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
	date: "2023-03-19 10:33:41 GMT (Sunday 19th March 2023)"
	revision: "16"

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
			vertices: like new_vertice_list; polygons: like new_polygon_list
			json_list: JSON_NAME_VALUE_LIST
		do
			create json_list.make (json)
			json_list.find_field ("p")
			if json_list.found then
				vertices := new_vertice_list (json_list.item_2d_double_array)
				json_list.find_field ("q")
				if json_list.found then
					polygons := new_polygon_list (json_list.item_2d_integer_array, vertices.area)
				else
					create polygons.make (0)
				end
			else
				create polygons.make (0)
				create vertices.make (0)
			end
			make (polygons)
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

	new_polygon_list (index_array: ARRAY2 [INTEGER]; coordinate_array: SPECIAL [SPECIAL [DOUBLE]]): like polygon_list
		local
			row, i: INTEGER; index_list: ARRAYED_LIST [INTEGER]
		do
			create index_list.make_filled (4)
			create Result.make (index_array.height)
			from row := 1 until row > index_array.height loop
				i := (row - 1) * index_array.width
				index_list.area.copy_data (index_array.area, i, 0, index_array.width)
				Result.extend (create {CAD_POLYGON}.make (index_list, coordinate_array))
				row := row + 1
			end
		end

	new_vertice_list (array: ARRAY2 [DOUBLE]): ARRAYED_LIST [SPECIAL [DOUBLE]]
		local
			row, i: INTEGER; coords_item: SPECIAL [DOUBLE]
		do
			create Result.make (array.height)
			from row := 1 until row > array.height loop
				create coords_item.make_empty (array.width)
				i := (row - 1) * array.width
				coords_item.copy_data (array.area, i, 0, array.width)
				Result.extend (coords_item)
				row := row + 1
			end
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