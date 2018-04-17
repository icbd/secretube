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
    });


    // container card switch
    $(".switch input").click(function () {
        var container_id = $(this).data("container_id");
        var id = $(this).data("id");
        console.debug("container_id", container_id);
        console.debug("id", id);

        if ($(this).hasClass("disabled")) {
            console.debug("switch input is disabled.");
            return false;
        }

        var ajax_options = {
            type: "POST",
            async: true,
            url: "/containers/switch.js",
            data: {
                "container_id": container_id,
                "id": id
            },
            dataType: "script",
        };


        if ($(this).hasClass("checked")) {
            console.debug("turn off");
            $(this).removeClass("checked");
            ajax_options['data']['turn'] = 'off';

        } else {
            console.debug("turn on");
            $(this).addClass("checked");
            ajax_options['data']['turn'] = 'on';
        }

        console.debug('ajax_options', ajax_options);
        $.ajax(ajax_options);

        // remove disable when callback
        $(this).addClass("disabled");
    });
});
