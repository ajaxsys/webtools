// Compress by http://javascriptcompressor.com/
javascript:void(function(window,document){

loadJQuery( window, document,
  // Minimum jQuery version required. Change this as-needed.
  '1.3.2',
  // Your jQuery code goes inside this callback. $ refers to the jQuery object,
  // and L is a boolean that indicates whether or not an external jQuery file
  // was just "L"oaded.
  afterJQueryLoad
);

function loadJQuery( window, document, req_version, callback, $, script, done, readystate ){
  
  // If jQuery isn't loaded, or is a lower version than specified, load the
  // specified version and call the callback, otherwise just call the callback.
  if ( !($ = window.jQuery) || version_compare(req_version , $.fn.jquery) > 0 || callback( $ ) ) {
    
    // Create a script element.
    script = document.createElement( 'script' );
    script.type = 'text/javascript';
    
    // Load the specified jQuery from the Google AJAX API server (minified).
    script.src = 'http://ajax.googleapis.com/ajax/libs/jquery/' + req_version + '/jquery.min.js';

    
    // When the script is loaded, remove it, execute jQuery.noConflict( true )
    // on the newly-loaded jQuery (thus reverting any previous version to its
    // original state), and call the callback with the newly-loaded jQuery.
    script.onload = script.onreadystatechange = function() {
      if ( !done && ( !( readystate = this.readyState )
        || readystate == 'loaded' || readystate == 'complete' ) ) {
        
        callback( ($ = window.jQuery).noConflict(1), done = 1 );
        
        $( script ).remove();
      }
    };
    
    // Add the script element to either the head or body, it doesn't matter.
    appendTag(script);
  }
  
}

function get1stTag() {
    var result;
    for (var i = 0; i < arguments.length; i++) {
        var tag=arguments[i],
            tags=document.getElementsByTagName(tag);
        if (tags.length>0) {
            result = tags[0];
            break;
        }
    }
    return result || document.documentElement.childNodes[0];
}

// for test & hook
function appendTag(node) {
    var tag = get1stTag('head','body');
    if (tag){
        tag.appendChild(node);
    } else {
        var url = 'http://dict-admin.appspot.com';
        alert('Sorry, Not support for your browser. More details, visit: '+url);
        window.open(url);
    }
};

function version_compare(v1, v2) {
    console.log(v1 , " vs " , v2);
    var v1parts = v1.split('.'),
        v2parts = v2.split('.');

    for (var i = 0; i < v1parts.length; ++i) {
        if (v2parts.length == i) {
            return 1;
        }
        if (v1parts[i] == v2parts[i]) {
            continue;
        }
        else if (parseInt(v1parts[i],10) > parseInt(v2parts[i],10)) {
            return 1;
        }
        else {
            return -1;
        }
    }

    if (v1parts.length != v2parts.length) {
        return -1;
    }

    return 0;
}

// Regist jQuery in closure
var jQuery,$;
function afterJQueryLoad($$,L) {
        jQuery = $ = $$;
        execute();
}

// A simple output, copy all by right click.
var O_DIV="__result_of_common__ouput__",O_TXTAREA="__result_to_copy__";
function initOutput() {
    var $commonDIV=$("<div style='background-color: #bde9ba; position: fixed; top: 10px; left:10px; z-index:99999;'>").attr("id",O_DIV),
        $commonTxtArea=$("<textarea>").attr("id",O_TXTAREA);
    $commonTxtArea.mousedown(function (event) {
            switch (event.which) {
            case 3:
                $(this).select();
            }
    });
    $commonDIV.append($commonTxtArea).appendTo("body");
}

function out(str) {
    if ($("#"+O_DIV).length===0)
        initOutput();
    $("#"+O_TXTAREA).val(str);
}


function execute(){
///////////////////////////
// More customize code here, can use $ & jQuery
///////////////////////////


    // Get youku links, and format to Dyouku
    var result_txt = "",
        result_map = {};

    $('a').each(function () {
        if (jQuery(this).attr("href") && 
            (   jQuery(this).attr("href").indexOf("http://v.youku.com/v_show/"     ) == 0 
             || jQuery(this).attr("href").indexOf("http://www.tudou.com/albumplay/") == 0
             || jQuery(this).attr("href").indexOf("http://www.letv.com/ptv/vplay/" ) == 0)
           ) {
            var key = "";
            if (jQuery(this).attr("title")) {
                key = jQuery(this).attr("title");
            } else {
                key = jQuery(this).text();
                // If no title and no link text - only numbers
                if (/[0-9]+/.test(key)) {
                    key = document.title.split("_")[0].split("-")[0]+"_"+key;
                }
            }
            // The special regular expression characters in JavaScript are: . \ + * ? [ ^ ] $ ( ) { } = ! < > | : -
            key = key.replace(/\s+/g, "_").replace(/\?/g, "？").replace(/:/g, "：").replace(/!/g, "！").replace(/\/|\¥|\%|\*|\||\"|\<|\>/g,"");
            result_map[key] = jQuery(this).attr("href");
        }
    });
    for (var r in result_map) {
        result_txt += r + "\t-#-\t" + result_map[r] + "\n"
    }
    out(result_txt);

/////////////////////////// End customize code
}


})(window,document);

