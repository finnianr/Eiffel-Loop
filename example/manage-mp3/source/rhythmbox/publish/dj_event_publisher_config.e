note
	description: "Summary description for {DJ_EVENT_PUBLISHER_CONFIG}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

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

	html_template: ASTRING

	html_index_template: ASTRING

	ftp_url: ASTRING

	ftp_user_home: ASTRING

	ftp_destination_dir: ASTRING

feature -- Status query

	upload: BOOLEAN

feature {NONE} -- Build from XML

	building_action_table: like Type_building_actions
		do
			create Result.make (<<
				["@www_dir", 							agent do www_dir := node.to_string end],
				["@html_template", 					agent do html_template := node.to_string end],
				["@html_index_template",			agent do html_index_template := node.to_string end],
				["@upload",								agent do upload := node.to_boolean end],
				["ftp/@url",							agent do ftp_url := node.to_string end],
				["ftp/@user_home",					agent do ftp_user_home := node.to_string end],
				["ftp/@destination_dir",			agent do ftp_destination_dir := node.to_string end]
			>>)
		end
end
