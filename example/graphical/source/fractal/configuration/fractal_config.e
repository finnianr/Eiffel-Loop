note
	description: "Fractal config"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-06-05 14:48:38 GMT (Wednesday 5th June 2019)"
	revision: "3"

class
	FRACTAL_CONFIG

inherit
	EL_BUILDABLE_FROM_PYXIS
		rename
			make_default as make
		redefine
			make
		end

	EL_ORIENTATION_ROUTINES

	EL_MODEL_MATH

create
	make

feature {NONE} -- Initialization

	make
		do
			create background_image_path
			create parameter_list.make (10)
			create root.make_default
			fading := [40, 100]
			Precursor
		end

feature -- Access

	background_image_path: EL_FILE_PATH

	border_percent: INTEGER

	fading: TUPLE [minimum, maximum: INTEGER]

	root_layer: FRACTAL_LAYER_LIST
		do
			create Result.make (root.new_model)
		end

feature -- Basic operations

	append_to_layer (a_parent: REPLICATED_IMAGE_MODEL; layer: LIST [REPLICATED_IMAGE_MODEL])
		do
			across parameter_list as parameter loop
				layer.extend (parameter.item.new_satellite (a_parent))
			end
		end

feature {NONE} -- Build from nodes

	append_satellite
		do
			parameter_list.extend (create {SATELLITE_PARAMETERS}.make_default)
			set_next_context (parameter_list.last)
		end

	building_action_table: EL_PROCEDURE_TABLE [STRING]
		do
			create Result.make (<<
				["@background_image_path",	agent do background_image_path := node.to_expanded_file_path end],
				["@border_percent",			agent do border_percent := node.to_integer end],
				["fading/@minimum",			agent do fading.minimum := node.to_integer end],
				["fading/@maximum",			agent do fading.maximum := node.to_integer end],
				["root",							agent do set_next_context (root) end],
				["satellite",					agent append_satellite]
			>>)
		end

feature {NONE} -- Internal attributes

	parameter_list: ARRAYED_LIST [SATELLITE_PARAMETERS]

	root: ROOT_PARAMETERS

feature {NONE} -- Constants

	Root_node_name: STRING = "fractal"

end
