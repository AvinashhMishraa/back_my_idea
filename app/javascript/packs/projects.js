const axios = require("axios");
import { debounce } from "./debounce.js";

var query = document.querySelector("#query");
var projects = document.querySelector("#project-wrap");
// var paginate_projects = document.querySelector("#pagination-wrap");
// var projects = document.querySelector("#project_pagination");

// query.addEventListener("input", getSearchResults);
query.addEventListener("input", debounce(getSearchResults, 500));

function getSearchResults(event) {

  var query = event.srcElement.value;
  var token = document.getElementsByName("csrf-token")[0].content;

  axios.get("/search", {
    params: {q: query},
    headers: {
      "Accept": "application/javascript",
      "X-CSRF-token": token,
      "X-Requested-with": "XMLHTTPRequest"
    }
  }).then(response => {
    // console.log(response)
    projects.innerHTML = response.data
    // paginate_projects.innerHTML = response.data
  })

}
