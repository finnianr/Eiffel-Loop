note
	description: "Write class library manifest from source manifest file"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-10-06 11:45:17 GMT (Monday 6th October 2014)"
	revision: "5"

class
	EIFFEL_CLASS_LIBRARY_MANIFEST_COMMAND

inherit
	EIFFEL_SOURCE_MANIFEST_COMMAND
		rename
			make as make_command,
			process_file as add_eiffel_source
		redefine
			execute, is_ordered
		end

	EVOLICITY_SERIALIZEABLE

create
	make, default_create

feature {EL_TESTABLE_COMMAND_LINE_SUB_APPLICATTION} -- Initialization

	make (source_manifest_path, a_output_path: EL_FILE_PATH; a_title: ASTRING; a_source_root_path: like source_root_path)
		do
			make_command (source_manifest_path); make_from_file (a_output_path)
			title := a_title; source_root_path := a_source_root_path
			create library_manifest.make
			create cluster_path
			create cluster_file_list.make (20)
		end

feature -- Basic operations

	execute
			--
		do
			Precursor
			add_eiffel_source (source_root_path + "last")
			serialize_to_file (output_path)
		end

feature -- Status query

	is_ordered: BOOLEAN
		do
			Result := True
		end

feature {NONE} -- Implementation

	add_eiffel_source (source_path: EL_FILE_PATH)
		do
			if source_path.parent /~ cluster_path then
				if not cluster_file_list.is_empty then
					library_manifest.cluster_list.extend (
						create {CLUSTER}.make (cluster_path.relative_path (source_root_path), cluster_file_list)
					)
				end
				cluster_file_list.wipe_out
				cluster_path := source_path.parent
			end
			cluster_file_list.extend (source_path)
		end

	title: ASTRING

	source_root_path: EL_DIR_PATH

	cluster_path: EL_DIR_PATH

	cluster_file_list: ARRAYED_LIST [EL_FILE_PATH]

	library_manifest: CLASS_LIBRARY_MANIFEST

feature {NONE} -- Evolicity fields

	getter_function_table: like getter_functions
			--
		do
			create Result.make (<<
				["class_manifest", agent: CLASS_LIBRARY_MANIFEST do Result := library_manifest end],
				["title",			 agent: ASTRING do Result := title end]
			>>)
		end

	Template: STRING =
		-- Substitution template
		-- The #evaluate routine is not indented because it contains the html preformat tag <pre>
		-- which will not align properly otherwise.
	"[
		<?xml version="1.0" encoding="UTF-8"?>
		<html xmlns="http://www.w3.org/1999/xhtml" lang="en">
			<head>
				<title>$title</title>
				<style type="text/css">
					body { text-align: center; }
					div#container {
						margin-left: auto;
						margin-right: auto;
						width: 70em;
						text-align: left;
					}
					p {margin-left: 2em;}
				</style>
			</head>
			<body>
			<div id="container">
			<h1>$title</h1>
		#evaluate ({CLASS_LIBRARY_MANIFEST}.template, $class_manifest)
			</div>
			</body>
		</html>
	]"

end
