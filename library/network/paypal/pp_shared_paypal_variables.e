note
	description: "Summary description for {EL_SHARED_PAYPAL_VARIABLES}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-12 18:21:00 GMT (Thursday 12th October 2017)"
	revision: "2"

class
	PP_SHARED_PAYPAL_VARIABLES

feature {NONE} -- Constants

	Variable: TUPLE [
		acknowledge,
		button_code, button_country, button_language, button_status, button_sub_type, button_type,
		hosted_button_id, notify_url, version, website_code: ZSTRING
	]
		once
			create Result
			Result.acknowledge := "ACK"

			Result.button_code := "BUTTONCODE"
			Result.button_country := "BUTTONCOUNTRY"
			Result.button_language := "BUTTONLANGUAGE"
			Result.button_type := "BUTTONTYPE"
			Result.button_status := "BUTTONSTATUS"
			Result.button_sub_type := "BUTTONSUBTYPE"

			Result.hosted_button_id := "HOSTEDBUTTONID"
			Result.notify_url := "NOTIFYURL"
			Result.version := "VERSION"
			Result.website_code := "WEBSITECODE"
		end

end
