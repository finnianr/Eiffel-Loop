note
	description: "Experiment to see how Debian package info can be modeled in Eiffel"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-05-17 16:46:25 GMT (Friday 17th May 2019)"
	revision: "1"

class
	LIBSELINUX1

feature -- Access

	version: DEBIAN_VERSION
		once
			Result := "2.2.2-1ubuntu0.1"
		end

end
