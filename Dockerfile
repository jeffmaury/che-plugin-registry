#
# Copyright (c) 2018-2019 Red Hat, Inc.
# This program and the accompanying materials are made
# available under the terms of the Eclipse Public License 2.0
# which is available at https://www.eclipse.org/legal/epl-2.0/
#
# SPDX-License-Identifier: EPL-2.0
#
FROM mikefarah/yq as builder
RUN apk add --no-cache bash
COPY .htaccess README.md /build/
COPY /plugins /build/plugins
COPY check_plugins_location.sh check_plugins_images.sh check_plugins_viewer_mandatory_fields.sh index.sh set_plugin_dates.sh /build/
RUN cd /build/ && ./check_plugins_location.sh && ./check_plugins_images.sh && ./set_plugin_dates.sh && ./check_plugins_viewer_mandatory_fields.sh && ./index.sh > /build/plugins/index.json
COPY .htaccess README.md /build/

FROM registry.centos.org/centos/httpd-24-centos7
RUN mkdir /var/www/html/plugins
COPY --from=builder /build/ /var/www/html/
USER 0
RUN chmod -R g+rwX /var/www/html/plugins
