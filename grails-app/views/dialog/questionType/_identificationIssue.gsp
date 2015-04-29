<g:set var="answerProperties" value="${answer? new groovy.json.JsonSlurper().parseText(answer.darwinCore) : [:]}"/>
<div class="modal-header">
    <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
    <h4 class="modal-title" id="myModalLabel">${answer ? 'Edit' : 'Add'} an Identification</h4>
</div>
<div class="modal-body">
    <div class="alert alert-danger" role="alert" style="display: none;">
        <span class="alertText"></span>
    </div>
    <div class="form-group">
        <label for="scientificName" class="col-sm-3 control-label">Scientific name</label>
        <div class="col-sm-8">
            <g:textField class="form-control taxon-select taxon-select-scientific" name="scientificName" value="${answerProperties?.scientificName}" placeholder="Enter a scientific name"/>
            <g:hiddenField class="answer-field taxon-select-guid" name="taxonConceptID" value="${answerProperties?.taxonConceptID}"/>
        </div>
    </div>
    <div class="form-group">
        <label for="commonName" class="col-sm-3 control-label">Common name</label>
        <div class="col-sm-8">
            <g:textField class="form-control taxon-select-common" name="commonName" value="${answerProperties?.commonName}" placeholder="Enter a common name"/>
        </div>
    </div>
    <div class="form-group">
        <label for="description" class="col-sm-3 control-label">Comments or remarks</label>
        <div class="col-sm-8">
            <g:textArea class="form-control" name="description" placeholder="Enter your comments or remarks" rows="4">${answerProperties?.description}</g:textArea>
        </div>
    </div>
</div>
<div class="modal-footer">
    <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
    <button type="button" class="btn btn-primary" id="submitAnswerButton">${answer ? 'Edit' : 'Add'} identification</button>
</div>