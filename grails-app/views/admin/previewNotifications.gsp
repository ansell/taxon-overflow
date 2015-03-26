<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="toadmin"/>
    <title>Preview Email Notifications | Atlas of Living Australia</title>
</head>
<body class="content">
<content tag="pageTitle">Preview Email Notifications</content>
<ul class="nav nav-tabs" id="notifications">
    <li class="active"><a href="#comments" data-toggle="tab">Comments</a></li>
    <li><a href="#answers" data-toggle="tab">Answers</a></li>
    <li><a href="#tags" data-toggle="tab">Tags</a></li>
</ul>

<div class="tab-content">
    <div class="tab-pane active" id="comments">
        <p>Last 5 comments:</p>
        <table class="table">
            <thead>
            <tr>
                <th>Comment Type</th>
                <th>Question/Answer ID</th>
                <th>Comment</th>
                <th>Action</th>
            </tr>
            </thead>
            <g:each in="${comments}" var="comment">
                <tr>
                    <td>
                        ${comment instanceof au.org.ala.taxonoverflow.QuestionComment ? 'Question Comment' : 'Answer Comment'}
                    </td>
                    <td>
                        ${comment instanceof au.org.ala.taxonoverflow.QuestionComment ? comment.questionId : comment.answerId}
                    </td>
                    <td>
                        <i>${comment.comment.length() > 50 ? "\"${comment.comment.substring(0, 49)}...\"" : "\"${comment.comment}\""}</i>
                    </td>
                    <td>
                        <a href="#" class="btn btn-ala btn-small"> Preview</a>
                    </td>
                </tr>
            </g:each>
        </table>

    </div>
    <div class="tab-pane" id="answers">...</div>
    <div class="tab-pane" id="tags">...</div>
</div>

<script>
    $(function() {
        $('#notifications a').click(function (e) {
            e.preventDefault();
            $(this).tab('show');
        })
    });
</script>
</body>
</html>