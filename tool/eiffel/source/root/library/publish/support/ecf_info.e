note
	description: "ECF project information"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-12-19 16:49:13 GMT (Wednesday 19th December 2018)"
	revision: "4"

class
	ECF_INFO

create
	make

feature {NONE} -- Initialization

	make (a_path: EL_FILE_PATH)
			--
		do
			path := a_path
		end

feature -- Access

	cluster_xpath: STRING
		do
			Result := Xpath_cluster
		end

	description: ZSTRING
		do
			create Result.make_empty
		end

	description_xpath: STRING
		do
			Result := Xpath_description
		end

	path: EL_FILE_PATH

feature {NONE} -- Constants

	Xpath_cluster: STRING = "/system/target/cluster"

	Xpath_description: STRING = "/system/description"

end
