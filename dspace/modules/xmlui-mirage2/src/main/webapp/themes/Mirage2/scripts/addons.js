(function($)
{
    if (/English/.test($("#ds-language-selection > a > span").text()))
    {
        $("li, h2, a, a > span, head > title, label").each(function ()
        {
	     if ($(this).text() == "Dokumente") {
                $(this).text("Documents");
            }
            if (/Serien$/.test($(this).text())) {
                $(this).text("Periodicals Archive");
            }
	     if ($(this).text() == "americanstudies") {
                $(this).text("American Studies");
            }
	if ($(this).text() == "australianstudies") {
                $(this).text("Australian Studies");
            }
	 if ($(this).text() == "americanstudies ×") {
                $(this).text("American Studies");
            }
	if ($(this).text() == "anglophoneliterature") {
                $(this).text("Anglophone Literatures and Cultures");
            }
	 if ($(this).text() == "politicalscience") {
               $(this).text("Politics");
            }
	 if ($(this).text() == "culturalstudies") {
                $(this).text("Cultural Studies");
            }
         if ($(this).text() == "englishstudies") {
               $(this).text("English");
	}
	if ($(this).text() == "irishstudies") {
               $(this).text("Irish Studies");
        }
	    if ($(this).text() == "linguistics") {
                $(this).text("Linguistics");
            }
         if ($(this).text() == "literarystudies") {
               $(this).text("Literary Studies");
            }
         if ($(this).text() == "mediastudies") {
                $(this).text("Film & Media Studies");
            }
         if ($(this).text() == "socialscience") {
               $(this).text("Social Sciences");
        }
	 if ($(this).text() == "englishlanguageteaching") {
                $(this).text("English Language Teaching");
            }
         if ($(this).text() == "history") {
               $(this).text("History");
            }
         if ($(this).text() == "britishstudies") {
                $(this).text("British Studies");
            }
         if ($(this).text() == "canadianstudies") {
               $(this).text("Canadian Studies");
        }
            if ($(this).text() == "genderstudies") {
                $(this).text("Gender Studies");
            }
         if ($(this).text() == "law") {
               $(this).text("Law");
            }
	if ($(this).text() == "medievalstudies") {
               $(this).text("Medieval Studies");
            }
	if ($(this).text() == "postcolonial") {
               $(this).text("Postcolonial Studies");
            }

        });
    }

     if (/Deutsch/.test($("#ds-language-selection > a > span").text()))
    {
        $("li, h2, a, a > span, head > title, label").each(function ()
        {
             if ($(this).text() == "americanstudies") {
                $(this).text("Amerikastudien");
            }
	if ($(this).text() == "australianstudies") {
                $(this).text("Australienstudien");
            }
	 if ($(this).text() == "americanstudies&nbsp;×") {
                $(this).text("Amerikastudien");
            }
	 if ($(this).text() == "anglophoneliterature") {
                $(this).text("Anglophone Literaturen und Kulturen");
            }
         if ($(this).text() == "politicalscience") {
               $(this).text("Politikwissenschaften");
            }
	         if ($(this).text() == "culturalstudies") {
                $(this).text("Kulturwissenschaften");
            }
         if ($(this).text() == "englishstudies") {
               $(this).text("Anglistik");
        }
	if ($(this).text() == "irishstudies") {
               $(this).text("Irlandstudien");
        }
            if ($(this).text() == "linguistics") {
                $(this).text("Sprachwissenschaften");
            }
         if ($(this).text() == "literarystudies") {
               $(this).text("Literaturwissenschaften");
            }
         if ($(this).text() == "mediastudies") {
                $(this).text("Film- & Medienwissenschaften");
            }
         if ($(this).text() == "socialscience") {
               $(this).text("Sozialwissenschaften");
        }
         if ($(this).text() == "englishlanguageteaching") {
                $(this).text("Fachdidaktik");
            }
         if ($(this).text() == "history") {
               $(this).text("Geschichte");
            }
         if ($(this).text() == "britishstudies") {
                $(this).text("Großbritannienstudien");
            }
         if ($(this).text() == "canadianstudies") {
               $(this).text("Kanadastudien");
        }
            if ($(this).text() == "genderstudies") {
                $(this).text("Geschlechterforschung");
            }
         if ($(this).text() == "law") {
               $(this).text("Jura");
            }
	if ($(this).text() == "medievalstudies") {
               $(this).text("Mediävistik");
            }
	 if ($(this).text() == "postcolonial") {
               $(this).text("Postkoloniale Studien");
            }



        });
    }

})(jQuery);
