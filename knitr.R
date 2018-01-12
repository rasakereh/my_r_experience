#!/usr/bin/Rscript

#based on a tutorial on: http://rprogramming.net/create-html-or-pdf-files-with-r-knitr-miktex-and-pandoc/

###############################################################################
#	Due to Iran sanctions, companies decided not to export
#	many of their products to Iran. Thanks US Export law :|
#	Among forbidden softwares you can notice some giants like
#	Sourceforge apps, Apache's (Hadoop, httpd, etc)
#	and too many other really essential tools for students and
#	ordinary employees not necessarily working for military organ.s
#
#	Among all restricted softwares, the HIGH STRATEGIC software, RStudio!,
#	meets the standards of a software which should not be exported
#	to Iran.
#
#	It caused me to write a tiny script file which "KNIT"s '.rmd' files
#	to do my homework.
#	(Although using softwares for some educational use,
#	is not prohibited, I just wanted the world to hear me!
#	While the US accuses Iran gov. of human right violation, 
#	it forbids companies to export some really necessary
#	softwares to iranians.)
###############################################################################

printUsage = function(exit = TRUE)
{
	needle = "--file="
    match = grep(needle, cmdArgs)
    if(length(match) > 0) 
    {
            path = normalizePath(sub(needle, "", cmdArgs[match]))
            print(sprintf("usage: %s filename [--pdf] [--html]", path));
    }
    
    if(exit)
    	q("no");
}

cmdArgs = commandArgs(trailingOnly = FALSE);
argv = commandArgs(trailingOnly = TRUE);
argc = length(argv);

if(argc == 0)
{
	printUsage();
}

filename = argv[1];
isHTMLneeded = "--html" %in% argv;
isPDFneeded = "--pdf" %in% argv;

htmlFile = paste0(substr(filename, 1, nchar(filename)-3), "html");
pdfFile = paste0(substr(filename, 1, nchar(filename)-3), "pdf");
mdFile = paste0(substr(filename, 1, nchar(filename)-3), "md");


if(!file.exists(filename))
{
	print(sprintf("%s is not a valid file", filename));
	printUsage();
}

#########
require(knitr);
require(markdown);
#########

#########
knit(filename);
if(isHTMLneeded || isPDFneeded)
{
	print("Generating HTML file...");
	markdownToHTML(mdFile, htmlFile, options=c("use_xhml"));
}
if(isPDFneeded)
{
	print("Generating PDF file...");
	system(sprintf("pandoc -s %s -o %s", htmlFile, pdfFile));
}
if(isPDFneeded && !isHTMLneeded && file.exists(htmlFile))
{
	print("Removing HTML file...");
	system(sprintf("rm %s", htmlFile));
}

#########
