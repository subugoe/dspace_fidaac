(function($)
{
    if (/English/.test($("#ds-language-selection > a > span").text()))
    {
        $("li, h2, a, a > span, head > title").each(function ()
        {
	     if ($(this).text() == "Dokumente") {
                $(this).text("Documents");
            }
            if (/Serien$/.test($(this).text())) {
                $(this).text("Periodicals Archive");
            }
                       

        });
        
    }

})(jQuery);
