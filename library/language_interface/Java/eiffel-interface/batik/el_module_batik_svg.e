note
	description: "Summary description for {EL_MODULE_SVG_TO_PNG_TRANSCODER}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2011-11-15 10:21:47 GMT (Tuesday 15th November 2011)"
	revision: "1"

class
	EL_MODULE_BATIK_SVG

inherit
	EL_MODULE_JAVA_PACKAGES

	EL_MODULE_EXECUTION_ENVIRONMENT

	EL_MODULE_PATH

feature {NONE} -- Initialization

	open_batik_package (error_action: PROCEDURE [ANY, TUPLE [STRING]])
		do
			if Java_packages.is_java_installed then
				Java_packages.append_jar_locations (<<
					Directory.joined_path (Execution_environment.Application_installation_dir, "batik-1.7")
				>>)
				Java_packages.append_class_locations (<< Execution_environment.Application_installation_dir >>)
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

feature -- Access

	batik_svg: EL_BATIK_SVG
		require
			java_prepared: is_java_prepared.item
		once
			create Result
		end

feature -- Status query

	is_java_prepared: BOOLEAN_REF
		once
			create Result
		end

feature {NONE} -- Implementation


end
