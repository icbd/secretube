//= require jquery3
//= require jquery_ujs
//= require popper
//= require bootstrap-sprockets
//= require turbolinks
//= require_tree .


$(function () {
    // avoid model repeat
    $("#modal_container").on('hidden.bs.modal', function () {
        $(this).removeData('bs.modal');
        $(this).empty();
    })
});