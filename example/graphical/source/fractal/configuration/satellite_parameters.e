note
	description: "Satellite parameters"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-08-21 16:26:24 GMT (Friday 21st August 2020)"
	revision: "7"

class
	SATELLITE_PARAMETERS

inherit
	EL_REFLECTIVE_EIF_OBJ_BUILDER_CONTEXT
		rename
			xml_names as export_default,
			element_node_type as	Attribute_node
		redefine
			make_default, building_action_table
		end

	EL_GEOMETRY_MATH
		undefine
			is_equal
		end

	EL_DIRECTION
		export
			{NONE} all
		undefine
			is_equal
		end

create
	make_default

feature {NONE} -- Initialization

	make_default
		do
			create transformation_list.make (0)
			Precursor
		end

feature -- Factory

	new_satellite (a_parent: REPLICATED_IMAGE_MODEL): REPLICATED_IMAGE_MODEL
		do
			create Result.make_satellite (a_parent, size_proportion, displaced_radius_proportion, radians (relative_angle))
			across transformation_list as transform loop
				transform.item (Result)
			end
		end

feature {NONE} -- Build from nodes

	add_mirror
		local
			l_axis: INTEGER
		do
			l_axis := X_axis
			if node.to_character_8.as_upper = Y_axis then
				l_axis := Y_axis
			end
			transformation_list.extend (agent {REPLICATED_IMAGE_MODEL}.mirror (l_axis))
		end

	add_rotation
		do
			transformation_list.extend (agent {REPLICATED_IMAGE_MODEL}.rotate (radians (node.to_integer)))
		end

	building_action_table: EL_PROCEDURE_TABLE [STRING]
		do
			Result := Precursor +
				["mirror/@axis",	agent add_mirror] +
				["rotate/@angle",	agent add_rotation]
		end

feature {NONE} -- Internal attributes

	displaced_radius_proportion: DOUBLE

	relative_angle: INTEGER

	size_proportion: DOUBLE

	transformation_list: ARRAYED_LIST [PROCEDURE [REPLICATED_IMAGE_MODEL]]

feature {NONE} -- Constants

	Axis_name: TUPLE [x, y: STRING]
		once
			Result := ["x", "y"]
		end

end
