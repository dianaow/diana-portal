function validatecommentFunction() {
  $('#new_comment').validate({
    debug: false,
    rules: {
      'comment[content]': { required: true, minlength: 10, maxlength: 100 }
    },
    messages: {
      'comment[content]': { required: "There is no content in your comment",
                            minlength: "Comment must be at least 10 characters",
                            maxlength: "Comment must be less than 1000 characters" },

    }
  });
}
$(document).ready(validatecommentFunction);
$(document).on('page:load', validatecommentFunction);

$(document).ready(function() {
  
    var count = $('#comment-content').text().length; 
    var content = $('#comment-content').text();
    var span = $('#comment-more').find("span");
    
    var shortText = jQuery.trim(content).substring(0, 500)
    .split(" ").slice(0, -1).join(" ") + "...";

    if(count > 500) {
        $('#comment-content').text(shortText);
        $(span).removeClass("hidden");
    } 
    
    $(span).on('click', function() {

      if ($("#comment-content").text() == shortText)
        $("#comment-content").text(content)
      else
        $("#comment-content").text(shortText);
        
      if ($(span).text() == "More")
        $(span).text("Less")
      else
        $(span).text("More");

    });
    
});