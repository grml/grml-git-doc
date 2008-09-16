all: doc

doc: doc_html
#doc: doc_man doc_html

doc_html: html-stamp

html-stamp: setup.txt
	asciidoc -b xhtml11 -a toc -a numbered -a icons setup.txt
	touch html-stamp

doc_man: man-stamp

man-stamp: setup.txt
	asciidoc -d manpage -b docbook setup.txt
	sed -i 's/<emphasis role="strong">/<emphasis role="bold">/' setup.xml
	xsltproc /usr/share/xml/docbook/stylesheet/nwalsh/manpages/docbook.xsl setup.xml
	# ugly hack to avoid duplicate empty lines in manpage
	# notice: docbook-xsl 1.71.0.dfsg.1-1 is broken! make sure you use 1.68.1.dfsg.1-0.2!
	#cp setup.8 setup.8.tmp
	#uniq setup.8.tmp > setup.8
	# ugly hack to avoid '.sp' at the end of a sentence or paragraph:
	#sed -i 's/\.sp//' setup.8
	#rm setup.8.tmp
	touch man-stamp

online: doc_html
	scp setup.html grml:/var/www/grml/git/

clean:
	rm -rf setup.html setup.xml setup.8 html-stamp man-stamp
