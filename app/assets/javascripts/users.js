var ready = function () {
        $('.js-activated').dropdownHover().dropdown();

    /**
     * When the send message link on our home page is clicked
     * send an ajax request to our rails app with the sender_id and
     * recipient_id
     */

    $('.start-conversation').click(function (e) {
        e.preventDefault();

        var sender_id = $(this).data('sid');
        var recipient_id = $(this).data('rip');

        $.post("/conversations", { sender_id: sender_id, recipient_id: recipient_id }, function (data) {
            $(".chatbox").remove();
            chatBox.chatWith(data.conversation_id,true);
        }).fail(function(data) {
            if(data.status == 401)
                window.location.href="/users/sign_in"
        });
    });

    /**
     * Used to minimize the chatbox
     */
    $(document).on('submit','.new_message',function(){
        $(".emoticon-div").hide();
    });

    $(document).on('click', '.toggleChatBox', function (e) {
        e.preventDefault();

        var id = $(this).data('cid');
        chatBox.toggleChatBoxGrowth(id);
    });

    /**
     * Used to close the chatbox
     */

    $(document).on('click', '.closeChat', function (e) {
        e.preventDefault();

        var id = $(this).data('cid');
        chatBox.close(id);
    });


    /**
     * Listen on keypress' in our chat textarea and call the
     * chatInputKey in chat.js for inspection
     */

    $(document).on('keydown', '.chatboxtextarea', function (event) {

        var id = $(this).data('cid');
        chatBox.checkInputKey(event, $(this), id);
    });

    /**
     * When a conversation link is clicked show up the respective
     * conversation chatbox
     */

    $('a.conversation').click(function (e) {
        e.preventDefault();

        var conversation_id = $(this).data('cid');
        chatBox.chatWith(conversation_id);
    });
    $('#notifications').on('click','.callback',function(){
        $(this).remove();
        chatBox.chatWith($(this).attr("data-id"),true);
        var count = $("#notifications li").length > 0 ? $("#notifications li").length : "";
        $("#notify_count").html(count);
    })
    $(document).on("click",".emoticon-trig",function(){
        $(this).parents(".chatbox").find(".emoticon-div").toggle();
    })
    $(document).on("click",".emoticon",function(){
        var text = $(this).html();
        $(this).parents(".chatbox").find("#message_body").val(function(index, value) {
            return value + text +' ';
        });
    });
}

$(document).ready(ready);
$(document).on("page:load", ready);