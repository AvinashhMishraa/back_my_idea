// Load Active Admin's styles into Webpacker,
// see `active_admin.scss` for customization.
import "../stylesheets/active_admin";

import "@activeadmin/activeadmin";

// for arctic admin theme for activeadmin page
import "@fortawesome/fontawesome-free/css/all.css";
import 'arctic_admin'

require('activeadmin_quill_editor');
// require("trix")

$(document).ready(function() {

	$("#footer").empty();
	// $("#footer").append('<span>powered by </span><a href="http://localhost:3000/"><b>Back My Idea</b></a>');
    $("#footer").append('<span>powered by </span><a href="https://back-my-idea.herokuapp.com/"><b>Back My Idea</b></a>');
	$('#filters_sidebar_section, #search_status_sidebar_section').wrapAll('<div class="sidebar_custom"></div>');
    $("#categories_project_submit_action input").val('Map Project Category');

    if ($(".blank_slate_container span").text() == "There are no Project Categories yet. Create one") {
        $(".blank_slate_container").empty();
        $(".blank_slate_container").append('<span class="blank_slate">There are no Project Category mappings yet. <a href="/admin/project_categories/new">Create one</a></span>');
    }

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
    if ( $(".panel_contents ul li:first").length != 0 && $(".panel_contents ul li:first")[0].innerText == "None") {
    		$(".panel_contents ul li:first").remove();
    }

    $('#project_expires_at_input .fragments .fragments-group').css('margin-left',532+'px');
    $('#project_expires_at_input .fragments .fragments-group').addClass("project_expires");

    $('#user_admin_input label input').remove();
    $('#user_admin_input label').append('<input type="checkbox" name="user[admin]" id="user_admin" value="1">');

    /////////////Integrating Quill Editor///////////////////

    if (window.location.href == "https://back-my-idea.herokuapp.com/admin/projects/new") {

      $('#project_description').wrapAll('<div id="project_description_input"></div>');
      var toolbarOptions = [
        ['bold', 'italic', 'underline', 'strike'],         // toggled buttons
        ['blockquote', 'link', 'code-block'],

        // [{ 'header': 1 }, { 'header': 2 }],             // custom button values
        [{ 'list': 'ordered'}, { 'list': 'bullet' }],
        [{ 'script': 'sub'}, { 'script': 'super' }],       // superscript/subscript
        [{ 'indent': '-1'}, { 'indent': '+1' }],           // outdent/indent
        [{ 'direction': 'rtl' }],                          // text direction

        [{ 'size': ['small', false, 'large', 'huge'] }],   // custom dropdown
        [{ 'header': [1, 2, 3, 4, 5, 6, false] }],

        [{ 'color': ['#F00', '#0F0', '#00F', '#000', '#FFF', 'color-picker'] }, { 'background': ['#F00', '#0F0', '#00F', '#000', '#FFF', 'color-picker'] }],        // dropdown with defaults from theme
        [{ 'font': [] }],
        [{ 'align': [] }],

        ['clean'],                                          // remove formatting button
      ];

      var quill = new Quill('#project_description_input', {
        modules: {
          toolbar: toolbarOptions
          // toolbar: true
        },
        theme: 'snow',
        placeholder: 'Description',
      });

      $('#project_description_input .ql-editor p:last').remove();
      $('#project_description_input .ql-tooltip input').remove();
      $('#project_description_input .ql-tooltip a:first').after('<input type="text" data-formula="e=mc^2" data-link="https://quilljs.com" data-video="Embed URL" name="project[description]" >');

      $( "#project_submit_action" ).click(function() {
        $('#project_description_input .ql-tooltip input').val(quill.root.innerHTML);
      });

    }

    ////////////////////////////////////////////////////////

});