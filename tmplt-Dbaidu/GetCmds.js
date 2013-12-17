
// Compress to bookmarklet by http://javascriptcompressor.com/
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
  if ( !($ = window.jQuery) || version_compare(req_version , $.fn.jquery) > 0 ) {
    
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
  } else {
  	console.log("Use existed jQuery. (Not load jQuery)");
  	callback($, done=0 );
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
function initOutput() {
    var $commonDIV=$("<div id='__result_of_common__ouput__' style='background-color: #bde9ba; position: fixed; bottom: 10px; left:10px; z-index:99999;'>"),
        $commonTxtArea=$("<textarea id='__result_to_copy__'>");
    $commonTxtArea.mousedown(function (event) {
            switch (event.which) {
            case 3:
                $(this).select();
            }
    });
    $commonDIV.append($commonTxtArea).appendTo("body");
}
function ln(s){
	return s+'\n';
}
function out(str) {
    if ($("#__result_of_common__ouput__").length===0)
        initOutput();
    $("#__result_to_copy__").val(str);
}


function execute(){
///////////////////////////
// More customize code here, can use $ & jQuery
///////////////////////////


// Get baidupan links, and format to Dbaidu
var result = "";

;(function($){
var MAKE_SURE = "### Before download: Make sure move files to /apps/bpcs_uploader ###";
// Baidu Pan hide datas in DOM

var cache = FileUtils.getLocalCache();

/*
var folders=$("#dirPath").text().replace(/\s+>\s+/g,">").split(">");
var i = 0,isBpcs = false;
for (i in folders) {
	// Remove path until bpcs_uploader folder
	if (folders[i].indexOf("bpcs_uploader")>=0) {
		isBpcs = true;
	}
	if (isBpcs)
		break;
}
if (!isBpcs) {
	result+=ln("# [ERROR]"+MAKE_SURE);
	return;
}
//delete folders[i];
folders.splice(0,++i);
*/

var lastPath;
for (var i in cache._mCache){
    lastPath = i
}
dir = lastPath.replace('/apps/bpcs_uploader','');
result+=ln("# Current folder: "+ dir);
result+=ln("mkdir -p 'output" + dir+"'");



var files = cache._mCache[lastPath];
result+=ln("# Files number: "+ files.length);

for (var i=0; i<files.length; i++) {
	var info = files[i];
    if (info.isdir===0) {
		result+=ln("./bpcs_uploader.php download 'output"+dir+"/"+info.server_filename +"' '"+dir+"/"+info.server_filename+"'");
	} else {
		result+=ln("# [WARN] ignore dir `"+ info.server_filename+ "`. Please go into the folder, and re-run this script. " );
	}
}

})(jQuery);

out(result);

/////////////////////////// End customize code
}


})(window,document);

