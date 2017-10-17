jQuery(document).on('change', 'select.sortBy', function() {
    $('#sort_form').attr('data-remote',true)
});


jQuery(document).on('click', 'a.show-advanced-search', function() {
    const $this = $(this);
    $('.advanced-search').toggleClass('hidden');
    if($('.advanced-search').hasClass('hidden')) {
        return $this.text('Advanced Fields');       
    } else { 
        return $this.text('Hide');
    }
});
    

jQuery(document).on('click', 'a.clear-search', function() {
    $('input#q_title_cont').val('');
    $('input#q_user_name_cont').val('');
    $("select#q_categories_name_cont option:selected").prop("selected", false);
    return $("select#q_categories_name_cont option:first").prop("selected", "selected");
});



$(document).ready(function() {
  
    $('#cat-dropdown-menu').multiselect({
      buttonWidth: '300px',
      buttonContainer: '<div class="btn-group" />',
      nonSelectedText: 'Any Category',
      includeSelectAllOption: true,
      allSelectedText: 'All Categories'
    });
    
     $(".browse-form-button").submit(
      function() {
        $("#nav-search").find('input').value('');
      }
     );
     
     $("button.btn-tag-cat").mouseenter(
      function() {
        var id = $(this).attr('id');
        $('#' + id).find('span').show();
      }).mouseleave(function() {
        var id = $(this).attr('id');
        $('#' + id).find('span').hide();
      }
    );
});