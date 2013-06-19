// compress by http://javascriptcompressor.com/
javascript: void((

    function () {
        if (typeof jQuery == "undefined" || jQuery == null) {
            var hjelm = document.createElement('script');
            hjelm.setAttribute('src', '//ajax.googleapis.com/ajax/libs/jquery/1.10.1/jquery.min.js');
            document.body.appendChild(hjelm);
        }
        jQuery(function () {
            var result_txt = "",
                result_map = {};
            jQuery('a').each(function () {
                if (jQuery(this).attr("href") && jQuery(this).attr("title") && jQuery(this).attr("href").indexOf("http://v.youku.com/v_show/") == 0) {
					// The special regular expression characters in JavaScript are: . \ + * ? [ ^ ] $ ( ) { } = ! < > | : -
                    result_map[jQuery(this).attr("title").replace(/\s+/g, "_").replace(/\?/g, "？").replace(/:/g, "：").replace(/!/g, "！").replace(/\/|\¥|\%|\*|\||\"|\<|\>/g,"")] = jQuery(this).attr("href")
                }
            });
            for (var r in result_map) {
                result_txt += r + "\t-#-\t" + result_map[r] + "\n"
            }
            $("#result_of_videos_links").remove();
            jQuery("body").prepend("<div id='result_of_videos_links' style='background-color: #bde9ba; position: absolute; top: 10px; left:10px;'><textarea id='result_to_copy'></textarea>");
            var $result_box = jQuery("#result_to_copy");
            $result_box.val(result_txt);
            $result_box.mousedown(function (event) {
                switch (event.which) {
                case 3:
                    $(this).select()
                }
            })
        });
    }

)());