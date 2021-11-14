// Load Active Admin's styles into Webpacker,
// see `active_admin.scss` for customization.
import "../stylesheets/active_admin";

import "@activeadmin/activeadmin";

// for arctic admin theme for activeadmin page
import "@fortawesome/fontawesome-free/css/all.css";
import 'arctic_admin'

$(document).ready(function() {
	$("#footer").empty();
	// $("#footer").append('<span>powered by </span><a href="http://localhost:3000/"><b>Back My Idea</b></a>');
    $("#footer").append('<span>powered by </span><a href="https://back-my-idea.herokuapp.com/"><b>Back My Idea</b></a>');
	$('#filters_sidebar_section, #search_status_sidebar_section').wrapAll('<div class="sidebar_custom"></div>');

    // for showing custom filter search result in sidebar
    var queryString = window.location.search;
    queryString = queryString.replaceAll("q%5B","");
    queryString = queryString.replaceAll("%5D=","=");
    console.log(queryString);
    const urlParams = new URLSearchParams(queryString);
    const keys = urlParams.keys(), values = urlParams.values(), entries = urlParams.entries();
    var i = 0;
    for(const entry of entries) {
     	// console.log(`${entry[0]}: ${entry[1]}`);
     	var existing_filter =  "."+"current_filter_"+entry[0];
       	if (entry[0] !="commit" && entry[0] != "order" && $(existing_filter).length==0) {
       		$(".panel_contents ul li:last").after('<li class="custom_current_filter"><span id=spanid></span><b id="valueid"></b></li>');
       		var span_id = "spanid"+i;
       		var value_id = "valueid"+i;
       		$("#spanid").attr("id", span_id);
       		$("#valueid").attr("id", value_id);
       		var new_span_id = "#"+span_id;
       		var new_value_id = "#"+value_id;
       		entry[0] = entry[0].replaceAll("_eq", " equals");
       		entry[0] = entry[0].replaceAll("_id", " ");
       		entry[0] = entry[0].replaceAll("_", " ");
       		entry[0] = entry[0].charAt(0).toUpperCase() + entry[0].slice(1);
       		entry[1] = " "+entry[1];
       		$(new_span_id).html(entry[0]);
       		$(new_value_id).html(entry[1]);
       		i=i+1;
       	}
    }
    if ($(".panel_contents ul li:first")[0].innerText == "None") {
    		$(".panel_contents ul li:first").remove();
    }
});