#!/bin/bash
# Ensure that advisory files are valid according to the type of advisory
# Dependencies: apt install file pdfgrep jq
counter=0
echo "## Validate Thales TCS CERT advisories PDF files"
for adv in $(ls thales-advisories/*.pdf)
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
echo "## Validate advisories JSON files"
for adv in $(ls no-advisories/*.json)
do
	jq empty $adv > /dev/null 2>&1
	if [ $? -ne 0 ]
	then
		echo "[!] File '$adv' is not a JSON file!"
		exit 4
	fi
	check=$(grep -Fic "dominique righetto" "$adv")
	if [ $check -ne 1 ]
	then
		echo "[!] File '$adv' do not contains a reference to me!"
		exit 5
	fi	
	counter=$((counter + 1))
done
echo "[V] $counter advisory files are OK."
exit 0
