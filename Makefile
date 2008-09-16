all: doc

doc: doc_html
#doc: doc_man doc_html

doc_html: html-stamp

html-stamp: setup.txt use-of-git.txt
	asciidoc -b xhtml11 setup.txt
	asciidoc -b xhtml11 use-of-git.txt
	touch html-stamp

doc_man: man-stamp

man-stamp: setup.txt use-of-git.txt
	asciidoc -d manpage -b docbook setup.txt
	sed -i 's/<emphasis role="strong">/<emphasis role="bold">/' setup.xml
	xsltproc /usr/share/xml/docbook/stylesheet/nwalsh/manpages/docbook.xsl setup.xml
	asciidoc -d manpage -b docbook use-of-git.txt
	sed -i 's/<emphasis role="strong">/<emphasis role="bold">/' use-of-git.xml
	xsltproc /usr/share/xml/docbook/stylesheet/nwalsh/manpages/docbook.xsl use-of-git.xml
	# ugly hack to avoid duplicate empty lines in manpage
	# notice: docbook-xsl 1.71.0.dfsg.1-1 is broken! make sure you use 1.68.1.dfsg.1-0.2!
	#cp grml2hd.8 grml2hd.8.tmp
	#uniq grml2hd.8.tmp > grml2hd.8
	# ugly hack to avoid '.sp' at the end of a sentence or paragraph:
	#sed -i 's/\.sp//' grml2hd.8
	#rm grml2hd.8.tmp
	touch man-stamp

clean:
	rm -rf setup.html setup.xml setup.8 \
	       use-of-git.html use-of-git.xml use-of-git.8 \
	       html-stamp man-stamp
