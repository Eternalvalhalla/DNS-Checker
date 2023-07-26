#!/bin/bash

display_banner() {
    echo -e ""
    echo -e "           \e[91m\e[1m* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *\e[0m"
    echo -e "             \e[97m\e[3m          DNS Checker for DMARC and SPF Records\e[0m"
    echo -e "           \e[91m\e[1m* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *\e[0m"
}

display_banner

missing_spf_count=0
missing_dmarc_count=0
total_domains_checked=0

for ip in $(cat $1); do
    spf_result=$(nslookup -q=TXT $ip | grep -w "v=spf1")
    dmarc_result=$(nslookup -q=TXT _dmarc.$ip | grep -w "v=DMARC1")

    if [[ -z "$spf_result" ]]; then
        echo -e "\e[93mSPF Record missing: $ip\e[0m"
        ((missing_spf_count++))
    fi

    if [[ -z "$dmarc_result" ]]; then
        echo -e "\e[92mDMARC Record missing: $ip\e[0m"
        ((missing_dmarc_count++))
    fi

    ((total_domains_checked++))
done

echo -e "\nSummary:"
echo -e "Total SPF Records Missing: \e[93m$missing_spf_count\e[0m"
echo -e "Total DMARC Records Missing: \e[92m$missing_dmarc_count\e[0m"
echo -e "Total Number of Domains Checked: $total_domains_checked"
