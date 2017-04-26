(function($)
{
    if (/English/.test($("#ds-language-selection > a > span").text()))
    {
        $("h2, li, a, a > span").each(function ()
        {
            if ($(this).text() == "Gesamter Bestand") {
                $(this).text("All Publications");
            }
            if (/Anglistik/.test($(this).text())) {
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
            if (/Zeitschriften/.test($(this).text())) {
                $(this).text("Periodicals archive");
            }
                       

        });
        
    }

})(jQuery);
