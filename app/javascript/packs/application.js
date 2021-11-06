// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

// import Rails from "@rails/ujs"
// import Turbolinks from "turbolinks"
// import * as ActiveStorage from "@rails/activestorage"
// import "channels"

// Rails.start()
// Turbolinks.start()
// ActiveStorage.start()

require("@rails/ujs").start()
require("turbolinks").start()
require("@rails/activestorage").start()
require("channels")

require("trix")
require("@rails/actiontext")

require("jquery")
require("easy-autocomplete")
// import "packs/projects"

import "stylesheets/application"
// import "controllers"
// import "components/stripe";

import 'select2'
import 'select2/dist/css/select2.css'


// $(document).on("turbolinks.load", ()=>{
// 	$('.select2').select2()
// });

// $('.select2').select2();
