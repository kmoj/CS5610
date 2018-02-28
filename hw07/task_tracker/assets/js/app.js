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

// function init_timers() {
//
//     if(!$(".manage-button")) {
//         return;
//     }
//
//     $('.manage-button').click(manage_click);
//     update_button();
// }


function init_manages() {

    if($(".manage-button")) {
        $('.manage-button').click(manage_click);
        update_button();
    }

    if($(".timer-button")) {
        $('.timer-button').click(timer_click);
    }

    if($(".task-submit-button")) {
        $('.task-submit-button').click(task_submit_click);
    }

    if($(".timeblock-delete-button")) {
        $('.timeblock-delete-button').click(timeblock_delete_click);
    }

    if($(".timeblock-edit-button")) {
        $('.timeblock-edit-button').click(timeblock_edit_click);
    }

    if($(".timeblock-save-button")) {
        $('.timeblock-save-button').click(timeblock_save_click);
    }

    return;

}

 function timeblock_save_click(ev) {

     let btn = $(ev.target);
     let timeblockId = $(btn).data('timeblock-id');
     let taskId = $(btn).data('task-id');
     let newStartTime = "";
     let newEndTime = "";
     let theEditBtn = null;
     let theDeleteBtn = null;
     let theStartInput = null;
     let theEndInput = null;

     $(".timeblock-edit-button").each(function() {
         var btn = $(this);

         if ($(btn).data('timeblock-id') == timeblockId){
             theEditBtn = $(btn);
             //$(btn).css("display", "");
         }
     });

     $(".timeblock-delete-button").each(function() {
         var btn = $(this);

         if ($(btn).data('timeblock-id') == timeblockId){
             theDeleteBtn = $(btn);
             //$(btn).css("display", "");
         }
     });

     $(".timeblock-start-input").each(function() {
         var input = $(this);

         if ($(input).data('timeblock-id') == timeblockId){
             //$(input).css("pointer-events", "none");
             theStartInput = $(input);
             newStartTime = $(input).val();
         }
     });

     $(".timeblock-end-input").each(function() {
         var input = $(this);

         if ($(input).data('timeblock-id') == timeblockId){
             theEndInput = $(input);
             //$(input).css("pointer-events", "none");
             newEndTime = $(input).val();
         }
     });

     let msg = checkStartEndTime(newStartTime, newEndTime);
     console.log("new start time" + newStartTime);
     console.log("msg" + msg);
     if (msg != "") {
         alert("ERROR: " + msg)
         newStartTime = "";
         newEndTime = "";
     }


     let text = JSON.stringify({
         timeblock: {
             end: newEndTime,
             start: newStartTime,
             task_id: taskId,
         }

     });

     $.ajax(timeblocks_path + "/" + timeblockId, {
         method: "PUT",
         dataType: "json",
         contentType: "application/json; charset=UTF-8",
         data: text,
         success: (resp) => { toggleBtnInputDisplay()},
         error: function (jqXHR, textStatus, errorThrown) {
             if (jqXHR.status == 422) {
                 //alert("invalid time input");
             } else {
                 //alert('unexpected error');
             }
         },
     });

     function toggleBtnInputDisplay() {
         $(theEditBtn).css("display", "");
         $(theDeleteBtn).css("display", "");
         $(theStartInput).css("pointer-events", "none");
         $(theEndInput).css("pointer-events", "none");
         $(btn).css("display", "none");
     }


 }

function timeblock_edit_click(ev) {

    let btn = $(ev.target);
    let timeblockId = $(btn).data('timeblock-id');

    $(".timeblock-save-button").each(function() {
        var btn = $(this);

        if ($(btn).data('timeblock-id') == timeblockId){
            $(btn).css("display", "");
        }
    });

    $(".timeblock-delete-button").each(function() {
        var btn = $(this);

        if ($(btn).data('timeblock-id') == timeblockId){
            $(btn).css("display", "none");
        }
    });

    $(".timeblock-start-input").each(function() {
        var input = $(this);

        if ($(input).data('timeblock-id') == timeblockId){
            $(input).css("pointer-events", "");
        }
    });

    $(".timeblock-end-input").each(function() {
        var input = $(this);

        if ($(input).data('timeblock-id') == timeblockId){
            $(input).css("pointer-events", "");
        }
    });

    $(btn).css("display", "none");

}

function timeblock_delete_click(ev) {

    let btn = $(ev.target);
    let timeblock_id = btn.data('timeblock-id');

    let msg = "Are you sure?"

    if (confirm(msg) == true) {
        $.ajax(timeblocks_path + "/" + timeblock_id, {
            method: "DELETE",
            dataType: "json",
            contentType: "application/json; charset=UTF-8",
            data: "{}",
            success: (_resp) => {
                location.reload();
            },
        });
    }
}

function task_submit_click(ev) {
    let btn = $(ev.target);
    let startInput = $(".start-time-input");
    let endInput = $(".end-time-input");
    let timeInput = $(".time-input");
    let startTime = $(startInput).val();
    let endTime = $(endInput).val();
    let startTime2 = $(startInput).val();
    let endTime2 = $(endInput).val();
    let taskId = btn.data('task-id');

    let msg = checkStartEndTime(startTime, endTime);
    if (msg != "") {
        alert("ERROR: " + msg);
        startTime = "";
        endTime = "";
        $(timeInput).val(-1);
    }


    let text = JSON.stringify({
        timeblock: {
            end: endTime,
            start: startTime,
            task_id: parseInt(taskId),
        }

    });

    $.ajax(timeblocks_path, {
        method: "POST",
        dataType: "json",
        contentType: "application/json; charset=UTF-8",
        data: text,
        success: (resp) => {alert("Task update successfully");},
        error: function (jqXHR, textStatus, errorThrown) {
            if (jqXHR.status == 422) {
                //alert("invalid time input");
            } else {
                //alert('unexpected error');
            }
            $(startInput).val(startTime2);
            $(endInput).val(endTime2);
            location.reload();
            alert($(endInput).val());


        },
    });

}

function checkStartEndTime(startTime, endTime) {
    let reg = /^(\d{1,4})(-|\/)(\d{1,2})\2(\d{1,2}) (\d{1,2}):(\d{1,2}):(\d{1,2})$/;
    let r1 = startTime.match(reg);
    let r2 = endTime.match(reg);
    let d1 = new Date(startTime);
    let d2 = new Date(endTime);

    if(r1 == null || r2 == null) {
        return "time format incorrect";
    } else if (Date.parse(d1) - Date.parse(d2) > 0) {
        return "The end time before start time";
    } else {
        return "";
    }

}

function timer_click(ev) {
    let btn = $(ev.target);
    let startInput = $(".start-time-input");
    let endInput = $(".end-time-input");
    let timeInput = $(".time-input");
    let action = btn.data('action');
    var date = new Date();
    let dateTimeString = formatDateTime(date);

    if(action == "start") {

        $(startInput).val(dateTimeString);
        $(endInput).val("");
        $(btn).text("End");
        $(btn).data('action', "end");

    } else if (action == "end") {

        $(endInput).val(dateTimeString);
        $(btn).text("Start");
        $(btn).data('action', "start");

        let startTime = $(startInput).val();

        var t1 = startTime.replace(/\-/g, "/");
        var date1 = new Date(t1);

        let workingTime = parseInt((date - date1) / 1000 / 60);

        $(timeInput).val(workingTime);
    }

}

function formatDateTime(date) {

    let dateSeparator = "-";
    let timeSeparator = ":";
    let strmonth = date.getMonth() + 1;
    let strDate = date.getDate();
    let strHH = date.getHours();
    let strMM = date.getMinutes();
    let strSS = date.getSeconds();

    if (strmonth >= 1 && strmonth <= 9) {
        strmonth = "0" + strmonth;
    }

    if (strDate >= 0 && strDate <= 9) {
        strDate = "0" + strDate;
    }

    if (strHH >= 0 && strHH <= 9) {
        strHH = "0" + strHH;
    }

    if (strMM >= 0 && strMM <= 9) {
        strMM = "0" + strMM;
    }

    if (strSS >= 0 && strSS <= 9) {
        strSS = "0" + strSS;
    }

    var currentdate = date.getFullYear() + dateSeparator + strmonth + dateSeparator + strDate +
                      " " + strHH + timeSeparator + strMM + timeSeparator
                      + strSS;

    return currentdate;
}


function manage_click(ev) {
    let btn = $(ev.target);
    let manage_id = btn.data('manage');
    let user_id = btn.data('user-id');
    let current_user_id = btn.data('current-user-id');

    if(manage_id == "") {
        manage_user(user_id, current_user_id);
    } else {
        unmanage_user(user_id, manage_id);
    }
}

function manage_user(user_id, current_user_id) {
    let text = JSON.stringify({
        manage: {
            manager_id: parseInt(current_user_id),
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

    let msg = "Are you sure? Uncompleted assigned tasks will also be deleted"

    if (confirm(msg) == true) {
        $.ajax(manage_path + "/" + manage_id, {
            method: "DELETE",
            dataType: "json",
            contentType: "application/json; charset=UTF-8",
            data: "{}",
            success: (_resp) => {
                set_button(user_id, "");
            },
        });
    }
}

function set_button(user_id, manage_id) {
    $('.manage-button').each( (_, btn) => {
        if (user_id == $(btn).data('user-id')) {
            $(btn).data('manage', manage_id);
        }
    });

    //update_button();
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