//= require jquery3
//= require js.cookie

// use load not ready, waiting for img height
$(window).on("load", function () {
    set_bottom_bar();
});

function set_bottom_bar() {
    var $bottom_bar = $(".bottom-bar");
    var $demo_show = $(".demo-show");

    var bomttomBarOffestHeight =
        $demo_show.height() + $demo_show.offset().top + 50;

    $bottom_bar.css("top", bomttomBarOffestHeight + "px");
    $bottom_bar.fadeIn(1500);
}

function change_language(ele) {
    var locale = $(ele).find(":selected").val();
    console.debug(locale);
    Cookies.set('locale', locale);
    window.location.reload();
}