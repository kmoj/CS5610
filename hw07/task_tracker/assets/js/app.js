// Brunch automatically concatenates all files in your
// watched paths. Those paths can be configured at
// config.paths.watched in "brunch-config.js".
//
// However, those files will only be executed if
// explicitly imported. The only exception are files
// in vendor, which are never wrapped in imports and
// therefore are always executed.

// Import dependencies
//
// If you no longer want to use a dependency, remember
// to also remove its path from "config.paths.watched".
import "phoenix_html";
import $ from "jquery";

// Import local files
//
// Local files can be imported directly using relative
// paths "./socket" or full ones "web/static/js/socket".

// import socket from "./socket"

function init_manages() {

    if(!$(".manage-button")) {
        return;
    }

    $('.manage-button').click(manage_click);
    update_button();
}

function manage_click(ev) {
    let btn = $(ev.target);
    let manage_id = btn.data('manage');
    let user_id = btn.data('user-id');

    if(manage_id == "") {
        manage_user(user_id);
    } else {
        unmanage_user(user_id, manage_id);
    }
}

function manage_user(user_id) {
    let text = JSON.stringify({
        manage: {
            manager_id: current_user_id,
            managee_id: parseInt(user_id),
        }

    });

    $.ajax(manage_path, {
        method: "POST",
        dataType: "json",
        contentType: "application/json; charset=UTF-8",
        data: text,
        error: console.log(text),
        success: (resp) => {set_button(user_id, resp.data.id);},
    });
}

function unmanage_user(user_id, manage_id) {

    $.ajax(manage_path + "/" + manage_id, {
        method: "DELETE",
        dataType: "json",
        contentType: "application/json; charset=UTF-8",
        data: "{}",
        success: (_resp) => {set_button(user_id, "");},
    });
}

function set_button(user_id, manage_id) {
    $('.manage-button').each( (_, btn) => {
        if (user_id == $(btn).data('user-id')) {
            $(btn).data('manage', manage_id);
        }
    });

    update_button();
    location.reload();
}

function update_button() {
    $('.manage-button').each( (_, btn) => {
        if($(btn).data('manage') == "") {
            $(btn).text("Manage");
        } else {
            $(btn).text("Unmanage");
        }
    });

}

$(init_manages);