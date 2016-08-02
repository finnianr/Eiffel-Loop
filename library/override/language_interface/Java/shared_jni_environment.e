note
	description: "Shared JNI environment"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "${date}"
	revision: "${revision}"

class
	SHARED_JNI_ENVIRONMENT

feature {NONE} -- Constants

	Jni: JNI_ENVIRONMENT
			-- Java object request broker
		once
			Result := jorb
		end

	Jorb: JNI_ENVIRONMENT
			-- Java object request broker
		once
			create Result
		end

end

