#!/bin/bash

docker stop factura
docker rm factura
docker run -d \
	--name factura \
	-e CIVI_API_URL="https://ulr.tld/wp-content/plugins/civicrm/civicrm/extern/rest.php" \
	-e CIVI_SITE_KEY="secret" \
	-e CIVI_API_KEY="secret" \
	-e SMTP_SERVER_ADDRESS="mail.url.tld" \
	-e SMTP_SERVER_PORT="587" \
	-e SMTP_USERNAME="mail@url.tld" \
	-e SMTP_PASSWORD="secret" \
	-e PAYLINK_BASE="https://url.tld" \
	-e PAYLINK_SECRET="secret" \
	factura \
	$1

