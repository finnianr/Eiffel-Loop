note
	description: "Module batik svg"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-11-12 18:17:55 GMT (Monday 12th November 2018)"
	revision: "6"

class
	EL_MODULE_BATIK_SVG

inherit
	EL_MODULE_JAVA_PACKAGES

	EL_MODULE_DIRECTORY

feature {NONE} -- Initialization

	open_batik_package (error_action: PROCEDURE [STRING])
		do
			if Java_packages.is_java_installed then
				Java_packages.append_jar_locations (<< Directory.Application_installation.joined_dir_path ("batik-1.7") >>)
				Java_packages.append_class_locations (<< Directory.Application_installation >>)
				Java_packages.open (<< "batik-rasterizer" >>)
				if Java_packages.is_open then
					is_java_prepared.set_item (True)
				else
					error_action.call (["Java package: %"batik-rasterizer%" not found"])
				end
			else
				error_action.call (["A Java runtime must be installed to run this application"])
			end
		end

feature -- Clean up

	close_batik_package
		do
			if Java_packages.is_open then
				Java_packages.close
			end
		end

feature {NONE} -- Constants

	Batik_svg: EL_BATIK_SVG
		require
			java_prepared: is_java_prepared.item
		once
			create Result
		end

feature {NONE} -- Status query

	is_java_prepared: BOOLEAN_REF
		once
			create Result
		end

end
