note
	description: "Dj event publisher config"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 17:36:19 GMT (Saturday 19th May 2018)"
	revision: "3"

class
	DJ_EVENT_PUBLISHER_CONFIG

inherit
	EL_EIF_OBJ_BUILDER_CONTEXT
		redefine
			building_action_table
		end

	EL_MODULE_DIRECTORY

	EL_STRING_CONSTANTS

create
	make

feature {NONE} -- Initialization

	make
		do
			make_default
			www_dir := Directory.home.joined_dir_path ("www")
			html_template := Empty_string
			html_index_template := Empty_string
			ftp_url := Empty_string
			ftp_user_home := Empty_string
			ftp_destination_dir := Empty_string
			upload := True
		end

feature -- Access

	www_dir: EL_DIR_PATH

	html_template: ZSTRING

	html_index_template: ZSTRING

	ftp_url: ZSTRING

	ftp_user_home: ZSTRING

	ftp_destination_dir: ZSTRING

feature -- Status query

	upload: BOOLEAN

feature {NONE} -- Build from XML

	building_action_table: EL_PROCEDURE_TABLE
		do
			create Result.make (<<
				["@www_dir", 							agent do www_dir := node.to_expanded_dir_path end],
				["@html_template", 					agent do html_template := node.to_string end],
				["@html_index_template",			agent do html_index_template := node.to_string end],
				["@upload",								agent do upload := node.to_boolean end],
				["ftp/@url",							agent do ftp_url := node.to_string end],
				["ftp/@user_home",					agent do ftp_user_home := node.to_string end],
				["ftp/@destination_dir",			agent do ftp_destination_dir := node.to_string end]
			>>)
		end
end
