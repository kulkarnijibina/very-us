//= require active_admin/base

$(document).ready(function(){
  $('#match_date').change(function(){
    this.form.submit();
  });
  $('.buckets_panel_form').closest('li').attr('class', 'buckets_form_inline');
})
