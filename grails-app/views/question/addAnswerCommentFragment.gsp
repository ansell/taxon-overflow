<div class="row-fluid" style="margin-top: 10px">
    <div class="span10">
        <g:textArea class="span12" name="comment${answer.id}" rows="2"/>
    </div>
    <div class="span2">
        <button type="button" id="btnAddAnswerComment${answer.id}" class="btn btn-small btnAddAnswerComment">Add comment</button>
    </div>
</div>

<script>

    $("#comment${answer.id}").focus();

    $("#btnAddAnswerComment${answer.id}").click(function(e) {
        e.preventDefault();
        var answerId = $(this).closest("[answerId]").attr("answerId");
        var comment = $("#comment${answer.id}").val();
        if (answerId && comment) {
            var data = {
                answerId: answerId,
                comment: comment,
                userId: "<to:currentUserId />"
            };
            tolib.doJsonPost("${createLink(controller:'webService', action:'addAnswerComment')}", data).done(function(response) {
                if (response.success) {
                    // redraw this answer...
                    if (renderAnswer && renderAnswer instanceof Function) {
                        renderAnswer(answerId);
                    }
                } else {
                    alert(response.message);
                }
            });
        }

    });

</script>