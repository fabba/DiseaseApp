//= require jquery_ujs
var $ = jQuery;

// Log in on the server, a session is created for the user.
function post(nickName,passWord) {
  $.ajax({
    url: '/users?nickName=' + nickName + "&passWord=" + passWord,
    type: 'POST',
    headers: {
      'X-CSRF-Token': $("meta[name='csrf-token']").attr("content")
    }
	});
	alert("Succesfully logged in!");
}

function zoom( code) {
        document.location.href = '/users/zoomCountry/' +code;
    
    }  
// Send the new visited country of the current user to rails    
function visitCountry( countryId){
    $.ajax({
    url: '/users/visitCountry?countryId=' + countryId,
    type: 'POST',
    headers: {
      'X-CSRF-Token': $("meta[name='csrf-token']").attr("content")
    }
	});
  document.location.href = '/users/showCountries'

}

// Send the new wished country of the current user to rails 
function wishCountry( countryId){
  $.ajax({
    url: '/users/wishCountry?countryId=' + countryId,
    type: 'POST',
    headers: {
      'X-CSRF-Token': $("meta[name='csrf-token']").attr("content")
    }
	});
  document.location.href = '/users/showCountries'

}

// Got to the country show page when you click on a region at the jvectormap
function showSelectedCountry(event, code) {
  var map = $('#map1').vectorMap('get', 'mapObject');
  document.location.href = '/country/change/' + map.getRegionName(code);
}

// The jvectormap will be initialized after the page has loaded
$( document ).ready(function(){   
  $('#map1').vectorMap({
    map: 'world_mill_en',
    onRegionClick: showSelectedCountry,
    series: series
  });
  $('#map1').vectorMap('set', 'focus',  focusOn);
} );


    

