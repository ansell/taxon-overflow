<aa:zone id="answersZone">
    <a aa-refresh-zones="answersZone" id="refreshAnswersLink" href="${g.createLink(controller: 'question', action: 'answers', id: question.id)}" class="hidden">Refresh</a>
    <div class="padding-bottom-1">
        <!-- Alert page information -->
        <div class="alert alert-info alert-dismissible" role="alert">
            <button type="button" class="close" data-dismiss="alert" aria-label="Close"><span aria-hidden="true">&times;</span></button>
            <strong>Add your identification answers.</strong>
            Add an answer to the topic question or add comments to existing answers.
        </div>
        <!-- End alert page information -->
    </div>
    <div class="btn-group padding-bottom-1">
        <!-- <p>Help the ALA by adding an answer or comments to existing answers.</p> -->
        <a class="btn btn-primary btn-lg" href="${g.createLink(controller: 'dialog', action: 'addAnswerDialog', id: question.id)}"
           aa-refresh-zones="answerDialogZone"
           aa-js-after="$('#answerModalDialog').modal('show')">
            Add an identification
        </a>
        <aa:zone id="answerDialogZone"></aa:zone>
    </div>

    <g:if test="${!answers || answers.size == 0}">
        <p>No answers posted yet.</p>
    </g:if>
    <g:each in="${answers}" var="answer">
        <g:render template="answer" model="[answer: answer, userVotes: userVotes, answerVoteTotals: answerVoteTotals]"/>
    </g:each>
</aa:zone>
