#!/usr/bin/env bash

[[ $DF_DEBUG ]] && echo -e "\033[1;32mFunction Loaded:\033[39m $(basename ${BASH_SOURCE[0]})"

magento-event-ls() {
    grep -r Mage::dispatchEvent "$(pwd)/*"
}

magento-mysqldump() {
    mysqldump --ignore-table="${1}.log_customer" --ignore-table="${1}.log_quote" --ignore-table="${1}.log_summary" –-ignore-table="${1}.log_summary_type" –-ignore-table="${1}.log_url" --ignore-table="${1}.log_url_info" --ignore-table="${1}.log_visitor" --ignore-table="${1}.log_visitor_info" --ignore-table="${1}.log_visitor_online" –-ignore-table="${1}.log_summary" –-ignore-table="${1}.enterprise_logging_event" –-ignore-table="${1}.enterprise_logging_event_changes"
}
