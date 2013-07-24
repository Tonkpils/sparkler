$(function() {
  $('#sign-up').submit(function(e){
  	e.preventDefault();
  	user = { username: $('#user_username').val() };

  	$('#user_username').val("");

  	$.ajax({
  	  type: "POST",
  	  url: "/users",
  	  data: {user: user},
  	  dataType: "json",
  	  caller: this,
  	  success: function(data) {
  	  	$('#registered-users').append('<p>' + data.username + '</p>');
  	  }
  	});
  });
});