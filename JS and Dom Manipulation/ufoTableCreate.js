// Get references to the tbody element, input field and button
var $tbody = document.querySelector("#myBody");

//state search vars
var $stateInput = document.querySelector("#state");
var $searchBtn = document.querySelector("#search");
//datesearch vars
var $dateInput = document.querySelector("#date");
// var $dateSearchBtn = document.querySelector("#dateSearch");
//citysearch vars
var $cityInput = document.querySelector("#city");
// var $citySearchBtn = document.querySelector("#citySearch");
//shapesearch vars
var $shapeInput = document.querySelector("#shape");
// var $shapeSearchBtn = document.querySelector("#shapeSearch");

//Wnable pagenation 
var $loadMoreBtn = document.querySelector("#loadBtn");
// Add an event listener to the searchButton, call handleSearchButtonClick when clicked
$searchBtn.addEventListener("click", handleSearchButtonClick);
// $dateSearchBtn.addEventListener("click", handleDateSearchButtonClick);
// $citySearchBtn.addEventListener("click", handlecitySearchButtonClick);
// $shapeSearchBtn.addEventListener("click", handleShapeSearchButtonClick);

// Set filteredAddresses to addressData initially
var filteredAddresses = dataSet;
var r1Val = document.querySelector("#r1");
var r2Val = document.querySelector("#r2");
var r3Val = document.querySelector("#r3");
console.log(r1Val);

// Set a startingIndex and resultsPerPage variable
var startingIndex = 0;
var resultsPerPage = 10;

$loadMoreBtn.innerText = "Load Next " + resultsPerPage + " addresses"

// renderTable renders the filteredAddresses to the tbody
function renderTable() {
  $tbody.innerHTML = "";
    // Set the value of endingIndex to startingIndex + resultsPerPage
  var endingIndex = startingIndex + resultsPerPage;
  // Get a section of the addressData array to render
  var addressSubset = filteredAddresses.slice(startingIndex, endingIndex);

  for (var i = 0; i < addressSubset.length; i++) {
    // Get get the current address object and its fields
    var address = addressSubset[i];
    var fields = Object.keys(address);
    // Create a new row in the tbody, set the index to be i + startingIndex
    var $row = $tbody.insertRow(i);
    for (var j = 0; j < fields.length; j++) {
      // For every field in the address object, create a new cell at set its inner text to be the current value at the current address's field
      var field = fields[j];
      var $cell = $row.insertCell(j);
      $cell.innerText = address[field];
    }
  }
};

function handleSearchButtonClick() {
  // Format the user's search by removing leading and trailing whitespace, lowercase the string
  var filterState = $stateInput.value.trim().toLowerCase();
  var filterCity  = $cityInput.value.trim().toLowerCase();  
  var filterShape = $shapeInput.value.trim().toLowerCase();
  var filterDate  = $dateInput.value.trim();

  // default the inouts
  if (filterDate == '') {filterDate = '1/1/2010'};

  // Set filteredAddresses to an array of all addresses whose "state" matches the filter
  filteredAddresses = dataSet.filter(function(address) {
    // var addressState = address.state.toLowerCase();
    var addressState = address.state.substring(0, filterState.length).toLowerCase();
    var addressCity = address.city.substring(0, filterCity.length).toLowerCase();
    var addressShape = address.shape.substring(0,filterShape.length).toLowerCase();
    var ufoDate = address.datetime;
  
    if (filterShape == 'all' || filterShape == ''){
      var noShape = true;
    }

    // If true, add the address to the filteredAddresses, otherwise don't add it to filteredAddresses
    if (noShape){
      if (addressState === filterState && addressCity === filterCity &&  ufoDate == filterDate){
      return true;
    } 
    } else {
      if (addressState === filterState && addressCity === filterCity && addressShape === filterShape &&  ufoDate === filterDate){
        return true;
      } else {
        return false;
      }
    }
});
  renderTable();
  sortTable(2);
}


function handlecitySearchButtonClick() {
  // Format the user's search by removing leading and trailing whitespace, lowercase the string
  var filterCity = $cityInput.value.trim().toLowerCase();

  // Set filteredAddresses to an array of all addresses whose "state" matches the filter
  filteredAddresses = dataSet.filter(function(address) {
    var addressCity = address.city.toLowerCase();

    // If true, add the address to the filteredAddresses, otherwise don't add it to filteredAddresses
    return addressCity === filterCity;
  });
  renderTable();
}


function handleShapeSearchButtonClick() {
  // Format the user's search by removing leading and trailing whitespace, lowercase the string
  var filterShape = $shapeInput.value.trim().toLowerCase();

  // Set filteredAddresses to an array of all addresses whose "state" matches the filter
  filteredAddresses = dataSet.filter(function(address) {
    var addressShape = address.shape.toLowerCase();

    // If true, add the address to the filteredAddresses, otherwise don't add it to filteredAddresses
    return addressShape === filterShape;
  });
  renderTable();
}

function handleDateSearchButtonClick() {
  // Format the user's search by removing leading and trailing whitespace, lowercase the string
  var filterDate = $dateInput.value.trim();

  // Set filteredAddresses to an array of all addresses whose "state" matches the filter
  filteredAddresses = dataSet.filter(function(address) {
    var ufoDate = address.datetime;

    // If true, add the address to the filteredAddresses, otherwise don't add it to filteredAddresses
    return ufoDate === filterDate;
  });
  renderTable();
}

// Add an event listener to the button, call handleButtonClick when clicked
$loadMoreBtn.addEventListener("click", handleButtonClick);

function handleButtonClick() {
  // Increase startingIndex by 100 and render the next section of the table
  startingIndex += resultsPerPage;
  renderTable();
  sortTable(2);
  // Check to see if there are any more results to render
  if (startingIndex + resultsPerPage >= filteredAddresses.length) {
    $loadMoreBtn.classList.add("disabled");
    $loadMoreBtn.innerText = "All Addresses Loaded";
    $loadMoreBtn.removeEventListener("click", handleButtonClick);
  }
}

function sortTable(n) {
  var table, rows, switching, i, x, y, shouldSwitch, dir, switchcount = 0;
  table = document.getElementById("myTable");
  switching = true;
  //Set the sorting direction to ascending:
  dir = "asc"; 
  /*Make a loop that will continue until
  no switching has been done:*/
  while (switching) {
    //start by saying: no switching is done:
    switching = false;
    rows = table.getElementsByTagName("TR");
    /*Loop through all table rows (except the
    first, which contains table headers):*/
    for (i = 1; i < (rows.length - 1); i++) {
      //start by saying there should be no switching:
      shouldSwitch = false;
      /*Get the two elements you want to compare,
      one from current row and one from the next:*/
      x = rows[i].getElementsByTagName("TD")[n];
      y = rows[i + 1].getElementsByTagName("TD")[n];
      /*check if the two rows should switch place,
      based on the direction, asc or desc:*/
      if (dir == "asc") {
        if (x.innerHTML.toLowerCase() > y.innerHTML.toLowerCase()) {
          //if so, mark as a switch and break the loop:
          shouldSwitch= true;
          break;
        }
      } else if (dir == "desc") {
        if (x.innerHTML.toLowerCase() < y.innerHTML.toLowerCase()) {
          //if so, mark as a switch and break the loop:
          shouldSwitch= true;
          break;
        }
      }
    }
    if (shouldSwitch) {
      /*If a switch has been marked, make the switch
      and mark that a switch has been done:*/
      rows[i].parentNode.insertBefore(rows[i + 1], rows[i]);
      switching = true;
      //Each time a switch is done, increase this count by 1:
      switchcount ++;      
    } else {
      /*If no switching has been done AND the direction is "asc",
      set the direction to "desc" and run the while loop again.*/
      if (switchcount == 0 && dir == "asc") {
        dir = "desc";
        switching = true;
      }
    }
  }
}

renderTable();
sortTable(2);