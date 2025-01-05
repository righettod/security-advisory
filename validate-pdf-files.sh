#!/bin/bash
# Ensure that advisory files are valid PDF and CVE advisory files
# Dependencies: apt install file pdfgrep
counter=0
for adv in $(ls advisories/*.pdf)
do
	check=$(file "$adv" | grep -Fic "PDF document")
	if [ $check -ne 1 ]
	then
		echo "[!] File '$adv' is not a PDF file!"
		exit 1
	fi
	check=$(pdfgrep -i -c "dominique righetto" "$adv")
	if [ $check -ne 1 ]
	then
		echo "[!] File '$adv' do not contains a reference to me!"
		exit 2
	fi
	check=$(pdfgrep -i -c "abstract advisory information" "$adv")
	if [ $check -ne 1 ]
	then
		echo "[!] File '$adv' do not contains the header 'Abstract Advisory Information'!"
		exit 3
	fi	
	counter=$((counter + 1))
done
echo "[V] $counter advisory files are OK."
exit 0
