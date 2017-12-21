jQuery(document).on('click', 'a.show-advanced-search', function() {
    const $this = $(this);
    $('.advanced-search').toggleClass('hidden');
    if($('.advanced-search').hasClass('hidden')) {
        return $this.text('Advanced Fields');       
    } else { 
        return $this.text('Hide');
    }
});
    

$(document).ready(function() {
  
    $('#cat-dropdown-menu').multiselect({
      buttonWidth: '300px',
      buttonContainer: '<div class="btn-group" />',
      nonSelectedText: 'Any Category',
      includeSelectAllOption: true,
      allSelectedText: 'All Categories'
    });
    
    $('.sortBy').multiselect({
      buttonWidth: '150px',
      buttonContainer: '<div class="btn-group" />',
      onChange: function(option) {
        $('#q_s').val($(option).val());
        $('#form').submit();
      },   
    });
                
     
    $(".btn-tag-cat").mouseenter(
      function() {
        var id = $(this).attr('id');
        $('#' + id).find('span').show();
      }).mouseleave(function() {
        var id = $(this).attr('id');
        $('#' + id).find('span').hide();
      }
    );
  
    var length = $('#article-description').innerHeight(); 

    if(length > 500) {
        $('#article-description').addClass("height-style");
        $('#read-more').find("button").removeClass("hidden");
    } else {
       $('#article-description').css("height", "600px");
       $('#article-description').css("overflow", "auto");
    }
       
    $('#read-more').on('click', function(e) {
      e.preventDefault();
      var button = $('#read-more').find("button");
      $('#article-description').toggleClass("height-style");
      if ($('#article-description').hasClass("height-style") == true) {
        $(button).text("Read more");
      } else {
        $(button).text("Hide");
      }
    });
    
    $("#article_category_ids").select2({
      tokenSeparators: [','],
      maximumSelectionLength: 5,
      formatSelectionTooBig: function (limit) {
          return 'Too many selected items';
      }
    });
    
});

function validatearticleFunction() {
  $('#new_article').validate({
    debug: false,
    rules: {
      'article[title]': { required: true, minlength: 10, maxlength: 100 },
      'article[description]': { required: true, minlength: 10 },
      'article[status]': { required: true }
    },
    messages: {
      'article[title]': { required: "You must have a title for your article",
                          minlength: "Title must be at least 10 characters",
                          maxlength: "Title must be less than 100 characters" },
      'article[description]': { required: "You must have a description for your article",
                                minlength: "Content must be at least 10 characters" },
      'article[status]': {
            required: "You must check at least 1 box",
        }
    }
  });
}
$(document).ready(validatearticleFunction);
$(document).on('page:load', validatearticleFunction);

$(document).ready(function() {
  $('pre code').each(function(i, block) {
    hljs.highlightBlock(block);
  });
});

