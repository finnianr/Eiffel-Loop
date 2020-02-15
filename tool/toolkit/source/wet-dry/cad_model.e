note
	description: "CAD model for wave energy machine"
	notes: "[
		**JSON Assumptions**
		
		This model makes a number of assumptions about the JSON data in order to use the highly efficient
		[$source EL_SPLIT_STRING_8_LIST] class. (avoids creating a new string for each split)
		
		1. The data is all on one line
		2. the arrays are delimited with "], ["
		3. the `p' and `q' sections are delimited with `[[` and `]]'
		
		This method is significantly faster than using a full JSON parser. (by at least an order of magnitude)
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-02-15 20:01:54 GMT (Saturday 15th February 2020)"
	revision: "1"

class
	CAD_MODEL

inherit
	ANY

	EL_MODULE_FILE_SYSTEM

	EL_MODULE_LIO

	EL_MODULE_TUPLE

create
	make_from_file, make_from_json, make

feature {NONE} -- Initialization

	make_from_file (a_json_path: EL_FILE_PATH)
		local
			json: STRING; index, start_index: INTEGER
			json_parts: ARRAY [STRING]
		do
			json := File_system.plain_text (a_json_path)
			check
				all_on_one_line: not json.has ('%N')
			end
			create json_parts.make_filled ("", 1, 2)
			index := 1
			across << Field.quads, Field.points >> as marker loop
				index := json.substring_index (marker.item, index)
				if index > 0 then
					index := json.substring_index (Double_brackets.left, index)
					if index > 0 then
						start_index := index + 2
						index := json.substring_index (Double_brackets.right, start_index)
						if index > 0 then
							json_parts [marker.cursor_index] := json.substring (start_index, index - 1)
						end
					end
				end
			end
			make_from_json (json_parts [1], json_parts [2])
			json_path.share (a_json_path)
		end

	make_from_json (quadrilaterals_json, points_json: STRING)
		local
			vertices: like new_vertice_list
		do
			vertices := new_vertice_list (points_json)
			make (vertices, new_polygon_list (quadrilaterals_json, vertices.area))
		end

	make (a_vertice_list: like vertice_list; a_polygon_list: like polygon_list)
		do
			create json_path
			vertice_list := a_vertice_list; polygon_list := a_polygon_list
		end

feature -- Access

	polygon_list: EL_ARRAYED_LIST [POLYGON]
		-- polygons

	vertice_list: like new_vertice_list
		-- vertice points

	json_path: EL_FILE_PATH

	dry_part: like Current
		-- part of model that is above water
		do
			create Result.make (vertice_list, polygon_list.query_if (agent {POLYGON}.is_dry))
			across polygon_list.query_if (agent {POLYGON}.is_wet_and_dry) as wet_and_dry loop
				Result.polygon_list.extend (wet_and_dry.item.dry_part)
			end
		end

	wet_part: like Current
		-- part of model that is below water
		do
			create Result.make (vertice_list, polygon_list.query_if (agent {POLYGON}.is_dry))
			across polygon_list.query_if (agent {POLYGON}.is_wet_and_dry) as wet_and_dry loop
				Result.polygon_list.extend (wet_and_dry.item.wet_part)
			end
		end

feature {NONE} -- Factory

	new_polygon_list (json: STRING; coordinate_array: SPECIAL [SPECIAL [DOUBLE]]): like polygon_list
		local
			tuple_list, index_split_string: EL_SPLIT_STRING_8_LIST
			index_list: ARRAYED_LIST [INTEGER]
		do
			create tuple_list.make (json, once "], [")
			create index_split_string.make_empty
			create index_list.make (4)
			index_split_string.enable_left_adjust
			create Result.make (tuple_list.count)
			from tuple_list.start until tuple_list.after loop
				index_split_string.set_string (tuple_list.item (False), once ",")
				index_list.wipe_out
				from index_split_string.start until index_split_string.after loop
					index_list.extend (index_split_string.integer_item)
					index_split_string.forth
				end
				Result.extend (create {POLYGON}.make (index_list, coordinate_array))
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
			create tuple_list.make (json, once "], [")
			create double_list.make_empty
			double_list.enable_left_adjust
			create Result.make (tuple_list.count)
			from tuple_list.start until tuple_list.after loop
				double_list.set_string (tuple_list.item (False), once ",")
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

feature -- Constants

	Double_brackets: TUPLE [left, right: STRING]
		once
			Result := ["[[", "]]"]
		end

	Field: TUPLE [quads, points: STRING]
		once
			create Result
			Tuple.fill (Result, "[
				"q":, "p":
			]")
		end

end
