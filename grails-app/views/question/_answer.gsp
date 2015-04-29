<%@ page import="au.org.ala.taxonoverflow.QuestionType" %>
<g:set var="answerProperties" value="${new groovy.json.JsonSlurper().parseText(answer.darwinCore)}"/>
<div class="panel ${answer.accepted ? 'panel-success' : 'panel-default'} answer">
    <div class="panel-heading answer-panel">
        <to:ifCanEditAnswer answer="${answer}">
        <ul class="list-inline pull-right">
            <li class=" font-xsmall">
                <a href="${g.createLink(controller: 'dialog', action: 'editAnswerDialog', id: answer.id)}"
                   aa-refresh-zones="answerDialogZone"
                   aa-js-after="$('#answerModalDialog').modal('show')">
                    <i class="fa fa-edit" title="Edit answer"></i>
                </a>
            </li>
            <li class=" font-xsmall">
                <a href="${g.createLink(controller: 'webService', action: 'deleteAnswer', id: answer.id)}" class="delete-answer-btn">
                    <i class="fa fa-trash" title="Delete answer"></i>
                </a>
            </li>
        </ul>
        </to:ifCanEditAnswer>
        <h4>${answer.accepted ? 'Accepted answer' : 'Answer'}</h4>
    </div>
    <div class="panel-body">
        <div class="row">
            <div class="col-md-8">
                <div class="padding-bottom-1">
                    <g:set var="questionTypeTemplate" value="${[
                            (QuestionType.IDENTIFICATION): 'questionType/identificationIssue',
                            (QuestionType.GEOCODING_ISSUE): 'questionType/geospatialIssue'
                    ]}"/>
                    <g:render template="${questionTypeTemplate[answer.question.questionType]}" model="${[answerProperties: answerProperties]}"/>
                    <small>Posted by <span class="comment-author"><to:userDisplayName user="${answer.user}"/></span> <prettytime:display date="${answer.dateCreated}"/></small>
                </div>
            </div>
            <div class="col-md-offset-1 col-md-3 votes">
                <g:set var="answerVoteTotal" value="${answerVoteTotals[answer]}"/>
                <p><span class="stat__number">${answerVoteTotal ?: 0}</span> votes</p>
            </div>
        </div>
    </div>
    <div class="panel-footer">
        <to:ifUserIsLoggedIn>
        <a class="btn btn-primary" href="${g.createLink(controller: 'dialog', action: 'addAnswerCommentDialog', id: answer.id)}"
           aa-refresh-zones="answerCommentDialogZone"
           aa-js-after="$('#answerCommentModalDialog').modal('show')">
            Add a comment
        </a>
        <div class="btn btn-group voting-group">
            <g:set var="userVote" value="${userVotes[answer]}"/>
            <g:set var="isUpVote" value="${userVote?.voteValue > 0}"/>
            <a class="btn btn-default thumbs ${isUpVote ? 'active' : ''}" href="${g.createLink(controller: 'webService', action: 'castVoteOnAnswer', params: [id: answer.id, dir: isUpVote ? 0 : 1 , userId: to.currentUserId()])}">
                <i class="fa ${isUpVote ? 'fa-thumbs-up' : 'fa-thumbs-o-up'}"></i>
            </a>
            <g:set var="isDownVote" value="${userVote?.voteValue && userVote?.voteValue < 0}"/>
            <a class="btn btn-default thumbs ${isDownVote ? 'active' : ''}" href="${g.createLink(controller: 'webService', action: 'castVoteOnAnswer', params: [id: answer.id, dir: isDownVote ? 0 : -1, userId: to.currentUserId()])}">
                <i class="fa ${isDownVote ? 'fa-thumbs-down' : 'fa-thumbs-o-down'}"></i>
            </a>
        </div>
        </to:ifUserIsLoggedIn>
        <to:ifCanAcceptAnswer answer="${answer}">
            <a class="btn ${answer.accepted ? 'btn-default' : 'btn-success'} accept-answer-btn" href="${g.createLink(controller: 'webService', action: answer.accepted ? 'unacceptAnswer' : 'acceptAnswer', id: answer.id)}">
                ${answer.accepted ? 'Unaccept' : 'Accept'} answer
            </a>
        </to:ifCanAcceptAnswer>
    </div>
    <g:render template="answerComments" model="[answer: answer]"/>
</div>
<aa:zone id="answerCommentDialogZone"></aa:zone>