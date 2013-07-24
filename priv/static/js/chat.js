$(function(){
  var source = new EventSource("http://localhost:4000/chat/subscribe");
  source.addEventListener('message', function(e){
    var line = $('<p class="chat-line">' + e.data + '</p>');
    line.appendTo('#chat-area');
  });
});