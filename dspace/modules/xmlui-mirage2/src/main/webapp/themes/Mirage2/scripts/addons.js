(function($)
{
    if (/English/.test($("#ds-language-selection > a > span").text()))
    {
        $("li, h2, a, a > span, head > title").each(function ()
        {
            if ($(this).text() == "Gesamter Bestand") {
                $(this).text("All Publications");
            }
            if (/Irlandstudien$/.test($(this).text())) {
                $(this).text("English; British and Irish Studies");
            }
            if ($(this).text() == "Amerikastudien") {
                $(this).text("American Studies");
            }
            if ($(this).text() == "Australien- und Neuseelandstudien") {
                $(this).text("Australian and New Zealand Studies");
            }
            
            if ($(this).text() == "Kanadastudien") {
                $(this).text("Canadian Studies");
            }
            if (/Serien$/.test($(this).text())) {
                $(this).text("Periodicals archive");
            }
                       

        });
        
    }

})(jQuery);
